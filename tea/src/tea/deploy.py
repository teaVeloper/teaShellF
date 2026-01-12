from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, Tuple
import os
import time
import yaml


@dataclass(frozen=True)
class LinkSpec:
    name: str
    src: Path
    dest: Path


def _expand(p: str) -> Path:
    return Path(os.path.expandvars(os.path.expanduser(p))).resolve()


def load_targets(targets_dir: Path, targets: Iterable[str]) -> list[LinkSpec]:
    specs: list[LinkSpec] = []
    for t in targets:
        yml = targets_dir / f"{t}.yml"
        if not yml.exists():
            raise FileNotFoundError(f"Target file not found: {yml}")
        data = yaml.safe_load(yml.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError(f"{yml} must be a mapping")

        # support both styles:
        # 1) mapping of name -> {src, dest}
        # 2) links: [{src, dest, name?}]
        if "links" in data:
            links = data["links"]
            if not isinstance(links, list):
                raise ValueError(f"{yml}: links must be a list")
            for i, item in enumerate(links):
                if not isinstance(item, dict):
                    raise ValueError(f"{yml}: links[{i}] must be a mapping")
                name = str(item.get("name", f"{t}:{i}"))
                src = str(item["src"])
                dest = str(item["dest"])
                specs.append(LinkSpec(name=name, src=_expand(src), dest=_expand(dest)))
        else:
            for name, item in data.items():
                if not isinstance(item, dict):
                    raise ValueError(f"{yml}: '{name}' must be a mapping")
                specs.append(LinkSpec(
                    name=str(name),
                    src=_expand(str(item["src"])),
                    dest=_expand(str(item["dest"])),
                ))

    return specs


def _backup_path(dest: Path) -> Path:
    bk = dest.with_name(dest.name + ".bk")
    if not bk.exists():
        return bk
    ts = time.strftime("%Y%m%d-%H%M%S")
    return dest.with_name(dest.name + f".bk.{ts}")


def apply_links(specs: list[LinkSpec], *, force: bool, backup: bool, dry_run: bool) -> tuple[int, list[str]]:
    problems: list[str] = []
    changed = 0

    for s in specs:
        src = s.src
        dest = s.dest

        if not src.exists():
            problems.append(f"[MISSING SRC] {s.name}: {src}")
            continue

        dest.parent.mkdir(parents=True, exist_ok=True)

        if dest.exists() or dest.is_symlink():
            # if correct symlink, ok
            if dest.is_symlink():
                try:
                    current = dest.resolve()
                except FileNotFoundError:
                    current = None
                if current is not None and current == src:
                    continue  # already correct
                # broken or wrong symlink
                if not (force or backup):
                    problems.append(f"[CONFLICT] {s.name}: dest is symlink but not expected: {dest} -> {dest.readlink()}")
                    continue
            else:
                # regular file/dir
                if not (force or backup):
                    problems.append(f"[CONFLICT] {s.name}: dest exists and is not symlink: {dest}")
                    continue

            if dry_run:
                changed += 1
                continue

            if backup:
                bk = _backup_path(dest)
                dest.rename(bk)
            elif force:
                if dest.is_dir():
                    # dangerous; only remove empty dir automatically
                    try:
                        dest.rmdir()
                    except OSError:
                        problems.append(f"[REFUSE] {s.name}: dest is a non-empty directory (won't delete): {dest}")
                        continue
                else:
                    dest.unlink(missing_ok=True)

        if dry_run:
            changed += 1
            continue

        # Create symlink
        # Use absolute symlink for simplicity and robustness.
        dest.symlink_to(src)
        changed += 1

    return changed, problems


def health_links(specs: list[LinkSpec]) -> tuple[list[str], list[str], list[str]]:
    broken: list[str] = []
    collisions: list[str] = []
    missing: list[str] = []

    for s in specs:
        dest = s.dest
        src = s.src

        if not dest.exists() and not dest.is_symlink():
            missing.append(f"[MISSING] {s.name}: {dest}")
            continue

        if dest.is_symlink():
            try:
                resolved = dest.resolve(strict=True)
            except FileNotFoundError:
                broken.append(f"[BROKEN] {s.name}: {dest} -> {dest.readlink()}")
                continue
            if resolved != src:
                collisions.append(f"[WRONG] {s.name}: {dest} -> {dest.readlink()} (expected {src})")
            continue

        # exists but not symlink
        collisions.append(f"[COLLISION] {s.name}: {dest} exists (not symlink)")

    return broken, collisions, missing


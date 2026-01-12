from __future__ import annotations
from pathlib import Path
from typing import Optional, Set, List
import typer

from .paths import TeaPaths
from .manifest import Manifest
from . import gitops
from .deploy import load_targets, apply_links, health_links

app = typer.Typer(add_completion=False, help="teagarden manager")


def _load_manifest() -> tuple[TeaPaths, Manifest]:
    paths = TeaPaths.discover()
    if not paths.manifest_path.exists():
        raise typer.Exit(f"Manifest not found at {paths.manifest_path}. Is teashellf cloned into TEAGARDEN_HOME?")
    return paths, Manifest.load(paths.manifest_path)


def _parse_tags(tags: Optional[str]) -> Set[str]:
    if not tags:
        return {"core"}
    return {t.strip() for t in tags.split(",") if t.strip()}


def _clone_selected(paths: TeaPaths, m: Manifest, tags: Set[str], all_optional: bool, https_only: bool, ssh_first: bool) -> int:
    selected = m.select(tags=tags, include_optional=all_optional)
    failures = 0

    for name, spec in selected.items():
        dest = paths.teagarden_home / spec.path
        if dest.exists() and gitops.is_git_repo(dest):
            continue
        if dest.exists() and not gitops.is_git_repo(dest):
            typer.echo(f"[SKIP] {name}: path exists but is not a git repo: {dest}")
            failures += 1
            continue

        if https_only:
            ok, msg = gitops.clone_repo(dest, spec.url_https)
            if not ok:
                typer.echo(f"[FAIL] clone {name} via HTTPS:\n{msg}")
                failures += 1
            else:
                typer.echo(f"[OK] cloned {name} -> {dest}")
            continue

        if ssh_first:
            ok, msg = gitops.clone_repo(dest, spec.url_ssh)
            if ok:
                typer.echo(f"[OK] cloned {name} (SSH) -> {dest}")
                continue
            typer.echo(f"[WARN] SSH clone failed for {name}, retrying HTTPS...")
            ok2, msg2 = gitops.clone_repo(dest, spec.url_https)
            if not ok2:
                typer.echo(f"[FAIL] clone {name} via HTTPS after SSH failure:\n{msg}{msg2}")
                failures += 1
            else:
                typer.echo(f"[OK] cloned {name} (HTTPS) -> {dest}")
        else:
            ok, msg = gitops.clone_repo(dest, spec.url_https)
            if not ok:
                typer.echo(f"[FAIL] clone {name} via HTTPS:\n{msg}")
                failures += 1
            else:
                typer.echo(f"[OK] cloned {name} -> {dest}")

    return failures


@app.command()
def bootstrap(
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
    update: bool = typer.Option(False, "--update", help="After clone, update existing repos (ff-only)."),
):
    """Bootstrap using HTTPS only (safe first install)."""
    paths, m = _load_manifest()
    failures = _clone_selected(paths, m, _parse_tags(tags), all, https_only=True, ssh_first=False)
    if update:
        _update(paths, m, _parse_tags(tags), all)
    # deploy default base target
    _deploy(paths, m, targets="base", force=False, backup=False, dry_run=False)
    raise typer.Exit(1 if failures else 0)


@app.command()
def install(
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
    update: bool = typer.Option(False, "--update", help="After clone, update existing repos (ff-only)."),
):
    """Install using SSH first, fallback to HTTPS."""
    paths, m = _load_manifest()
    failures = _clone_selected(paths, m, _parse_tags(tags), all, https_only=False, ssh_first=True)
    if update:
        _update(paths, m, _parse_tags(tags), all)
    _deploy(paths, m, targets="base", force=False, backup=False, dry_run=False)
    raise typer.Exit(1 if failures else 0)


@app.command()
def clone(
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
    update: bool = typer.Option(False, "--update", help="Update existing repos after clone (ff-only)."),
    https_only: bool = typer.Option(False, "--https-only", help="Force HTTPS (no SSH attempt)."),
):
    """Clone missing repos (no deploy)."""
    paths, m = _load_manifest()
    failures = _clone_selected(paths, m, _parse_tags(tags), all, https_only=https_only, ssh_first=not https_only)
    if update:
        _update(paths, m, _parse_tags(tags), all)
    raise typer.Exit(1 if failures else 0)


def _update(paths: TeaPaths, m: Manifest, tags: Set[str], all_optional: bool) -> None:
    selected = m.select(tags=tags, include_optional=all_optional)
    for name, spec in selected.items():
        repo = paths.teagarden_home / spec.path
        if not (repo.exists() and gitops.is_git_repo(repo)):
            continue
        if gitops.git_dirty(repo):
            typer.echo(f"[SKIP] {name}: dirty working tree")
            continue
        ok, msg = gitops.pull_ff_only(repo)
        if ok:
            typer.echo(f"[OK] updated {name}")
        else:
            typer.echo(f"[FAIL] update {name}:\n{msg}")


@app.command()
def update(
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
):
    """Update managed repos (ff-only), skipping dirty repos."""
    paths, m = _load_manifest()
    _update(paths, m, _parse_tags(tags), all)


def _deploy(paths: TeaPaths, m: Manifest, targets: str, force: bool, backup: bool, dry_run: bool) -> None:
    # locate targets dir from teashellf spec
    spec = m.repos["teashellf"]
    targets_dir = (paths.teashellf_home / (spec.targets_dir or "targets")).resolve()
    target_list = [t.strip() for t in targets.split(",") if t.strip()]
    specs = load_targets(targets_dir, target_list)
    changed, problems = apply_links(specs, force=force, backup=backup, dry_run=dry_run)

    typer.echo(f"[DEPLOY] changed={changed} problems={len(problems)}")
    for p in problems:
        typer.echo(p)
    if problems:
        raise typer.Exit(1)


@app.command()
def deploy(
    targets: str = typer.Option("base", help="Comma-separated target files (without .yml)."),
    force: bool = typer.Option(False, "--force", help="Overwrite conflicting destinations."),
    backup: bool = typer.Option(False, "--backup", help="Rename conflicting dest to .bk(.timestamp) then link."),
    dry_run: bool = typer.Option(False, "--dry-run", help="Print what would change, don't modify filesystem."),
):
    """Apply symlink targets from teashellf/targets."""
    paths, m = _load_manifest()
    _deploy(paths, m, targets=targets, force=force, backup=backup, dry_run=dry_run)


@app.command()
def status(
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
):
    """Show presence + git state for managed repos."""
    paths, m = _load_manifest()
    selected = m.select(tags=_parse_tags(tags), include_optional=all)

    for name, spec in selected.items():
        repo = paths.teagarden_home / spec.path
        if not (repo.exists() and gitops.is_git_repo(repo)):
            typer.echo(f"[MISSING] {name}: {repo}")
            continue
        branch = gitops.get_branch(repo)
        dirty = "dirty" if gitops.git_dirty(repo) else "clean"
        typer.echo(f"[OK] {name}: {repo} ({branch}, {dirty})")


@app.command()
def health(
    targets: str = typer.Option("base", help="Comma-separated target files (without .yml)."),
    broken_only: bool = typer.Option(False, "--broken-only", help="Only show broken symlinks."),
):
    """Check symlinks described by targets and report broken/missing/collisions."""
    paths, m = _load_manifest()
    spec = m.repos["teashellf"]
    targets_dir = (paths.teashellf_home / (spec.targets_dir or "targets")).resolve()

    target_list = [t.strip() for t in targets.split(",") if t.strip()]
    specs = load_targets(targets_dir, target_list)

    broken, collisions, missing = health_links(specs)

    if broken_only:
        for b in broken:
            typer.echo(b)
        raise typer.Exit(1 if broken else 0)

    for b in broken:
        typer.echo(b)
    for c in collisions:
        typer.echo(c)
    for ms in missing:
        typer.echo(ms)

    problems = len(broken) + len(collisions) + len(missing)
    typer.echo(f"[HEALTH] broken={len(broken)} collisions={len(collisions)} missing={len(missing)}")
    raise typer.Exit(1 if problems else 0)


@app.command()
def remotes(
    to: str = typer.Argument(..., help="Switch remotes: 'ssh' or 'https'"),
    tags: Optional[str] = typer.Option(None, help="Comma-separated tags (default: core)."),
    all: bool = typer.Option(False, "--all", help="Include optional repos that match the tags."),
):
    """Switch origin URLs for managed repos."""
    paths, m = _load_manifest()
    selected = m.select(tags=_parse_tags(tags), include_optional=all)

    to = to.lower().strip()
    if to not in {"ssh", "https"}:
        raise typer.Exit("to must be 'ssh' or 'https'")

    for name, spec in selected.items():
        repo = paths.teagarden_home / spec.path
        if not (repo.exists() and gitops.is_git_repo(repo)):
            typer.echo(f"[SKIP] {name}: not present")
            continue
        url = spec.url_ssh if to == "ssh" else spec.url_https
        ok, msg = gitops.set_remote_origin(repo, url)
        if ok:
            typer.echo(f"[OK] {name}: origin -> {to}")
        else:
            typer.echo(f"[FAIL] {name}: {msg}")


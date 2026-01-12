from __future__ import annotations
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple
import yaml


@dataclass(frozen=True)
class RepoSpec:
    name: str
    path: str
    url_https: str
    url_ssh: str
    tags: Tuple[str, ...]
    optional: bool = False
    aliases: Tuple[str, ...] = ()
    targets_dir: Optional[str] = None


@dataclass(frozen=True)
class Manifest:
    contract_version: int
    repos: Dict[str, RepoSpec]
    alias_map: Dict[str, str] = field(default_factory=dict)

    @staticmethod
    def load(path: Path) -> "Manifest":
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError("manifest.yml must be a mapping")

        cv = int(data.get("contract_version", 0))
        if cv != 1:
            raise ValueError(f"Unsupported contract_version={cv} (expected 1)")

        repos_raw = data.get("repos", {})
        if not isinstance(repos_raw, dict):
            raise ValueError("repos must be a mapping")

        repos: Dict[str, RepoSpec] = {}
        alias_map: Dict[str, str] = {}

        for name, r in repos_raw.items():
            if not isinstance(r, dict):
                raise ValueError(f"repo '{name}' must be a mapping")

            spec = RepoSpec(
                name=name,
                path=str(r["path"]),
                url_https=str(r["url_https"]),
                url_ssh=str(r["url_ssh"]),
                tags=tuple(r.get("tags", [])),
                optional=bool(r.get("optional", False)),
                aliases=tuple(r.get("aliases", []) or []),
                targets_dir=(str(r["targets_dir"]) if "targets_dir" in r else None),
            )
            repos[name] = spec

            # Build alias mapping (including canonical name)
            def add_alias(a: str) -> None:
                if a in alias_map and alias_map[a] != name:
                    raise ValueError(f"Alias collision: '{a}' maps to both '{alias_map[a]}' and '{name}'")
                alias_map[a] = name

            add_alias(name)
            for a in spec.aliases:
                add_alias(a)

        return Manifest(contract_version=cv, repos=repos, alias_map=alias_map)

    def resolve_name(self, name_or_alias: str) -> str:
        if name_or_alias not in self.alias_map:
            raise KeyError(f"Unknown repo '{name_or_alias}'")
        return self.alias_map[name_or_alias]

    def select(
        self,
        tags: Set[str],
        include_optional: bool,
    ) -> Dict[str, RepoSpec]:
        selected: Dict[str, RepoSpec] = {}
        for name, spec in self.repos.items():
            if not tags.intersection(spec.tags):
                continue
            if spec.optional and not include_optional:
                continue
            selected[name] = spec
        return selected


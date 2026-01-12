from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path
import os


@dataclass(frozen=True)
class TeaPaths:
    teagarden_home: Path
    teashellf_home: Path
    manifest_path: Path

    @staticmethod
    def discover() -> "TeaPaths":
        # 1) Explicit env var wins
        tg = os.environ.get("TEAGARDEN_HOME")
        if tg:
            teagarden_home = Path(os.path.expandvars(os.path.expanduser(tg))).resolve()
        else:
            # 2) Fallback default (no manifest root on purpose)
            teagarden_home = Path.home() / "src" / "teagarden"

        teashellf_home = teagarden_home / "teashellf"
        manifest_path = teashellf_home / "teagarden" / "manifest.yml"
        return TeaPaths(teagarden_home=teagarden_home, teashellf_home=teashellf_home, manifest_path=manifest_path)


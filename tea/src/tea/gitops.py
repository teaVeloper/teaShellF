from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path
import subprocess


def run(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def is_git_repo(path: Path) -> bool:
    return (path / ".git").exists()


def git_dirty(path: Path) -> bool:
    cp = run(["git", "status", "--porcelain"], cwd=path)
    return cp.returncode == 0 and bool(cp.stdout.strip())


def clone_repo(dest: Path, url: str) -> tuple[bool, str]:
    dest.parent.mkdir(parents=True, exist_ok=True)
    cp = run(["git", "clone", url, str(dest)])
    ok = cp.returncode == 0
    msg = cp.stdout + cp.stderr
    return ok, msg


def pull_ff_only(repo: Path) -> tuple[bool, str]:
    cp = run(["git", "pull", "--ff-only"], cwd=repo)
    ok = cp.returncode == 0
    return ok, cp.stdout + cp.stderr


def set_remote_origin(repo: Path, url: str) -> tuple[bool, str]:
    cp = run(["git", "remote", "set-url", "origin", url], cwd=repo)
    ok = cp.returncode == 0
    return ok, cp.stdout + cp.stderr


def get_branch(repo: Path) -> str:
    cp = run(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=repo)
    if cp.returncode != 0:
        return "?"
    return cp.stdout.strip()


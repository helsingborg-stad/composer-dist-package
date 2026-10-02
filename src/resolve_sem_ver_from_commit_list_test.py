import pytest
from src.resolve_sem_ver_from_commit_list import ResolveSemVerFromCommitList
from src.sem_ver import SemVer


def test_resolver_major():
    resolver = ResolveSemVerFromCommitList(
        ["feat!: breaking"], SemVer(2, 1, 3))
    semver = resolver.resolve()

    assert str(semver) == "3.0.0"


def test_resolver_minor():
    resolver = ResolveSemVerFromCommitList(["feat: new feat"], SemVer(2, 1, 3))
    semver = resolver.resolve()

    assert str(semver) == "2.2.0"


def test_resolver_patch():
    resolver = ResolveSemVerFromCommitList(["fix: bug fix"], SemVer(2, 1, 3))
    semver = resolver.resolve()

    assert str(semver) == "2.1.4"


def test_resolver_breaking_change():
    commits = [
        "fix: bug fix",
        "feat!: another breaking change",
        "fix: another bug fix"
    ]

    resolver = ResolveSemVerFromCommitList(commits, SemVer(2, 1, 3))
    semver = resolver.resolve()

    assert str(semver) == "3.0.0"


def test_resolver_multiple_commits():
    commits = [
        "fix: bug fix",
        "feat: new feature",
        "fix: another bug fix"
    ]

    resolver = ResolveSemVerFromCommitList(commits, SemVer(2, 1, 3))
    semver = resolver.resolve()

    assert str(semver) == "2.2.1"


def test_resolver_no_commits_error():
    resolver = ResolveSemVerFromCommitList([], SemVer(2, 1, 3))
    with pytest.raises(ValueError):
        resolver.resolve()

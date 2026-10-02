from src.sem_ver import SemVer


class ResolveSemVerFromCommitList():
    def __init__(self,
                 commit_messages: list[str],
                 previous_version: SemVer):
        self.commit_messages = commit_messages
        self.previous_version = previous_version

    def resolve(self) -> SemVer:
        updated_sem_ver = SemVer(
            self.previous_version.get_major(),
            self.previous_version.get_minor(),
            self.previous_version.get_patch()
        )

        for message in self.commit_messages:
            if self._message_contains_breaking(message):
                updated_sem_ver.increment_major()
                break
            elif self._has_type(message, *self._get_minor_prefixes()):
                updated_sem_ver.increment_minor()
            elif self._has_type(message, *self._get_patch_prefixes()):
                updated_sem_ver.increment_patch()

        if self.previous_version.get_major() == updated_sem_ver.get_major() and self.previous_version.get_minor() == updated_sem_ver.get_minor() and self.previous_version.get_patch() == updated_sem_ver.get_patch():
            raise ValueError(
                "No version change detected from commit messages.")

        return updated_sem_ver

    @staticmethod
    def _message_contains_breaking(message: str) -> bool:
        return message.split(":", 1)[0].endswith("!")

    @staticmethod
    def _get_minor_prefixes() -> list[str]:
        return ["feat", "feature", "minor"]

    @staticmethod
    def _get_patch_prefixes() -> list[str]:
        return ["fix", "chore", "build", "docs", "revert", "refactor", "test", "style", "ci", "perf", ]

    @staticmethod
    def _has_type(message: str, *types: str) -> bool:
        commit_type = message.split(":", 1)[0].split("(", 1)[0]
        return commit_type in types

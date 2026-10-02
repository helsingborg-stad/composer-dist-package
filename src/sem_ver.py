class SemVer:
    def __init__(self, major: int = 0, minor: int = 0, patch: int = 0):
        self.major = major
        self.minor = minor
        self.patch = patch

    def get_major(self) -> int:
        return self.major

    def get_minor(self) -> int:
        return self.minor

    def get_patch(self) -> int:
        return self.patch

    def increment_major(self):
        self.major += 1
        self.minor = 0
        self.patch = 0

    def increment_minor(self):
        self.minor += 1
        self.patch = 0

    def increment_patch(self):
        self.patch += 1

    def __str__(self) -> str:
        return f"{self.major}.{self.minor}.{self.patch}"

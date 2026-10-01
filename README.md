* commit using a conventional commit message
* run ./generateVersion.sh to get the new version number
* run ./updateComposerVersion.sh x.x.x dist.zip
* git commit "release: x.x.x"
* git tag x.x.x
* git push && git push --tags
* build artifact to dist.zip
* create release named x.x.x and upload artifact (dist.zip) to that release
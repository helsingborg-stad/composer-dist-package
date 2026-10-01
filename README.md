* commit using a conventional commit message
* run ./generateVersion.sh to get the new version number
* run ./updateComposerVersin.sh x.x.x dist.zip
* git commit "release: x.x.x"
* build artifact
* create release named x.x.x and upload artifact (dist.zip) to that release
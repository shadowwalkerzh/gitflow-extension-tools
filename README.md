## gitflow-extension-tools
> Manage the branches and versions for your projects (Java/Node/Python...) based on extended gitflow workflow ...

### Gitflow for node
> This is a tool for integrating git flow with node to manage your node project branches and versions, it's extended from two basic tools `git flow` and `npm version`. 

#### How to Install on MAC/Linux?
- Step1: download `gitflow-npm/gffn.sh` file into your local directory and add execution permission `chmod +x gffn.sh` 
- Step2: `ln -sfn "$(pwd)/gffn.sh" /usr/local/bin/gffn`

#### How to Install with One Command?
- `curl "https://raw.githubusercontent.com/shadowwalkerzh/gitflow-extension-tools/master/gitflow-npm/gffn.sh" > ~/gffn.sh && chmod +x ~/gffn.sh && ln -sfn ~/gffn.sh /usr/local/bin/gffn`

#### How to use `gffn` to mange your node project version?

> **Have to checkout to the specific feature/release/hotfix branch before execute finish command**

- ask for help: `gffn -h`

- manage your feature version
    - start a feature branch with a new patch version: `gffn -fs`
    - commit your changes including the version number: `git commit -am 'start a feature'`, `git push origin {feature/branch name}`
    - finish a feature branch: `gffn -ff`; this action will merge current feature branch into develop and delete the feature branch from local and remote repository.

- manage your release version
    - start a release branch with a new minor/major version: `gffn -rs`
    - commit your changes including the version number: `git commit -am 'start a release'`, `git push origin {release/branch name}`
    - finish a release branch: `gffn -rf`; this action will merge current release branch into develop and master branch, and delete the release branch from local and remote repository.

- manage your hotfix version
    - start a hotfix branch with a new patch version: `gffn -hs`
    - commit your changes including the version number: `git commit -am 'start a hotfix'`, `git push origin {hotfix/branch name}`
    - finish a hotfix branch: `gffn -hf`; this action will merge current hotfix branch into develop and master branch, and delete the hotfix branch from local and remote repository.

#### What will it do when starting a new branch(feature/release/hotfix)?
- feature
    - create a new branch with prefix `feature/`
    - switch to this feature branch
    - update current version to next patch version

- release
    - create a new branch with prefix `release/`
    - switch to this release branch
    - update current version to next minor/major version

- hotfix
    - create a new branch with prefix `hotfix/`
    - switch to this hotfix branch
    - update current version to next minor/major version

#### What will it do when finishing a new branch(feature/release/hotfix)?
- feature
    - validate current feature branch
    - merge to develop branch
    - fast commit changes
    - push changes to remote develop branch
    - delete current feature in local and remote repository

- release
    - validate current release branch
    - merge current release branch to master branch
    - fast commit changes
    - create new tag with current version number from current release branch
    - merge current tag into develop branch
    - push local develop changes to remote develop branch
    - push local master changes to remote master branch
    - delete current release in local and remote repository

- hotfix
    - validate current hotfix branch
    - merge current hotfix branch to master branch
    - fast commit changes
    - create new tag with current version number from current hotfix branch
    - merge current tag into develop branch
    - push local develop changes to remote develop branch
    - push local master changes to remote master branch
    - delete current hotfix in local and remote repository

#### Example (locate in project root path)
- create a feature branch and update to next feature version: `gffn -fs`
- commit changes: `git commit -am "start a feature branch"`
- push changes to remote branch: `git push origin {feature/feature_branch}`
- finish feature branch: `gffn -ff`

---

### Gitflow for python

> This is a tool for integrating git flow with bump version to manage your python project branches and versions, it's extended from two basic tools `git flow` and `bumpversion`. 

#### How to Install on MAC/Linux?
- Step1: download `gitflow-python/gffpy.sh` file into your local directory and add execution permission `chmod +x gffpy.sh` 
- Step2: `ln -sfn "$(pwd)/gffpy.sh" /usr/local/bin/gffpy`

#### How to Install with One Command?
- `curl "https://raw.githubusercontent.com/shadowwalkerzh/gitflow-extension-tools/master/gitflow-python/gffpy.sh" > ~/gffpy.sh && chmod +x ~/gffpy.sh && ln -sfn ~/gffpy.sh /usr/local/bin/gffpy`

#### Configuration for python project
- install the latest version of bumpversion: `pip install --upgrade bumpversion`
- add file `__version__.py` in root path of the project to manage version, `__version__.py`:
```
VERSION = '0.0.1'
```
- add bumpversion config file with name `.bumpversion.cfg`:
```
[bumpversion]
current_version = 0.0.1
commit = True
tag = True

[bumpversion:file:__version__.py]

```

#### How to use `gffpy` to mange your python project version?

- ask for help: `gffpy -h`

- manage your feature version
    - start a feature branch with a new patch version: `gffpy -fs`
    - push your changes including the version number: `git push origin {feature/branch name}`
    - finish a feature branch: `gffpy -ff`; this action will merge current feature branch into develop and delete the feature branch from local and remote repository.

- manage your release version
    - start a release branch with a new minor/major version: `gffpy -rs`
    - push your changes including the version number: `git push origin {release/branch name}`
    - finish a release branch: `gffpy -rf`; this action will merge current release branch into develop and master branch, and delete the release branch from local and remote repository.

- manage your hotfix version
    - start a hotfix branch with a new patch version: `gffpy -hs`
    - push your changes including the version number: `git push origin {hotfix/branch name}`
    - finish a hotfix branch: `gffpy -hf`; this action will merge current hotfix branch into develop and master branch, and delete the hotfix branch from local and remote repository.

#### What will it do when starting a new branch(feature/release/hotfix)?
- feature
    - create a new branch with prefix `feature/`
    - switch to this feature branch
    - update current version to next patch version
    - commit changes

- release
    - create a new branch with prefix `release/`
    - switch to this release branch
    - update current version to next minor/major version
    - commit changes

- hotfix
    - create a new branch with prefix `hotfix/`
    - switch to this hotfix branch
    - update current version to next minor/major version
    - commit changes

#### What will it do when finishing a new branch(feature/release/hotfix)?

> **Have to checkout to the specific feature/release/hotfix branch before execute finish command**

- feature
    - validate current feature branch
    - merge to develop branch
    - fast commit changes
    - push changes to remote develop branch
    - delete current feature in local and remote repository

- release
    - validate current release branch
    - merge current release branch to master branch
    - fast commit changes
    - create new tag with current version number from current release branch
    - merge current tag into develop branch
    - push local develop changes to remote develop branch
    - push local master changes to remote master branch
    - delete current release in local and remote repository

- hotfix
    - validate current hotfix branch
    - merge current hotfix branch to master branch
    - fast commit changes
    - create new tag with current version number from current hotfix branch
    - merge current tag into develop branch
    - push local develop changes to remote develop branch
    - push local master changes to remote master branch
    - delete current hotfix in local and remote repository

#### Example (locate in project root path)
- create a feature branch and update to next feature version: `gffpy -fs`
- push changes to remote branch: `git push origin {feature/feature_branch}`
- finish feature branch: `gffpy -ff`


#### References

- [npm version](https://docs.npmjs.com/cli/version)
- [bumpversion](https://github.com/peritus/bumpversion)
- [git-flow](https://github.com/nvie/gitflow)

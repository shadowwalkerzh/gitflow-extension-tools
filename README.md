## gitflow-extension-tools
> Manage the branches and versions for your projects (Java/Node/Python...) based on extended gitflow workflow ...

### Gitflow for node
> This is a tool for integrating git flow with node to manage your project branches and versions, it's extended from two basic tools `git flow` and `npm version`. 

#### How to Install?
- Step1: download `gitflow-npm/gffn.sh` file into your local directory 
- Step2: `ln -sfn "$(pwd)/gffn.sh" /usr/local/bin/gffn`

#### How to use `gffn` to mange your node project version?

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
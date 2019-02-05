# VP
## [Virtualenv](https://virtualenv.pypa.io/en/latest/) and [Pip](https://pip.pypa.io/en/latest/) together

A composite pattern shell script for the Python language to expose a simple interface
to replicate workflows found in NodeJS [npm](https://www.npmjs.com/) and PHP [composer](https://getcomposer.org/) tools.

## Philosophy

A Python project should contain its own environment and packages so that it may be ported to another system
with minimal hassle. The script creates an isolated environment with local packages to start project
development; allowing project reproducibility with standard well tested tools.

Inspired by these articles:

1. @theskumar [article](https://saurabh-kumar.com/blog/virtualenv-vs-virtualenvwrapper.html)
1. @Kwpolska [article](https://chriswarrick.com/blog/2018/07/17/pipenv-promises-a-lot-delivers-very-little/)

## Alternatives

Since its inception, Python still has an issue with package management.
Presented below are alternatives that might be of benefit to other users:

* [hatch](https://github.com/ofek/hatch)
* [pipenv](https://github.com/pypa/pipenv)
* [poetry](https://github.com/sdispater/poetry)
* [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
* [pyvenv|python3 -m venv](https://docs.python.org/3/library/venv.html)

## Install

### Git
```shell
git clone git@github.com:rbrisita/vp.git && cd vp && chmod +x vp.sh && cp vp.sh /usr/local/bin/vp
```

### cURL
```shell
curl --silent https://raw.githubusercontent.com/rbrisita/vp/master/vp.sh -o vp && chmod +x vp && mv vp /usr/local/bin/vp
```

### Wget
```shell
wget --quiet https://raw.githubusercontent.com/rbrisita/vp/master/vp.sh && chmod +x vp.sh && mv vp.sh /usr/local/bin/vp
```

## Usage
	vp <command>
### Commands
|Name|Description|
|-|-|
|-?, -h, --help||
|?, h, help|Display this help message.
|create [args]|Create virtual environment.
|delete|Delete virtual environment.
|enter|Enter virtual environment to start working.
|install [pkg]|Install package and update requirements.txt file.
|uninstall [pkg]|Uninstall package and update requirements.txt file.

### Notes
* To exit out of virtual environment subshell type: exit
* Any arguments for the create command are passed to virtualenv.
* Any commands not on the list (other than create) are passed to pip.

## Example Workflow

### Simplest

Starting a new project:
```shell
vp install numpy
```

If there is a project with a requirements.txt file:
```shell
vp install -r requirements.txt
```

### Need a certain python version
```shell
vp create --python=python2.7
vp install numpy
```

The above commands will take care of creating and entering the default virtual environment and install all listed packages.
The default virtual environment will show on the terminal prompt as `(.virtualenv)`.

## Tested

Tested on Mac OS X v10.13.6 and Bash v3.2.57.

Feel free to fork and PR to create a more POSIX compliant version.

# Ansible Playbooks

In this directory I include `ansible` playbooks that simplify the setup of
parts of my development environment.

## Before you get started

All of the commands referenced in this guide are meant to be done from the root
of the project, not the `ansible` folder. The problem is that, since the
directory of the `playbooks` differ from the directory from where the command is
run you have to do something to access other folders. So, instead of doing any
of this, the `playbooks` expect a variable called `root` that has the direct
directory path for the root of the project. This is why you'll see the command
`--extra-vars="root=$(pwd)`.

Also, all the commands require importing the `requirements.yml` file found at
the root of the project. This file has nothing to do with the `requirements.yml`
file used by `ansible` to keep track of your `collections` and `roles`.

## Playbooks

### `clone.yml`

Takes a list of GitHub/GitLab repositories and installs them inside the
`repos` folder of the project `root`. It is meant to be run with the
`requirements.yml` file found also at the root of the project.

_Command:_

```console
ansible-playbook ansible/clone.yml --extra-vars="root=`pwd`"
```

### `brew.yml`

Takes a list of Homebrew dependencies and installs them to the system. It
is meant to pick the list of `brew` dependencies from the root `requirements.yml`
file.

You **need** to have Homebrew installed before running this command.

_Command:_

```console
ansible-playbook ansible/brew.yml --extra-vars="root=`pwd`"
```

### `tasks.yml`

This playbook runs aditional `tasks` needed by other playbooks. You probably want
to run this playbook before running the `symlink.yml` playbook.

_Command:_

```console
ansible-playbook ansible/tasks.yml --extra-vars="root=`pwd`"
```

### `symlink.yml`

Takes a list of `src/dest` dictionaries and creates a `symlink` using the `find`
module for each one.

You probably want to run the `clone.yml` and `tasks.yml` playbooks before running
this one, since most of the pairs defined in the `requirements.yml` document use
paths created by them.

_Command:_

```console
ansible-playbook ansible/symlink.yml --extra-vars="root=`pwd`"
```

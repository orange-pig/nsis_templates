# nsis_templates

An nsis sample project, corresponding to a Chinese [article](https://juejin.cn/post/7207410405857034301)

## Project structure

```
|---- root
    |---- base
    |---- install
    |---- myapp
```

- `myapp` is a software which is the package target to install.
- `base` base is a project that contains the main structure of the packaging script.
- `install` install is a project that adds installation and uninstallation content on the basis of base.

## How to use

example to make base project's installer execute:

1. move to prorject folder

```
> cd base
```

2. make

```
> makensis .\installer.nsi
```
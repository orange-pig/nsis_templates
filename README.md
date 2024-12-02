# nsis_templates

An nsis sample project, corresponding to a Chinese [article](https://juejin.cn/post/7207410405857034301)

## Project structure

```
Root
├── base
│   └── installer.nsi
├── install
│   └── installer.nsi
├── setup
│   └── myapp_debug.nsi
│   └── myapp_release.nsi
├── myapp
└── resource
```

- `base` base is a project that contains the main structure of the packaging script.
- `install` install is a project that adds installation and uninstallation content on the basis of base.
- `setup` setup is a multi-file project based on install, containing commonly used practical advanced content.
- `myapp` is a software which is the package target to install.
- `resource` is some resource files for packaing.

> All .exe files in myapp are fake text documents

## How to use

example to make base project's installer execute:

1. move to prorject folder, example **base**

```
> cd base
```

2. make

```
> makensis .\installer.nsi
```
# BashX | Bash eXtended

## Description

- **_Bash Framework_**.
- Helps to bash scripting.
- Add common functions to help the developer.
- Compatible with _Android Shell_.

### Why use it

- Very easy to implement.
- No additionals components required.
- No need to learn a new language.
- No need to learn a new syntax.
- Common functions and utils already implemented.

## Quick start

You can start your project with:

```bash
./new-project.sh BASHX_VERSION PROJECT_NAME
```

Where:

- `BASHX_VERSION` is a [_tag_ from this repository](https://github.com/reduardo7/bashx/tags)
- `PROJECT_NAME` is the _script name_.

### Examples

```bash
./new-project.sh 1.0 my-app
./new-project.sh 2.1 ~/projects/my-script.sh
```

#### Project Structure

```text
--> project-directory-name
    |
    +-> my-script-name
    |
    +-> .my-script-name.src
    |
    +-> my-script-name.src/
        |
        +-> actions/
        |   |
        |   +-> [action-name].sh
        |   |
        |   +-> *
        |
        +-> tests/
        |   |
        |   +-> [test-name].sh
        |   |
        |   +-> *
        |
        +-> utils/
        |   |
        |   +-> [util-name].sh
        |   |
        |   +-> *
        |
        +-> resources/
            |
            +-> [resource].[ext]
            |
            +-> *
```

## Doc

Show _Devepopment Documentation_ using:

```bash
./demo _dev-doc
```

## Optimizations

See: [http://tldp.org/LDP/abs/html/optimizations.html](http://tldp.org/LDP/abs/html/optimizations.html)

# Multi-executable Nix project starters

Supported languages: C, C++, Go, Haskell, Java, JavaScript, Ocaml, Python, Rust.

## Nix

[Nix](https://nixos.org/) is a package manager and build system. It's used here to provide a reproducible build/toolchain setup regardless of language.

Installation instructions: https://nixos.org/download/ (if you use Windows, use WSL2 / Docker instructions or install a Unix-like system on your VM).

## Executable layout

Executables are defined using each language's own conventions:

| Starter name | Language | Executable definition |
| --- | --- | --- |
| `c` | C | fallback: `apps/<name>/` |
| `cpp` | C++ | fallback: `apps/<name>/` |
| `go` | Go | command packages, conventionally `cmd/<name>/` |
| `haskell` | Haskell | Cabal `executable` stanzas |
| `java` | Java | fallback: `apps/<name>/` |
| `javascript` | JavaScript | `package.json` `bin` |
| `ocaml` | OCaml | Dune `executable` / `executables` stanzas |
| `python` | Python | `pyproject.toml` `[project.scripts]` |
| `rust` | Rust | Cargo binary targets (`src/bin`, `[[bin]]`) |

For fallback languages, the executable name is the directory name under `apps/`.

The starter name is the identifier used after `#` in the source reference.

## Initializing repository

If you have a repository that already contains the assignment `README.md`, pick the starter name from the table above and initialize project template using:

```bash
nix flake init -t github:fp-ctd-itmo/hw-templates#<starter-name>
```

For example, having personal repository, you can initialize `haskell` project like that:

```bash
git clone git@github.com:<course>/<your-repo>.git
cd <your-repo>
nix flake init -t github:fp-ctd-itmo/hw-templates#haskell
nix build
```

You can also create a new project. Using this command, it will be initialized in directory `my-project`.

```bash
nix flake new my-project -t github:fp-ctd-itmo/hw-templates#haskell
```

The generated project contains language-specific build instructions in `BUILD.md`.

Also, every generated project has the same external build contract:

```bash
nix build
```

All programs produced by the project must appear in `$out/bin/`. The executable names can be chosen.

Generated projects also contain `.github/workflows/grade.yml`. The workflow runs for pull request updates and pushes to `main`. It checks out the repository, builds it with `nix build`, and grades every executable found in `result/bin`. Logs show which checks passed and which failed.

## Development shell

Each generated project provides:

```bash
nix develop
```

with the corresponding compiler/interpreter and primary build tools. No need to manually resolve dependencies.

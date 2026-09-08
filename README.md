# Multi-executable Nix project starters

Supported languages: Go, C++, Rust, Python, JavaScript, Haskell, OCaml, C,
and Java.

Every generated project has the same external build contract:

```bash
nix build
```

All student programs produced by the project must appear in:

```text
$out/bin/
```

The executable names are chosen by the student.

## Principle

Nix does **not** invent a second executable registry when the language ecosystem already has one. Native project metadata remains the source of truth:

| Language | Executable definition |
| --- | --- |
| Go | command packages, conventionally `cmd/<name>/` |
| Rust | Cargo binary targets (`src/bin`, `[[bin]]`) |
| Python | `pyproject.toml` `[project.scripts]` |
| JavaScript | `package.json` `bin` |
| Haskell | Cabal `executable` stanzas |
| OCaml | Dune `executable` / `executables` stanzas |
| C | fallback: `apps/<name>/` |
| C++ | fallback: `apps/<name>/` |
| Java | fallback: `apps/<name>/` |

For fallback languages, the immediate directory name under `apps/` is the executable name.

The grading/build pipeline therefore only needs one language-independent operation:

```bash
out=$(nix build --print-out-paths)
find "$out/bin" -maxdepth 1 -type f -o -type l
```

It does not need to know how each language declares its executables.

## Initializing a student repository

For a repository that already contains the assignment `README.md`, initialize
the language-specific project files inside that existing checkout. Choose the
identifier for the desired language from this table; it is the value entered
after `#` in the source reference.

| Starter name | Language |
| --- | --- |
| `go` | Go |
| `cpp` | C++ |
| `rust` | Rust |
| `python` | Python |
| `javascript` | JavaScript |
| `haskell` | Haskell |
| `ocaml` | OCaml |
| `c` | C |
| `java` | Java |

For example, to initialize a Haskell project:

```bash
git clone git@github.com:<course>/<student-repo>.git
cd <student-repo>
nix flake init -t github:fp-ctd-itmo/hw-templates#haskell
nix build
```

To create a new local project directory instead, use:

```bash
nix flake new my-project -t github:fp-ctd-itmo/hw-templates#haskell
cd my-project
nix build
```

The generated project contains language-specific build instructions in
`BUILD.md`.

Generated projects also contain `.github/workflows/grade.yml`. The workflow
runs for pull request updates and pushes to `main`. It checks out the
repository, builds it with `nix build`, and grades every executable found in
`result/bin`.

For a pull request, the workflow runs `runChecker grade <path-to-binary>`. Its
logs show the student which checks passed and which failed, but do not write a
result to the final grade journal. Once the pull request is merged, the push to
`main` runs `runChecker grade --csplusplus <path-to-binary>`. This produces the
CS++ output format used to record the result in that journal. The `runChecker`
command is expected to be available on the selected GitHub Actions runner.

## Development shell

Each generated project also provides:

```bash
nix develop
```

with the corresponding compiler/interpreter and primary build tools.

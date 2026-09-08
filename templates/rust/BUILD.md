# Rust Build Instructions

Cargo defines the command-line programs for this project. The usual layout is one file per executable under `src/bin/`.

```text
src/bin/
├── hello.rs
└── goodbye.rs
```

A file `src/bin/foo.rs` creates the executable `foo`. For a multi-file program, use `src/bin/foo/main.rs` plus sibling modules. Explicit `[[bin]]` targets in `Cargo.toml` work as well.

Build everything with:

```bash
nix build
```

List the produced executables with:

```bash
ls result/bin
```

Run a program with:

```bash
./result/bin/hello
```

Rust dependencies are configured in `Cargo.toml`. After changing dependencies, update `Cargo.lock` and rebuild so Nix can vendor the exact crate set.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker in CS++ mode and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the CS++ check and updates the final result, but is not
recommended.

# Go Build Instructions

This project uses the standard Go command layout. Each command-line program is a `package main` under `cmd/<name>/`.

```text
cmd/
├── hello/
│   └── main.go
└── goodbye/
    └── main.go
```

Add a new program by creating `cmd/<name>/main.go`. The directory name is the installed executable name.

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

Go modules are configured in `go.mod`. If third-party modules are added, run the build once, copy the hash reported by Nix, and put it into `vendorHash` in `flake.nix`.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker in CS++ mode and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the CS++ check and updates the final result, but is not
recommended.

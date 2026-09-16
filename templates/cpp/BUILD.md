# C++ Build Instructions

This project contains one or more command-line programs. Each immediate directory under `apps/` becomes an executable with the same name.

```text
apps/
├── hello/
│   └── main.cpp
└── goodbye/
    └── main.cpp
```

All `.cpp` files directly inside `apps/<name>/` are compiled together into `result/bin/<name>`.

Add a new program by creating `apps/<name>/` and putting its C++ source files there. The directory name is the installed executable name.

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

If the program needs additional C++ libraries, add the corresponding Nix packages to `buildInputs` in `flake.nix` and update the compile command in `buildPhase` if extra compiler or linker flags are required.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the checker and updates the final result, but is not
recommended.

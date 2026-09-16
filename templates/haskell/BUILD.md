# Haskell Build Instructions

Cabal defines the command-line programs for this project. Each executable must be declared in `student-apps.cabal`.

```cabal
executable hello
  main-is: Main.hs
  hs-source-dirs: app/hello
  build-depends: base

executable goodbye
  main-is: Main.hs
  hs-source-dirs: app/goodbye
  build-depends: base
```

The `hs-source-dirs` field points to the directory containing that program's `Main.hs`. The executable stanza name is the installed command name.

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

If a program needs additional Haskell packages, add them to the relevant `build-depends` list in `student-apps.cabal`.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the checker and updates the final result, but is not
recommended.

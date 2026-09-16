# OCaml Build Instructions

Dune defines the command-line programs for this project. Public executables are installed into `result/bin`.

```lisp
(executables
 (names hello goodbye)
 (public_names hello goodbye)
 (package student_apps))
```

`names` are the OCaml source module names in `bin/`, and `public_names` are the installed command names.

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

Add another program by adding its `.ml` file under `bin/` and updating the executable stanza in `bin/dune`. If the program needs additional OCaml libraries, add them to the `libraries` field in `bin/dune` and to `propagatedBuildInputs` in `flake.nix`.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the checker and updates the final result, but is not
recommended.

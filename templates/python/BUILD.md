# Python Build Instructions

Python packaging metadata defines the command-line programs for this project. Executables are declared as standard `[project.scripts]` entry points in `pyproject.toml`.

```toml
[project.scripts]
hello = "student_apps.hello:main"
goodbye = "student_apps.goodbye:main"
```

Each key is an installed executable name. Each value points to a Python function that takes no arguments and returns the process exit code or `None`.

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

Add another program by adding a `[project.scripts]` entry and the referenced Python function. If Python dependencies are needed, declare them in `pyproject.toml` and mirror them in the Nix package configuration.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker in CS++ mode and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the CS++ check and updates the final result, but is not
recommended.

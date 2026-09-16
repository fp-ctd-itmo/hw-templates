# Java Build Instructions

This project contains one or more command-line programs. Each immediate directory under `apps/` becomes a command with the same name.

```text
apps/
├── hello/
│   └── Main.java
└── goodbye/
    └── Main.java
```

Every `apps/<name>/` directory must contain `Main.java` with a `public static void main(String[] args)` method. Sources in that directory are compiled together, and `result/bin/<name>` launches `Main`.

Add a new program by creating `apps/<name>/Main.java`. The directory name is the installed executable name.

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

If the project needs a different JDK or extra build tools, update `nativeBuildInputs` in `flake.nix`.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the checker and updates the final result, but is not
recommended.

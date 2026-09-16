# Kotlin Build Instructions

This project contains one or more command-line programs. Each immediate directory under `apps/` becomes a command with the same name.

Supported platforms: Linux (x86-64 and ARM64) and macOS (ARM64).

```text
apps/
├── hello/
│   └── Main.kt
└── goodbye/
    └── Main.kt
```

Every `apps/<name>/` directory must contain `Main.kt` with a top-level `fun main(args: Array<String>)` function in the default package. Keep the generated JVM class name `MainKt` (do not override it with `@file:JvmName`). All `.kt` files directly in that directory are compiled together. The command `result/bin/<name>` launches `MainKt` from a JAR that includes the Kotlin runtime.

Add a new program by creating `apps/<name>/Main.kt`. The directory name is the installed executable name.

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

The compiler targets Java 21 bytecode, and the installed commands use the JDK provided by Nix. No system-wide JVM installation is required.

Enter the development environment with:

```bash
nix develop
```

This provides `kotlinc` and the JDK. Add new source files to Git before building a Git checkout so Nix includes them in the build.

If additional JVM libraries are needed, provide their JARs through Nix and add them to both the compiler and launcher classpaths in `flake.nix`. Gradle and Maven configuration are not read by this build. When changing the JDK, also update the compiler target in `buildPhase`.

Compiler documentation: https://kotlinlang.org/docs/command-line.html

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker in CS++ mode and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the CS++ check and updates the final result, but is not
recommended.

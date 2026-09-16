# TypeScript Build Instructions

The `bin` map in `package.json` defines the command-line programs. Each key is
an installed command name, and each value points to compiled JavaScript:

```json
{
  "bin": {
    "hello": "dist/cli/hello.js",
    "goodbye": "dist/cli/goodbye.js"
  }
}
```

Sources live under `src/`. The compiler preserves their directory structure
under `dist/`, so `src/cli/hello.ts` becomes `dist/cli/hello.js`.
Start each command's source file with `#!/usr/bin/env node`.
Add a program by creating its `.ts` source and adding its compiled `.js` path
to `package.json.bin`. Shared modules can live anywhere under `src/`.
Use `.js` extensions in relative imports, for example `import { parse } from
"../parse.js"`; TypeScript resolves the corresponding `.ts` source.

Build all programs with:

```bash
nix build
ls result/bin
./result/bin/hello
```

Nix installs the locked npm dependencies, runs `npm run build`, and installs
the commands with the Node.js runtime. Type errors fail the build.
Compiler settings, including strict checking, are in `tsconfig.json`.
Add new files to Git before building a Git checkout so Nix includes them.

For local development:

```bash
nix develop
npm ci
npm run build
node dist/cli/hello.js
```

To add dependencies, run `npm install <package>` (or `npm install --save-dev
<package>` for development tools) in the development shell. Commit both
`package.json` and `package-lock.json`. After changing the lock file, set
`npmDepsHash` in `flake.nix` to `pkgs.lib.fakeHash`, run `nix build`, and replace
it with the `got: sha256-...` hash reported by Nix. Run `nix build` again to
verify the updated dependencies.

Supported platforms: Linux (x86-64 and ARM64) and macOS (ARM64).
Compiler documentation: https://www.typescriptlang.org/tsconfig/.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker in CS++ mode and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the CS++ check and updates the final result, but is not
recommended.

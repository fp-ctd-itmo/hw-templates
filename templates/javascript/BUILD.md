# JavaScript Build Instructions

The `bin` map in `package.json` defines the command-line programs for this project.

```json
{
  "bin": {
    "hello": "cli/hello.js",
    "goodbye": "cli/goodbye.js"
  }
}
```

Each key is an installed executable name. Each value is the JavaScript file run by Node.js. Referenced scripts should start with:

```javascript
#!/usr/bin/env node
```

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

This project starts with no npm dependencies. If npm packages are added later, update the Nix packaging configuration so the dependency set is reproducible.

## Submitting work

Create a branch and open a pull request into `main`. Creating or updating the
pull request runs the checker for every executable in `result/bin`. The action
logs show which checks passed and failed, but do not record a final result.

After the pull request is merged, the resulting push to `main` runs the
checker and records the result in the final grade journal.

To submit corrections, open another pull request into `main`. A direct push to
`main` also runs the checker and updates the final result, but is not
recommended.

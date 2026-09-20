# Wisdom App

Example application for [wisdom-kit](https://github.com/jeremyfa/wisdom-kit).
A note list, used to exercise the kit's conventions.

```bash
git clone --recurse-submodules https://github.com/jeremyfa/wisdom-app.git
cd wisdom-app
npm install
npm run dev:web      # browser, at http://localhost:5173
npm run dev          # desktop window
```

## What it covers

An observable collection in the root model, a computed value, a controlled
input, keyboard shortcuts, a theme setting, an in-app confirmation dialog, and
a save action that takes a different path in each host: a native dialog and a
real file on the desktop, a download in a browser. The "show in file manager"
button next to it is disabled in a browser, with a tooltip explaining why,
which is how `Platform.can(...)` is meant to be used.

## Layout

The kit is the submodule `lib/wisdom-kit`. It holds the platform layer, the
theme, the UI primitives, the window chrome, the bootstrap, the build pipeline,
the export scripts and the CI. This repository holds:

```
project.config.sh   the names this project builds under
package.json        delegates its commands to the kit
build.hxml          includes the kit's hxml, adds the main class and output
src/app.css         imports the kit's stylesheet, points Tailwind at the sources
src/app/            the application
src-tauri/          Tauri glue: names, capabilities, icons
web/favicon.svg     the icon
```

## Commands

| | |
|---|---|
| `npm run dev` / `dev:web` | build, watch, open the app or serve it |
| `npm run build` | into `dist/web` (`build:release` minifies) |
| `npm run check-config` | compare every file with `project.config.sh` |
| `npm run export mac` | also `linux`, `windows`, `all` |

`node lib/wisdom-kit/cli.mjs --help` lists the rest.

## Starting another project

Use the kit rather than forking this repository:

```bash
node lib/wisdom-kit/scripts/create-app.mjs ../my-app \
    --name "My App" --identifier com.acme.myapp --verify
```

## Conventions

Reactive state, components, styling and the platform layer are documented in
the [kit's README](https://github.com/jeremyfa/wisdom-kit#reactive-state).

## Licence

MIT. See [LICENSE](LICENSE).

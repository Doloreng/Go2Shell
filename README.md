# Go2Shell By AppleScript

Open an iTerm or Terminal window at the front Finder folder.

An applet saved on an older Mac ships an Intel-only `applet` executable. On Apple silicon without Rosetta, macOS refuses to open it. Rebuild on the machine that will run the app. `./build.sh` runs `osacompile` on the current system and produces a universal binary.

The apps checked in here were built on macOS 27. The arm64 slice requires macOS 27. On another macOS version, run `./build.sh` there and use those copies.

## How to use

- Copy the app you want into `/Applications`.
- Hold Command and drag it onto the Finder toolbar.
- Click the icon.

| App | Opens |
| --- | --- |
| `Go2Shell_iTerm.app` | iTerm at the front Finder folder |
| `Go2Shell_iTerm_newWin.app` | a new iTerm window |
| `Go2Shell_Term.app` | Terminal at the front Finder folder |
| `Go2Shell_Term_newWin.app` | a new Terminal window |

## Rebuild

Edit the matching file in `scripts/`, then:

```bash
./build.sh
```

The script keeps `applet.icns` and ad-hoc signs each app. After editing `main.scpt` inside an already built app, sign it again:

```bash
codesign --force --deep --sign - Go2Shell_iTerm.app
```

## Thanks

The main implementation comes from [wonderyue/Go2ShellAppleScript](https://github.com/wonderyue/Go2ShellAppleScript). This repo changes the icon and adds the new-window variants.

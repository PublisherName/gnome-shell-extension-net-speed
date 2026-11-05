# Net Speed Indicator

Show current network speed on the GNOME Shell top panel.

This extension is inspired by <https://github.com/biji/simplenetspeed/> which has some annoying flickers existing for a long time so I decided to create my own alternative. I removed all features that I won't use.

It only shows text like `↓ 777 K/s ↑ 2.33 K/s` on the right part of the panel. No font size changing, no total downloaded bytes, no bits.

## Features

- Displays download and upload speed in the top panel (right side)
- Reads `/proc/net/dev` asynchronously (no synchronous file I/O in Shell code)
- Ignores virtual interfaces (`lo`, `docker`, `virbr`, `br`, `tun`, `tap`, `wg`, `veth`, etc.)
- Auto-scales units: `B/s`, `K/s`, `M/s`, `G/s`, `T/s`, `P/s`, `E/s`, `Z/s`, `Y/s`
- Refreshes every 3 seconds by default
- No preferences UI, no GSettings schema, no external dependencies at runtime

## Requirements

- Fedora 45 (Workstation Edition) or any distro with GNOME Shell 45–51
- GNOME Shell 45, 46, 47, 48, 49, 50, or 51 (tested on GNOME Shell 51.1 / Fedora 45)
- `gjs` (GNOME JavaScript) — provided by `gnome-shell` itself, no separate install needed
- For building/testing only: `zip`, `python3` (3.13+), `uv` (for `shexli` linting)

No runtime dependencies beyond GNOME Shell's built-in GJS modules (`GObject`, `GLib`, `Gio`, `Clutter`, `St`).

## Installation

### Option 1: From source (recommended for Fedora 45)

```bash
git clone https://github.com/psam21/gnome-shell-extension-net-speed.git
cd gnome-shell-extension-net-speed
./install.sh
```

This copies `netspeedindicator@subashghimire.info.np/` to `~/.local/share/gnome-shell/extensions/`.

### Option 2: Direct clone into extensions directory

```bash
git clone https://github.com/psam21/gnome-shell-extension-net-speed.git ~/.local/share/gnome-shell/extensions/netspeedindicator@subashghimire.info.np
```

> Note: cloning the whole repo into the extensions directory works because the extension files live in the `netspeedindicator@subashghimire.info.np/` subdirectory — but the `install.sh` method above is cleaner as it only copies the extension directory.

### Option 3: From extensions.gnome.org

Install from <https://extensions.gnome.org/extension/7367/net-speed-indicator/>.

### Enable

1. Restart GNOME Shell:
   - **X11**: `Alt+F2`, type `r`, press `Enter`
   - **Wayland**: log out and log back in (Shell restart is not available on Wayland)
2. Open **GNOME Extensions** (or run `gnome-extensions enable netspeedindicator@subashghimire.info.np`)
3. Verify the indicator appears on the right side of the top panel

## Configuration

There is no preferences UI. All settings are hardcoded defaults in `netspeedindicator@subashghimire.info.np/utils/config.js`:

| Setting | Default | Description |
|---------|---------|-------------|
| `DEFAULT_REFRESH_INTERVAL` | `3` (seconds) | How often to sample `/proc/net/dev` |
| `DEFAULT_SPEED_UNITS` | `["B/s", "K/s", "M/s", "G/s", "T/s", "P/s", "E/s", "Z/s", "Y/s"]` | Unit labels for auto-scaling |
| `DEFAULT_VIRTUAL_IFACE_PREFIXES` | `["lo", "ifb", "lxdbr", "virbr", "br", "vnet", "tun", "tap", "docker", "utun", "wg", "veth"]` | Interface name prefixes to exclude from speed calculation |

To customize, edit `config.js` and reinstall with `./install.sh`, then restart GNOME Shell.

## How it works

1. `extension.js` creates a `PanelMenu.Button` with a `St.Label` showing `↓ <down> ↑ <up>`
2. Every 3 seconds, it reads `/proc/net/dev` asynchronously via `Gio.File.load_contents_async`
3. It parses each interface line, sums bytes for non-virtual interfaces, and computes `(current - previous) / interval`
4. `utils/utils.js` formats the result with auto-scaling units (e.g., `777 K/s`, `2.33 M/s`)

## Development / Testing

1. Install the linting dependency:
   ```bash
   uv sync
   ```

2. Build a zip (for extensions.gnome.org upload or `shexli`):
   ```bash
   ./build.sh
   ```

3. Lint the zip with `shexli`:
   ```bash
   uv run shexli netspeedindicator@subashghimire.info.np.zip
   ```

4. Install locally and test:
   ```bash
   ./install.sh
   gnome-extensions enable netspeedindicator@subashghimire.info.np
   ```

## Fedora 45 / GNOME Shell 51 notes

- `metadata.json` declares `shell-version: ["45", "46", "47", "48", "49", "50", "51"]`. GNOME Shell marks extensions as **OUT OF DATE** if the running Shell major version is not listed — this was the root cause of the extension stopping after the Fedora 44 → 45 upgrade (GNOME Shell 50 → 51.1).
- The extension uses only stable APIs (`Main.panel.addToStatusArea`, `PanelMenu.Button`, `Gio.File.load_contents_async`) that are unchanged in GNOME Shell 51. No deprecated APIs are used.
- `build.sh` and `install.sh` use `set -euo pipefail` and resolve paths relative to the script location, so they work from any working directory.

## License

GPL-2.0-or-later (see `extension.js` header).

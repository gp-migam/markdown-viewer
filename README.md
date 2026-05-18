# Markdown Viewer

A single-file, offline-capable markdown viewer. Drop a `.md` file on the window
and read it in one of ten color schemes. No build step, no install.

Hosted from this repo's `gh-pages`-style `main` branch — `index.html` is the
whole app. The service worker (`sw.js`) caches the page + CDN libraries so it
keeps working offline once loaded.

## Using it

Three ways to open a document:

- **Drag-and-drop** a `.md` / `.markdown` / `.mkd` / `.txt` file onto the window.
- **Open…** button (or `Ctrl+O`) — file picker.
- **Paste** markdown into the page with `Ctrl+V`.

Then: `Ctrl+B` toggles the outline, `Ctrl+S` exports to a standalone HTML file
(self-contained, no JS dependencies left), `?` opens the shortcut list.

Features baked into `index.html`: marked + DOMPurify for parsing/sanitizing,
highlight.js for code blocks, Mermaid for fenced ` ```mermaid ` diagrams, a
copy-to-clipboard button on every code block, a TOC sidebar built from headings,
print stylesheet, a doc-stats readout (word / reading-time / heading count), and
YAML front-matter (`---…---` at the top of the file) rendered as a metadata card
above the content — `title:` overrides the browser tab and export filename.

## The `.cmd` / `.ps1` launcher trick

`mdviewer.cmd` and `mdviewer.ps1` let you open a local `.md` file in the viewer
straight from Explorer, the Run dialog, or another script — without spinning up
a local web server.

```cmd
mdviewer.cmd "C:\path\to\notes.md"
```

Drop `mdviewer.cmd` (or both files) somewhere on your `PATH`, or right-click →
"Open with…" → set as the default handler for `.md`. The script:

1. Reads the file as bytes (max 1.5 MB — browsers get unreliable past that for
   what comes next).
2. Encodes it as URL-safe base64 (`+/` → `-_`, padding stripped).
3. Opens `file:///…/index.html#md=<base64>&name=<escaped-filename>` in Chrome
   (`--app=` mode), falling back to Edge, then the default browser.

### URL-hash protocol

The viewer reads two params off `location.hash`:

| Param  | Value                                                            |
|--------|------------------------------------------------------------------|
| `md`   | URL-safe base64 of the raw markdown bytes (UTF-8). Padding stripped. |
| `name` | `encodeURIComponent`'d filename — shown in the title bar.        |

Example: `index.html#md=IyBIZWxsbw&name=hello.md`

The data lives entirely in the fragment, so it never hits the network — and
since the viewer runs from `file://`, no server is involved. Anything that can
build that URL can drive the viewer; the PowerShell launcher is just one option.

## Files

| File             | Purpose                                                  |
|------------------|----------------------------------------------------------|
| `index.html`     | The entire app (HTML + CSS + JS).                        |
| `sw.js`          | Service worker — caches the app + CDN libs for offline.  |
| `manifest.json`  | PWA manifest (installable, file-handler registration).   |
| `mdviewer.cmd`   | Windows shim → `mdviewer.ps1`.                           |
| `mdviewer.ps1`   | Builds the `#md=…` URL, launches Chrome/Edge in app mode.|
| `sample.md`      | Loaded by the **Sample** button.                         |
| `icon-*.png`     | PWA icons.                                               |

## Updating the service worker cache

`sw.js` pins assets by a `CACHE` version string. **Bump it whenever
`index.html` (or any cached asset) changes**, otherwise returning users keep
the stale copy until they hard-reload. See commit `c1d4bd7` for the pattern.

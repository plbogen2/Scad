# Scad Projects

A collection of independent, parametric [OpenSCAD](https://openscad.org/) projects — each living in its own subdirectory with its own source files and export script.

## Projects

| Project | Description |
|---|---|
| [`thing-o-matic-atx-plate/`](./thing-o-matic-atx-plate/) | Parametric ATX cutout cover plate for a Thing-O-Matic / Smoothieboard enclosure |
| [`stamp_cookie_cutters/`](./stamp_cookie_cutters/) | Parametric stamp-style cookie cutters in various shapes |

## How It Works

Each project is fully self-contained:

```
scad/
├── my-project/
│   ├── my-project.scad   ← OpenSCAD source
│   ├── export.ps1        ← export script (STL + optional PNG preview)
│   ├── STLs/             ← generated, tracked via Git LFS
│   └── PNGs/             ← generated, tracked via Git LFS
└── .github/
    └── workflows/
        └── export.yml    ← auto-discovers every project and builds them
```

### Adding a New Project

1. Create a new subdirectory for your project
2. Add your `.scad` file(s)
3. Copy `export.ps1` from any existing project and adjust the filename(s)
4. Push — the GitHub Actions workflow auto-discovers any directory containing an `export.ps1` and builds it

No changes to the workflow file are ever needed.

## Running Locally

Requirements: [OpenSCAD](https://openscad.org/downloads.html) installed (Nightly recommended)

```powershell
# Export STL only
.\my-project\export.ps1

# Export STL + PNG preview
.\my-project\export.ps1 -RenderPng
```

## CI / GitHub Actions

On every push to `main` that touches a `.scad`, `.svg`, or `.ps1` file, the workflow:

1. Discovers all subdirectories containing an `export.ps1`
2. Runs each export script in parallel (one job per project)
3. Uploads STLs and PNGs as downloadable workflow artifacts
4. Commits the generated files back to the repo (stored via Git LFS)

> **Note:** GitHub's *Download ZIP* button does **not** resolve Git LFS pointers.  
> Download actual STLs from the **Actions → Artifacts** section of the relevant workflow run.

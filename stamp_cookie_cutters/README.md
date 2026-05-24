# Stamp Cookie Cutters

A collection of parametric cookie cutters, each paired with a matching stamp. Cut the shape and press the stamp into the dough for an embossed design — no extra tools needed.

## Included Shapes

| Shape | Type | Notes |
|---|---|---|
| **Coffin** | Cutter only | Halloween classic, tall 25 mm walls |
| **Tombstone** | Cutter only | Halloween companion to the coffin |
| **Dala Horse** | Cutter + Stamp | Swedish folk art horse; two-piece set |
| **Feliz Navidad** | Cutter + Stamp | Holiday lettering design; two-piece set |
| **Light Bulb** | Cutter + Stamp | Shallower profile, 10 mm cutter walls |
| **Tamale** | Cutter + Stamp | Two-piece set |

Two-piece sets include a **cutter** (the wall that cuts the shape) and a **stamp** (the raised design that embosses the dough surface).

## Print Settings

| Setting | Recommended |
|---|---|
| Material | PETG or food-safe PLA |
| Layer height | 0.15–0.2 mm |
| Walls | 3 perimeters minimum |
| Infill | 15–20% |
| Supports | Not needed |

> **Food safety note:** For direct food contact, use a food-safe filament (food-safe PLA or PETG) with no layer separation. Sand or coat cut edges if desired. Using a food-safe sealant on the finished prints is recommended.

## How to Use

1. Roll dough to 6–8 mm thickness
2. Press the **cutter** straight down and lift cleanly
3. For two-piece sets: press the **stamp** into the centre of the cut shape before baking
4. Bake as normal — the embossed design holds through baking

## Customization

Each cutter is a small `.scad` file in its own folder under `cutters/`. Open it in OpenSCAD to adjust:

| Parameter | Description |
|---|---|
| `base_height` | Thickness of the solid base / grip ring (mm) |
| `stamp_height` | How deep the stamp emboss protrudes (mm) |
| `cutter_height` | Height of the cutting wall (mm) |
| `offset` | Outward offset of the grip ring from the cut edge (mm) |

To create a new shape, add an SVG outline to a new folder and point a new `.scad` file at it using the `cookie()` or `cutter()` module from `lib/stamp_cookie.scad`.

## Files

Each shape folder contains:
- `*.scad` — parametric OpenSCAD source
- `*.svg` — the 2D outline(s) driving the shape
- `STLs/` — pre-generated STLs (produced by the export script)

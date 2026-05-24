# ATX Cutout Cover Plate — Thing-O-Matic / Smoothieboard

A parametric, printable cover plate that blanks off the ATX power supply opening on a Thing-O-Matic enclosure (or any enclosure repurposed around a Smoothieboard). Designed to be rigid, functional, and clean-looking while keeping the inside protected.

## Features

- **Standard ATX footprint** — 150 × 86 mm, matches the ATX specification exactly
- **Four M3 mounting holes** — asymmetric ATX pattern (134 mm × 70 mm spacing), with a flat-head countersink so screw heads sit flush with the plate surface
- **AC power cable entry hole** — 9 mm round hole on the left side; feed the cable through before terminating the wires, then the zip-tie anchor locks it in place
- **Zip-tie strain relief anchor** — integrated loop block right next to the power cord slot; thread a standard zip-tie through to lock the cable down
- **Angled cooling louvers** — six 70 mm vent fins across the center, angled at 35° to block falling debris while still allowing airflow

## Print Settings

| Setting | Recommended |
|---|---|
| Material | PETG or ABS (rigid, heat-tolerant) |
| Layer height | 0.2 mm |
| Walls | 3–4 perimeters |
| Infill | 20–30% |
| Supports | Not needed |
| Bed adhesion | Brim if using ABS |

Print flat — the part is designed to lie face-down with no overhangs that need support.

## Customization

Open `thing-o-matic-atx-plate.scad` in OpenSCAD. All dimensions are exposed as variables at the top of the file:

| Variable | Default | Description |
|---|---|---|
| `plate_w` | 150.0 mm | Plate width |
| `plate_h` | 86.0 mm | Plate height |
| `plate_t` | 3.0 mm | Plate thickness |
| `hole_dist_x` | 134.0 mm | Horizontal hole spacing |
| `hole_dist_y` | 70.0 mm | Vertical hole spacing |
| `hole_r` | 1.75 mm | Screw hole radius (M3 clearance) |
| `power_cable_d` | 9.0 mm | AC cable slot width (sized for 16 AWG 3-conductor, ~8 mm OD) |
| `countersink_r` | 3.0 mm | Flat-head countersink radius (6 mm head) |
| `countersink_d` | 2.0 mm | Countersink depth |

## Hardware

- 4× M3 **flat-head** screws (length depends on your enclosure wall thickness)
- 1× standard zip-tie for the strain relief anchor

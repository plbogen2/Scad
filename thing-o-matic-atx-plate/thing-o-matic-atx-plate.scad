// ====================================================================
// PARAMETRIC ATX CUTOUT COVER PLATE FOR THING-O-MATIC / SMOOTHIEBOARD
// ====================================================================

$fn = 60; // Smoothness for circles

// --- Dimensions (Standard ATX Specifications) ---
plate_w   = 150.0; // Standard ATX width
plate_h   = 86.0;  // Standard ATX height
plate_t   = 3.0;   // Plate thickness (3mm for rigid PETG/ABS)

// --- ATX Mounting Hole Offsets (Asymmetric standard) ---
hole_dist_x = 134.0; // Distance between left and right holes
hole_dist_y = 70.0;  // Distance between top and bottom holes
hole_r      = 1.75;  // 3.5mm diameter for M3 clearance screws

// --- Custom Feature Settings ---
power_cable_d = 14.0; // Main AC power cable slot width

// --- Countersink (M3 flat-head) ---
countersink_r = 3.0;  // M3 flat-head radius (6mm head diameter)
countersink_d = 2.0;  // Depth — leaves 1mm of plate below head

// ====================================================================
// MAIN GEOMETRY GENERATION
// ====================================================================

// Clearance shaft + flat-head countersink from the top face
module mounting_hole() {
    cylinder(r=hole_r, h=plate_t+2); // full shaft
    translate([0, 0, plate_t - countersink_d + 1])
        cylinder(r1=hole_r, r2=countersink_r, h=countersink_d); // cone into top
}

difference() {
    // 1. Base Plate
    translate([-plate_w/2, -plate_h/2, 0])
        cube([plate_w, plate_h, plate_t]);

    // 2. ATX Screw Holes with M3 flat-head countersink
    translate([-hole_dist_x/2, -hole_dist_y/2, -1]) mounting_hole();
    translate([ hole_dist_x/2, -hole_dist_y/2, -1]) mounting_hole();
    translate([-hole_dist_x/2,  hole_dist_y/2, -1]) mounting_hole();
    translate([ hole_dist_x/2,  hole_dist_y/2, -1]) mounting_hole();

    // 3. Left Side: AC Power Cord Slot
    translate([-plate_w/2 + 20, -plate_h/2, -1]) {
        cube([power_cable_d, 25, plate_t+2]);
        translate([power_cable_d/2, 25, 0]) 
            cylinder(r=power_cable_d/2, h=plate_t+2);
    }


    // 4. Center Array: Downward-Angled Cooling Louvers (Vent Fins)
    // Clamped to y=25 — screw holes sit at y=±35 and the rotated louver
    // geometry extends ~±4mm beyond its centre, so y=35 causes interference.
    for (y = [-15 : 10 : 25]) {
        translate([-35, y, 0]) 
            rotate([-35, 0, 0]) // Angles the blade down to block debris
            cube([70, 4, plate_t * 3], center=true);
    }
}

// ====================================================================
// ADDITIVE FEATURES (Strain Relief Anchors)
// ====================================================================

// Internal Zip-Tie Anchor Loop for the AC Main Power Cord
// Positioned right next to the power cable entry slot
translate([-plate_w/2 + 20 + (power_cable_d * 1.5), -plate_h/2 + 15, 0]) {
    difference() {
        // Outer anchor block
        cube([12, 6, 8]);
        // Slot for standard zip-tie to slide through
        translate([3, -1, 2]) cube([6, 8, 3]);
    }
}

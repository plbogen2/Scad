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
usb_w         = 14.0; // USB cable cutout width
usb_h         = 8.0;  // USB cable cutout height

// ====================================================================
// MAIN GEOMETRY GENERATION
// ====================================================================

difference() {
    // 1. Base Plate
    translate([-plate_w/2, -plate_h/2, 0])
        cube([plate_w, plate_h, plate_t]);

    // 2. ATX Screw Holes (Centered on plate origin)
    translate([-hole_dist_x/2, -hole_dist_y/2, -1]) cylinder(r=hole_r, h=plate_t+2);
    translate([ hole_dist_x/2, -hole_dist_y/2, -1]) cylinder(r=hole_r, h=plate_t+2);
    translate([-hole_dist_x/2,  hole_dist_y/2, -1]) cylinder(r=hole_r, h=plate_t+2);
    translate([ hole_dist_x/2,  hole_dist_y/2, -1]) cylinder(r=hole_r, h=plate_t+2);

    // 3. Left Side: AC Power Cord Slot
    translate([-plate_w/2 + 20, -plate_h/2, -1]) {
        cube([power_cable_d, 25, plate_t+2]);
        translate([power_cable_d/2, 25, 0]) 
            cylinder(r=power_cable_d/2, h=plate_t+2);
    }

    // 4. Right Side: Smoothieboard USB Logic Pass-Through
    translate([plate_w/2 - 25, -plate_h/2, -1])
        cube([usb_w, usb_h + 10, plate_t+2]);

    // 5. Center Array: Downward-Angled Cooling Louvers (Vent Fins)
    // Generates a grid of 6 safely angled cooling slots
    for (y = [-15 : 10 : 35]) {
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

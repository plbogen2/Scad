/* Copied from original stamp_cookie_lib/stamp_cookie.scad */
/* [Hidden] */
_wall_thickness = 2;
_gap = 1;
_edge_height = 4;

module solid_pattern(pattern) {
  minkowski() {
    import(pattern);
  }
}

module base(pattern, height) {
  linear_extrude(height) {
    fill() offset(r=_gap) {
      solid_pattern(pattern);
    }
  }
}

module _wall(pattern, thickness) {
  difference() {
    offset(r = 2 * _gap + thickness) {
      solid_pattern(pattern);
    }
    offset(r = 2 * _gap) {
      solid_pattern(pattern);
    }
    solid_pattern(pattern);
  }
}

module wall(pattern, params) {
  first_height = params.base_height + params.cutter_height;
  linear_extrude(first_height - _edge_height)
    _wall(pattern, _wall_thickness);
  linear_extrude(first_height)
    _wall(pattern, _wall_thickness/2);
}

module grip(pattern, params) {
    linear_extrude(params.base_height) {
        difference() {
            offset(params.offset * 2 + _gap * 2) {
              solid_pattern(pattern);
            }
            offset(r = _gap * 2) {
              solid_pattern(pattern);
            }
            solid_pattern(pattern);
        }
    }
}

module cutter(pattern, params) {
    color("red") union() {
     wall(pattern, params);
     grip(pattern, params);
 }
}

module stamp(cut_pattern, stamp_pattern, params) {
    union() {
    color("blue")
        translate([0,0,params.base_height])
            linear_extrude(params.stamp_height){
                import(stamp_pattern);
            }
        base(cut_pattern, params.base_height);
    }
}

module cookie(cut_pattern, stamp_pattern, params) {
  cutter(cut_pattern, params);
  stamp(cut_pattern, stamp_pattern, params);
}

params = object(base_height = 5, stamp_height = 5, cutter_height = 10, offset = 1);

cookie("../light-bulb.svg", "../light-bulb.svg", params);

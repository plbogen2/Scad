/* [File] */
cut_pattern = "simple_dala_horse.svg";
stamp_pattern = "stamp_dala_horse.svg";
stamp_pattern_2 = "dala_horse_head.svg";

/* [Depths] */
base_height = 1;
stamp_height = 6;
cutter_height = 25;  
offset = 6;

/* Advanced */
use_in = false;

/* [Hidden] */
IN = use_in ? 25.4 : 1;

_base_height = base_height * IN;
_stamp_height = stamp_height * IN;
_cutter_height = cutter_height * IN;
_wall_thickness = 2;
_offset = offset * IN;
_gap = 1;
_edge_height = 4;

module solid_pattern(pattern) {
  minkowski() {
    import(pattern);
  }
}

module base() {
  linear_extrude(_base_height) {
    fill() offset(r=_gap) {
      solid_pattern(cut_pattern);
    }
  }
}

module _wall(thickness) {
  difference() {
    offset(r = 2 * _gap + thickness) {
      solid_pattern(cut_pattern);
      }
    offset(r = 2 * _gap) {
      solid_pattern(cut_pattern);
    }

    solid_pattern(cut_pattern);
  }
}

module wall() {
  linear_extrude(_base_height + _cutter_height - _edge_height)
    _wall(_wall_thickness);
  linear_extrude(_base_height + _cutter_height)
    _wall(_wall_thickness/2);

}

module grip() {
    linear_extrude(_base_height) {
        difference() {
            offset(_offset * 2 + _gap * 2) {
              solid_pattern(cut_pattern);
            }
            offset(r = _gap * 2) {
              solid_pattern(cut_pattern);
            }

            solid_pattern(cut_pattern);
        }
    }
}
 
module cutter() {
    color("red") union() {
     wall();
     grip();
 }
} 

module stamp_2() {
    difference(){
        offset(-0.76) fill() offset(0.75)
            import(stamp_pattern_2);
        import(stamp_pattern_2);
    }
}

module stamp() {
    union() {
    color("blue")
        translate([0,0,_base_height])
            linear_extrude(_stamp_height){
                import(stamp_pattern);
                stamp_2();
            }
    
        base();
    }
} 

 
cutter();
stamp();

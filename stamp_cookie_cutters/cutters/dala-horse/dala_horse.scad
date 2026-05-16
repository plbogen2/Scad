use <../lib/stamp_cookie.scad>

params = object(base_height = 1, stamp_height = 6, cutter_height = 25, offset = 6);

cookie("simple_dala_horse.svg", "stamp_dala_horse.svg", params);
 
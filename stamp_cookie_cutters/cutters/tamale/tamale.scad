use <../lib/stamp_cookie.scad>

params = object(base_height = 5, stamp_height = 5, cutter_height = 10, offset = 1);

cookie("tamale-cutter.svg", "tamale-stamp.svg", params);

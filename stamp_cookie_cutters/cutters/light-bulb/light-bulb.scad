use <../lib/stamp_cookie.scad>

/* [File] */ 
cut_pattern = "light-bulb.svg";
stamp_pattern = "light-bulb.svg";

/* [Depths] */
base_height = 5;
stamp_height = 5;
cutter_height = 10;  
offset = 1;

/* [Hidden] */
params = object( 
  base_height = base_height,
  stamp_height = stamp_height,
  cutter_height = cutter_height,
  offset = offset);

cookie(cut_pattern, stamp_pattern, params); 

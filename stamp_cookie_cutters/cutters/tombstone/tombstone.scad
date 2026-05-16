use <../lib/stamp_cookie.scad>

/* [File] */ 
cut_pattern = "tombstone.svg";

/* [Depths] */
base_height = 4;
stamp_height = 6;
cutter_height = 25;  
offset = 6;

/* [Hidden] */
params = object( 
  base_height = base_height,
  stamp_height = stamp_height,
  cutter_height = cutter_height,
  offset = offset);

cutter(cut_pattern, params);

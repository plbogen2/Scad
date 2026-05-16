use <../lib/stamp_cookie.scad>

/* [File] */ 
cut_pattern = "feliz-navidad-cutter.svg";
stamp_pattern = "feliz-navidad-stamp.svg";

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

cookie(cut_pattern, stamp_pattern, params); 

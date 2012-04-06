include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

complete_box();

translate([-w/2 + material_thickness * 3/2, front_strut_bottom_dx, front_strut_bottom_dy]) 
  rotate([-180 + front_strut_max_angle, 0, 0]) 
  // rotate([-front_strut_init_angle, 0, 0]) 
    rotate([-90, 0, -90]) 
      strut(front_strut_length, 10);
translate([-w/2 + material_thickness * 3/2, rear_strut_bottom_dx, rear_strut_bottom_dy]) 
  // rotate([-rear_strut_init_angle, 0, 0]) 
  rotate([-rear_strut_max_angle, 0, 0]) 
    rotate([-90, 0, -90]) 
      curve_strut(rear_strut_length, 10, rear_strut_length/rear_strut_sagitta_ratio, 1);

// translate([w/2 - material_thickness * 3/2, 40, 30]) rotate([180-24, 0, 0]) rotate([-90, 0, 90]) strut(175, 10);
// translate([w/2 - material_thickness * 3/2, 110, 30]) rotate([0, 0, 0]) rotate([90, 0, 90]) curve_strut(99, 10, 50, -1);

// translate([0, 0, h/2]) rotate([0, 180, 0]) complete_lid();
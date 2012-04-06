include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

complete_box();

translate([-w/2 + material_thickness * 3/2, front_strut_bottom_dx, front_strut_bottom_dy]) 
  rotate([-180 + front_strut_max_angle, 0, 0]) 
    rotate([-90, 0, -90]) 
      curve_strut(front_strut_length, 10, front_strut_length/rear_strut_sagitta_ratio, 1);

translate([-w/2 + material_thickness * 3/2, rear_strut_bottom_dx, rear_strut_bottom_dy]) 
  rotate([-rear_strut_max_angle, 0, 0]) {
    rotate([-90, 0, -90]) 
      curve_strut(rear_strut_length, 10, rear_strut_length/rear_strut_sagitta_ratio, 1);
  }

translate([w/2 - material_thickness * 3/2, front_strut_bottom_dx, front_strut_bottom_dy]) 
  rotate([-180 + front_strut_max_angle, 0, 0]) 
    rotate([-90, 0, -90]) 
      curve_strut(front_strut_length, 10, front_strut_length/rear_strut_sagitta_ratio, -1);

translate([w/2 - material_thickness * 3/2, rear_strut_bottom_dx, rear_strut_bottom_dy]) 
  rotate([-rear_strut_max_angle, 0, 0]) {
    rotate([-90, 0, -90]) 
      curve_strut(rear_strut_length, 10, rear_strut_length/rear_strut_sagitta_ratio, -1);
  }

translate([0, rear_strut_bottom_dx, rear_strut_bottom_dy]) {
  rotate([-rear_strut_max_angle, 0, 0]) {
    translate([0, -rear_strut_length, 0]) 
      rotate([180-lid_angle, 0, 0]) 
        rotate([0, 180, 0]) 
          translate([0, -rear_strut_top_dx, 0]) 
            complete_lid();
  }
}
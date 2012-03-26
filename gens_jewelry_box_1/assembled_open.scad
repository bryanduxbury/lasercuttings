include <box_bottom.scad>
include <lid.scad>
include <struts.scad>

complete_box();
translate([-w/2 + material_thickness * 7/2, 40, 30]) rotate([180-24, 0, 0]) rotate([-90, 0, 90]) strut(175, 10);
translate([-w/2 + material_thickness * 7/2, 110, 30]) rotate([180-45, 0, 0]) rotate([-90, 0, 90]) strut(99, 10);
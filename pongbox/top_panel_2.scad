include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

projection(cut=true) {
  translate([-lid_h/2 - material_thickness, 0, 0]) rotate([0, 0, 90]) lid_retainer();
  translate([lid_h/2 + material_thickness, 0, 0]) rotate([180, 0, 0]) rotate([0, 0, -90]) lid_retainer();
}

// complete_lid();

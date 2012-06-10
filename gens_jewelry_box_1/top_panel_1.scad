include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

projection(cut=true) {
  translate([0, -d/2 - lid_h/2 - material_thickness/2, 0]) lid_front();
  translate([0, d/2 + lid_h/2 + material_thickness/2, 0]) lid_back();
  translate([-w/2 - lid_h/2 - material_thickness/2, 0, 0]) rotate([0, 0, -90]) lid_side();
  translate([w/2 + lid_h/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) lid_side();
  bottom();

  // translate([-w/2 - 3 * lid_h/2 - material_thickness, 0, 0]) rotate([0, 0, 90]) lid_retainer();
  // translate([w/2 + 3 * lid_h/2 + material_thickness, 0, 0]) rotate([180, 0, 0]) rotate([0, 0, -90]) lid_retainer();
}

// complete_lid();

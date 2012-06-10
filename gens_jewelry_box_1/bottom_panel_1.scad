include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

projection(cut=true) {
  rotate(a=[0,0,90]) {
    translate([0, -d/2 - bottom_h/2 - material_thickness/2, 0]) front();
    translate([0, d/2 + bottom_h/2 + material_thickness/2, 0]) back();
    bottom();
  }
}

// complete_lid();

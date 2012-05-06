include <params.scad>
use <box_bottom.scad>
use <lid.scad>
use <struts.scad>

projection(cut=true) {
  translate([0, -d/2 - bottom_h/2 - material_thickness/2, 0]) front();
  translate([0, d/2 + bottom_h/2 + material_thickness/2, 0]) back();
  translate([-w/2 - bottom_h/2 - material_thickness/2, 0, 0]) rotate([0, 0, -90]) side();
  translate([w/2 + bottom_h/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) side();
  bottom();

  translate([-w/2 - 3 * bottom_h/2 - material_thickness, 0, 0]) rotate([0, 0, 90]) retainer();
  translate([w/2 + 3 * bottom_h/2 + material_thickness, 0, 0]) rotate([180, 0, 0]) rotate([0, 0, -90]) retainer();

  translate([w/2 + material_thickness + strut_width, d/2 + material_thickness + strut_width, 0]) curve_strut(front_strut_length, strut_width, front_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);
  translate([w/2 + material_thickness + strut_width, d/2 + material_thickness + 4* strut_width + material_thickness, 0]) curve_strut(front_strut_length, strut_width, front_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);

  translate([w/2 + material_thickness + strut_width, -d/2 - material_thickness - (4 * strut_width) - material_thickness, 0]) curve_strut(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);
  translate([w/2 + material_thickness + strut_width, -d/2 - material_thickness - (7 * strut_width) - material_thickness, 0]) curve_strut(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);

  translate([-w/2 - material_thickness - strut_pivot_r, d/2 + material_thickness + strut_pivot_r, 0]) {
    for (i = [0:15]) {
      translate([-(strut_pivot_r * 2 + material_thickness / 2) * i , 0, 0]) cylinder(r=strut_pivot_r, h=material_thickness, center=true, $fn=36);
    }
  }
}

// complete_lid();

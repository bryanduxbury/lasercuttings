include <params.scad>

module strut(length, width) {
  translate([length/2, 0, 0]) union() {
    cube(size=[length, width, material_thickness], center=true);
    for (a = [0, 180]) rotate([0, a, 0]) translate([length/2, 0, 0]) {
      cylinder(r=width, h=material_thickness, center=true);
    }

    for (a = [0, 180]) translate([0, 0, material_thickness]) rotate([0, a, 0]) translate([length/2, 0, 0]) {
      cylinder(r=5, h=material_thickness, center=true);
    }
  }
}

// strut(175, 10);
// strut(175, 10);
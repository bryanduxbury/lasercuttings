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

module curve_strut(length, width, sagitta, dir) {
  render() {union() {
    cylinder(r=width, h=material_thickness, center=true);
    translate([length, 0, 0]) cylinder(r=width, h=material_thickness, center=true);
    intersection() {
      translate([length/2, -length*length/8/sagitta+sagitta/2, 0]) {
        difference() {
          cylinder(r=length*length/8/sagitta+sagitta/2 + width/2, h=material_thickness, center=true, $fn=100);
          cylinder(r=length*length/8/sagitta+sagitta/2 - width/2, h=11, center=true, $fn=100);
        }
      }
      translate([length/2, length/2, 0]) cube(size=[length+width, length+width, material_thickness*2], center=true);
    }
    translate([0, 0, dir * material_thickness]) {
      cylinder(r=5, h=material_thickness, center=true);
      translate([length, 0, 0]) cylinder(r=5, h=material_thickness, center=true);
    }
  }}
}

curve_strut(175, 10, 65, -1);

// strut(175, 10);
// strut(175, 10);
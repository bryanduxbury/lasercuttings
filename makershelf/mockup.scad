


module drawer() {
  cube(size=[24*25, 18*25, 6], center=true);
  translate([0, -9*25+3, 4*25]) difference() {
    cube(size=[24*25-12, 6, 8*25], center=true);
    translate([0, 0, 8*25]) rotate([90, 0, 0]) cylinder(r=5*25, h=10, center=true);
  }
  translate([12*25-3-6, 0, 4*25]) difference() {
    cube(size=[6, 18*25, 8*25], center=true);
    translate([0, 0, 2*25]) {
      translate([0, 2*25, 0]) rotate([0, 90, 0]) cylinder(r=20, h=10, center=true);
      translate([0, -2*25, 0]) rotate([0, 90, 0]) cylinder(r=20, h=10, center=true);
      cube(size=[10, 4*25, 40], center=true);
    }
  }
  translate([-(12*25-3-6), 0, 4*25]) difference() {
    cube(size=[6, 18*25, 8*25], center=true);
    translate([0, 0, 2*25]) {
      translate([0, 2*25, 0]) rotate([0, 90, 0]) cylinder(r=20, h=10, center=true);
      translate([0, -2*25, 0]) rotate([0, 90, 0]) cylinder(r=20, h=10, center=true);
      cube(size=[10, 4*25, 40], center=true);
    }
  }
  translate([0, 9*25-3, 4*25]) cube(size=[24*25 - 12, 6, 8*25], center=true);
}

module slide_assembly() {
  translate([12*25-3, 0, 0]) difference() {
    cube(size=[6, 19*25, 8*25], center=true);
    translate([0, 9*25, 25]) cube(size=[7, 6, 25], center=true);
    translate([0, 9*25, -25]) cube(size=[7, 6, 25], center=true);
  }
  translate([-(12*25-3), 0, 0]) difference() {
    cube(size=[6, 19*25, 8*25], center=true);
    translate([0, 9*25, 25]) cube(size=[7, 6, 25], center=true);
    translate([0, 9*25, -25]) cube(size=[7, 6, 25], center=true);
  }
  
  translate([0, 9*25, 0]) difference() {
    cube(size=[25*25, 6, 4*25], center=true);
    translate([12.5*25, 0, 0]) cube(size=[50, 7, 25], center=true);
  }
}

color([128/255, 128/255, 0/255]) {
  drawer();
}

translate([0, 12, 3+4*25]) slide_assembly();
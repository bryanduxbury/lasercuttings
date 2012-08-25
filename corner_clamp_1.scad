projection(cut=true) {
  difference() {
    cube(size=[75, 75, 4], center=true);
    translate([-37.5, -37.5, 0]) cube(size=[75, 75, 4.1], center=true);
    cylinder(r=15, h=10, center=true, $fn=72);
    rotate([0, 0, 45]) translate([-15, 0, 0]) cube(size=[30, 30, 10], center=true);
    for (a=[45,135,315]) {
      rotate([0, 0, a]) translate([30, 0, 0]) cylinder(r=3.1, h=10, center=true, $fn=36);
    }

  }


  translate([150, 0, 0]) intersection() {
    cylinder(r=37.5, h=5, center=true, $fn=300);
    difference() {
      cube(size=[75, 75, 4], center=true);
      translate([-37.5, -37.5, 0]) cube(size=[75, 75, 4.1], center=true);
      cylinder(r=15, h=10, center=true, $fn=72);
      rotate([0, 0, 45]) translate([-15, 0, 0]) cube(size=[30, 30, 10], center=true);
      for (a=[45,135,315]) {
        rotate([0, 0, a]) translate([30, 0, 0]) cylinder(r=3.1, h=10, center=true, $fn=36);
      }
      translate([0, 37.5, 0]) cube(size=[76, 10, 10], center=true);
      rotate([0, 0, -90]) translate([0, 37.5, 0]) cube(size=[76, 10, 10], center=true);
      // rotate([0, 0, -45]) translate([0, 45, 0]) cube(size=[40, 15, 10], center=true);
    }
  }
}

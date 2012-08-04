
module tooth(adj) {
  polygon(points=[
    [-6-adj, 0],
    [6+adj, 0],
    [4+adj, 10+adj],
    [-4-adj, 10+adj]
  ]);
}

module oshw(adj) {
  difference() {
    union() {
      circle(r=25+adj, center=true, $fn=100);
      for (i=[0:8]) {
        rotate([0, 0, 360/8 * i]) translate([0, 24, 0]) tooth(adj);
      }
    }
    circle(r=10-adj, center=true, $fn=100);
    for (a=[12,6,0,-6,-12]) {
      rotate([0, 0, a]) translate([0, -25, 0]) square(size=[5-adj*2, 50], center=true);
    }
  }
}


difference () {
  oshw(0.005*25.4);
  oshw(-0.005*25.4);
}

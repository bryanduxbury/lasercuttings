
module tooth(adj, s) {
  polygon(points=[
    [-6*s-adj, 0],
    [6*s+adj, 0],
    [4*s+adj, 10*s+adj],
    [-4*s-adj, 10*s+adj]
  ]);
}

module oshw(adj, s) {
  difference() {
    union() {
      circle(r=25*s+adj, center=true, $fn=100);
      for (i=[0:8]) {
        rotate([0, 0, 360/8 * i]) translate([0, 24*s, 0]) tooth(adj, s);
      }
    }
    circle(r=10*s-adj, center=true, $fn=100);
    for (a=[12,6,0,-6,-12]) {
      rotate([0, 0, a]) translate([0, -25*s, 0]) square(size=[5*s-adj*2, 50*s], center=true);
    }
  }
}


difference () {
  oshw(0.005*25.4, 1);
  oshw(-0.005*25.4, 1);
}

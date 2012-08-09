diameter = 35;
ring_thickness = 5;
gutter_w = 0.5;

module ring(adj) {
  difference() {
    circle(r=diameter/2 - adj, $fn=150);
    circle(r=diameter/2-ring_thickness + adj, $fn=150);
  }
}

rotate([0, 0, -15]) difference() {
  ring(0);
  for (a=[0:11]) render() {
    rotate([0, 0,  a*30]) difference() {
      rotate([0, 0, 30]) intersection() {
        ring(gutter_w);
        translate([diameter/4 * sqrt(2) + gutter_w/2*sqrt(2), diameter/2 - ring_thickness/2, 0]) rotate([0, 0, 45]) square(size=[diameter/2, diameter/2], center=true);
      }
      translate([diameter/4 * sqrt(2) - gutter_w/2*sqrt(2), diameter/2 - ring_thickness/2, 0]) rotate([0, 0, 45]) square(size=[diameter/2, diameter/2], center=true);
    }
  }
  
  
}

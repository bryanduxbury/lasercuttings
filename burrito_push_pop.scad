
difference() {
  cylinder(r=50, h=200, center=true, $fn=72);
  cylinder(r=47.5, h=201, center=true, $fn=72);
  
  linear_extrude(height=190, twist=90, center=true, $fn=250, convexity=25) {
    square(size=[110, 10], center=true);
  }
}

color([128/255, 128/255, 0/255]) rotate([0, 0, -45]) union() {
  cylinder(r=46.5, h=5, center=true);
  cube(size=[110, 10, 5], center=true);
}
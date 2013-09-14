w = 5;
x = 45;

hole_d = 1.5;

difference() {
  union() {
    square(size=[x, x], center=true);
    for (a=[0:3]) {
      rotate([0, 0, a*90]) translate([x/2 - w, 0, 0]) circle(r=x / 2 - w, center=true, $fn=72);
    }
  }
  square(size=[x-2*w, x-2*w], center=true);
  for (a=[0:3]) {
    rotate([0, 0, a*90]) {
      translate([x/2-w, 0, 0]) circle(r=(x-2*w) / 2 - w, $fn=72);
    }
  }
  
  translate([0, x / 2 + x/2 - 2*w - w/2, 0]) circle(r=hole_d/2, $fn=16);
}
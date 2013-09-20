x = 100;

y = 7/11 * x;
z = 3/11 * x;
rx = 1/6 * x;
ry = 1/12 * x;
rz = 1/24 * x;

module ring(d, r) {
  union() {
    square(size=[d, d - r * 2], center=true);
    rotate([0, 0, 90]) 
      square(size=[d, d - r * 2], center=true);

    for (i=[0:3]) {
      rotate([0, 0, 90 * i]) 
      translate([d/2 - r, d/2 - r, 0]) 
        circle(r=r, $fn=72);
    }
  }
}

difference() {
  ring(x, rx);
  ring(y, ry);
}
ring(z, rz);



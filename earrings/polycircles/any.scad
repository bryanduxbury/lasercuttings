w = 4;
side = 20;
num_sides = 11;

r = (side/2) / sin(360/num_sides/2);
echo("r", r);
x = (side/2) / tan(360/num_sides/2);
echo ("x", x);
rr = (x - w) /cos(360/num_sides/2);
echo("rr", rr);

hole_d = 1.5;

function polar(radius, theta) = [radius * cos(theta), radius * sin(theta)];

module reg_poly(n_sides, r) {
  for (a=[0:n_sides-1]) {
    polygon(points=[
      [0,0],
      polar(r, 360/n_sides * a),
      polar(r, 360/n_sides * (a+1)),
    ]);
  }
}

difference() {
  union() {
    reg_poly(num_sides, r);
    for (a=[0:num_sides-1]) {
      translate(polar(x-w, 360 / num_sides * (a + 0.5))) circle(r=side/2 - w, $fn=72);
    }
  }
  reg_poly(num_sides, rr);
  for (a=[0:num_sides-1]) {
    translate(polar(x-w, 360 / num_sides * (a + 0.5))) circle(r=(side - 2 * w)/2 - w, $fn=72);
  }

  translate(polar(x + (side/2 - w) - w - w/2, 360/num_sides/2)) circle(r=hole_d/2, $fn=36);
}

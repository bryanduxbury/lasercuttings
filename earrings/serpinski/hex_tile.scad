r = 20;

function polar(r, theta) = [cos(theta) * r, sin(theta) * r];

module tile(dist, depth) {
  // render() circle(r=dist/3, $fn=36);
  polygon(points=[
    polar(dist/3, 0),
    polar(dist/3, 60),
    polar(dist/3, 120),
    polar(dist/3, 180),
    polar(dist/3, 240),
    polar(dist/3, 300)
    ]);
  
  // square(size=[dist/3, dist/3], center=true);
  for (a=[0:5]) {
    rotate([0, 0, a * 60]) translate([0, dist/3 * 2, 0]) {
      if (depth > 0) {
        tile(dist/3, depth - 1);
      }
    }
  }
  
}


difference() {
  circle(r=r, $fn=72);
  // rotate([0, 0, 30]) polygon(points=[
  //   polar(r, 0),
  //   polar(r, 60),
  //   polar(r, 120),
  //   polar(r, 180),
  //   polar(r, 240),
  //   polar(r, 300)
  //   ]);
  

  tile(r, 3);
}



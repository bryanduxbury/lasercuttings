r = 20;
w = 4;
notch_depth = 5;

difference() {
  intersection() {
    union() {
      difference() {
        circle(r=r, $fn=72);
        circle(r=r-w, $fn=72);
      }
      for (a=[0:3]) {
        rotate([0, 0, a*90]) translate([r, 0, 0]) polygon(points=[
          [-notch_depth-w/sin(30), 0],
          [0, (notch_depth+w/sin(30)) * tan(30)],
          [0, -(notch_depth+w/sin(30)) * tan(30)]
        ]);
      }
      
      rotate([0, 0, 45]) 
      translate([r - w - 2, 0, 0]) 
        circle(r=1, $fn=16);
    }
    circle(r=r, $fn=72);
  }

  for (a=[0:3]) {
    rotate([0, 0, a*90]) translate([r, 0, 0]) polygon(points=[
      [-notch_depth, 0],
      [0, (notch_depth) * tan(30)],
      [0, -(notch_depth) * tan(30)]
    ]);
  }
  
  translate([0, r - notch_depth - 2, 0]) 
    circle(r=1, $fn=16);
}

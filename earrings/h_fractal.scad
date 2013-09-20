t=0.5;

module generate(prev_w, depth) {
  if (depth != 0) {
    square(size=[prev_w / sqrt(2), t], center=true);
    for (i=[-1,1]) {
      rotate([0, 0, i*90]) 
      translate([0, prev_w/sqrt(2)/2, 0]) 
      generate(prev_w/sqrt(2), depth - 1);
    }
  }
}

difference() {
  circle(r=20);
  !generate(45, 8);
}

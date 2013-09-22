
intersection() {
  intersection() {
    translate([37, 0, 0]) circle(r=50, $fn=72);
    translate([-37, 0, 0]) circle(r=50, $fn=72);
  }

  union() {
    for (x=[-2:2], d=[-1,1]) {
      translate([d * (49 + 2 * 3 * x), 0, 0]) {
        difference() {
          circle(r=50, $fn=72);
          circle(r=48, $fn=72);
        }
      }
    }
  }
  
}

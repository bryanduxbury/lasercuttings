
assign(ir=10)
assign(r = 20)
assign(arc = 9)
union() {
  intersection() {
    union() {
      difference() {
        circle(r=ir);
        circle(r=ir-2, $fn=36);
      }
      

      for (a=[0:11]) {
        rotate([0, 0, 360/11 * a]) 
        translate([arc, ir-1, 0]) {
          difference() {
            circle(r=arc, $fn=120);
            circle(r=arc-2, $fn=120);
            translate([0, -arc, 0]) square(size=[arc*2, arc*2], center=true);
          }
        }
      }
    }
    circle(r=22);
  }
  
  difference() {
    circle(r=23, $fn=72);
    circle(r=20, $fn=72);
  }
}

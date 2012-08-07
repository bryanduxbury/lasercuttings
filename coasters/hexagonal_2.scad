gutter_w = 2.5;
total_r = 50;
total_divisions = 3.375;

section_r = (total_r - gutter_w) * 2 / total_divisions;

module hex() {
  circle(r=section_r/2+gutter_w/2*tan(30), center=true, $fn=6);
}

difference() {
  circle(r=total_r, $fn=150);

  intersection() {
    circle(r=total_r-gutter_w);
    difference() {
      union() {
        hex();
        // translate([0, section_r, 0]) circle(r=section_r/2, center=true, $fn=6);
        for (i=[0, 60, 120, 180, 240, 300]) {
          rotate([0, 0, i]) translate([0, section_r, 0]) rotate([0, 0, -60]) union() {
            hex();
            translate([0, section_r, 0]) {
              hex();
              rotate([0, 0, -60]) translate([0, section_r, 0]) {
                hex();
              }
            }
          }
        }
      }

      for (a=[-60,0,60]) rotate([0, 0, a+30]) {
        for (i=[-2:2]) {
          translate([0, section_r*i*cos(30), 0]) square(size=[total_r*2, gutter_w], center=true);
        }
      }

    }
  }
  
  
}

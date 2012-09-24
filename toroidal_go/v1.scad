piece_spacing = 12;
piece_size = 10;
material_thickness = 3;
piece_material_thickness = 1.6;

disc_r = piece_spacing * 13 / 3.14 / 2;
echo("disc radius: ", disc_r);


torus_r = 75;

support_h = 50;

module ext(h=3) {
  linear_extrude(height=h) child(0);
}

module tab() {
  square(size=[material_thickness, piece_material_thickness*2], center=true);
  translate([0, piece_material_thickness + 1.5, 0]) square(size=[material_thickness+2, 3], center=true);
}

module main_disc(num_positions) {
  difference() {
    union() {
      circle(r=disc_r, $fn=100);
      for (i=[1:num_positions]) {
        rotate([0, 0, i*360/num_positions]) {
          translate([0, disc_r, 0]) tab();
        }
      }
    }
    circle(r=1.6, $fn=36);
  }

}

module disc_pulley_inside() {
  difference() {
    circle(r=15);
    circle(r=1.6, $fn=36);
  }
}

module disc_pulley_outside() {
  difference() {
    circle(r=18);
    circle(r=1.6, $fn=36);
    translate([0, 16.5, 0]) {
      for (i=[-1,1]) {
        translate([i, 0, 0]) circle(r=0.5, $fn=36);
      }
    }
  }
}

module disc_pulley_assembly() {
  ext(1.5) disc_pulley_inside();
  translate([0, 0, 1.5]) ext(1.5) disc_pulley_outside();
}

module disc_assembly(num_positions) {
  translate([0, 0, -1.5]) ext() {
    main_disc(num_positions);
  }
  translate([0, 0, 1.5]) disc_pulley_assembly();
}

module support_strut() {
  difference() {
    union() {
      circle(r=5, $fn=36);
      translate([0, (support_h - 5)/-2, 0]) square(size=[10, support_h-5], center=true);
    }

    circle(r=1.6, $fn=36);
  }
}

module bottom_support_disc() {
  difference() {
    circle(r=torus_r+5, $fn=120);
    circle(r=3.2, $fn=36);
  }
}

module gear_stack() {
  translate([0, 0, 1.5/2]) {
    for (i=[0:12]) {
      translate([0, 0, 1.5*2*i]) difference() {
        cylinder(r=9, h=1.5, center=true);
        cylinder(r=3.2, h=1.5+0.1, center=true);
      }
    }
    for (i=[0:12]) {
      rotate([0, 0, 360/13*i]) translate([0, 0, 1.5*(2*i+1)]) difference() {
        cylinder(r=11, h=1.5, center=true);
        cylinder(r=3.2, h=1.5+0.1, center=true);
        translate([0, 10, 0]) {
          translate([-1, 0, 0]) cylinder(r=0.5, h=1.6, center=true);
          translate([1, 0, 0]) cylinder(r=0.5, h=1.6, center=true);
        }
      }
    }
  }
}


for (i=[1:13]) {
  rotate([0, 0, i*360/13]) translate([0, torus_r, 0]) {
    rotate([0, 90, 180]) {
      disc_assembly(13);
    }
    translate([1.5, 0, 0]) rotate([90, 00, 90]) linear_extrude(height=3) {support_strut();}
    
  }
  
}

translate([0, 0, -support_h + 10 - material_thickness/2]) ext() bottom_support_disc();

translate([0, 0, -support_h + 10 + material_thickness/2]) gear_stack();
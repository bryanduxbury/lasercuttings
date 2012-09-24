use <../publicDomainGearV1.1.scad>

laser_beam_width=0.005*25.4;

num_positions = 7;

piece_spacing = 12;
piece_size = 10;
material_thickness = 3;
piece_material_thickness = 1.6;

disc_r = piece_spacing * num_positions / 3.14 / 2;
echo("disc radius: ", disc_r);


torus_r = 50;

support_h = 50;

central_gear_r = torus_r - 20 - 5;
central_gear_num_teeth = 120;
// mm_per_tooth = 3.1415926 / ((central_gear_num_teeth+2) / central_gear_r*2);
mm_per_tooth = 3.1415926 / ((central_gear_num_teeth+2) / (central_gear_r * 2));

planet_gear_num_teeth = 60;
planet_gear_r = central_gear_r * planet_gear_num_teeth / central_gear_num_teeth;

echo("central gear r", central_gear_r);
echo("mm per tooth", mm_per_tooth);
// function mm_per_tooth(num_teeth, outside_diameter) = (num_teeth+2) / outside_diameter;
function center_distance(t1, t2, mm_per_tooth) = (t1+t2)/(3.1415926 / mm_per_tooth * 2);

module ext(h=material_thickness) {
  translate([0, 0, -material_thickness/2]) linear_extrude(height=h) child(0);
}

module tab() {
  square(size=[material_thickness, piece_material_thickness*2], center=true);
  translate([0, piece_material_thickness + material_thickness/4, 0]) square(size=[material_thickness+2, material_thickness/2], center=true);
}

module main_disc() {
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
    
    for (i=[-1,1]) {
      translate([material_thickness * 2 * i, 0, 0]) circle(r=1.5, $fn=36);
    }
  }
}

module disc_assembly() {
  ext() main_disc();
  translate([0, 0, material_thickness]) planet_pulley_inner();
  translate([0, 0, material_thickness*2]) planet_pulley_outer();
}

module planet_gear() {
  color([120/255, 120/255, 0/255]) {
    difference() {
      cylinder(r=central_gear_r * planet_gear_num_teeth / central_gear_num_teeth, h=material_thickness, center=true);
      // gear(mm_per_tooth=mm_per_tooth, number_of_teeth = planet_gear_num_teeth, thickness=material_thickness, hole_diameter=3.2);
      cylinder(r=1.6, h=material_thickness+0.1, center=true);

      for (i=[-1,1]) {
        translate([material_thickness * 2 * i, 0, 0]) cylinder(r=1.5, h=material_thickness+0.1, $fn=36, center=true);
      }
    }
  }
}

module planet_pulley_inner() {
  color([120/255, 120/255, 0/255]) {
    difference() {
      circle(r=central_gear_r * planet_gear_num_teeth / central_gear_num_teeth - 4, center=true);
      circle(r=1.6, center=true, $fn=36);

      for (i=[-1,1]) {
        translate([material_thickness * 2 * i, 0, 0]) circle(r=1.5, h=material_thickness+0.1, $fn=36, center=true);
      }
    }
  }
}

module planet_pulley_outer() {
  color([120/255, 120/255, 0/255]) {
    difference() {
      circle(r=central_gear_r * planet_gear_num_teeth / central_gear_num_teeth, h=material_thickness, center=true);
      circle(r=1.6, h=material_thickness+0.1, center=true, $fn=36);

      for (i=[-1,1]) {
        translate([material_thickness * 2 * i, 0, 0]) circle(r=1.5, h=material_thickness+0.1, $fn=36, center=true);
      }
    }
  }
}

module planet_assembly() {
  planet_gear();
  translate([0, 0, material_thickness]) ext() planet_pulley_inner();
  translate([0, 0, material_thickness*2]) ext() planet_pulley_outer();
}

module support_disk() {
  difference() {
    circle(r=torus_r, $fn=120);
    circle(r=1.5, $fn=36);
    for (i=[0:num_positions-1]) {
      rotate([0, 0, (i+0.5)*360/num_positions]) translate([0, center_distance(central_gear_num_teeth, planet_gear_num_teeth, mm_per_tooth), 0]) {
        circle(r=1.6, $fn=36);
      }
      rotate([0, 0, i*360/num_positions]) {
        translate([0, torus_r - 20 - material_thickness + material_thickness/2 - material_thickness/4, 0]) {
          square(size=[material_thickness-laser_beam_width, material_thickness/2], center=true);
        }
        translate([0, torus_r, 0]) {
          difference() {
            square(size=[material_thickness - laser_beam_width, 20 + 2*material_thickness + material_thickness/2], center=true);
            translate([0, -(material_thickness) / 4, 0]) {
              translate([material_thickness/2, 0, 0]) circle(r=material_thickness / 8, $fn=12);
              translate([material_thickness/-2, 0, 0]) circle(r=material_thickness / 8, $fn=12);
            }
          }
        }
      }
    }
  }
}

module wheel_arm() {
  difference() {
    union() {
      square(size=[40 + material_thickness*3, material_thickness+10], center=true);
      translate([(40 + material_thickness*3) / -2 + material_thickness/2+5, disc_r/2, 0]) square(size=[material_thickness+10, disc_r + 10], center=true);
      translate([(40 + material_thickness*3) / -2 + material_thickness/2+5, disc_r + 5, 0]) circle(r=(material_thickness+10)/2);
    }
    translate([(40 + material_thickness*3) / -2 + material_thickness/2+5, disc_r + 5, 0]) circle(r=1.5, $fn=36);
    
    translate([(40 + material_thickness*3) / 2 - 20 + material_thickness - material_thickness/2 - material_thickness/4, 0, 0]) {
      #square(size=[material_thickness/2, material_thickness-laser_beam_width], center=true);
    }

    translate([(40 + material_thickness*3) / 2, 0, 0]) #difference() {
      union() {
        square(size=[20, material_thickness - laser_beam_width], center=true);
        for (y=[1,-1]) {
          translate([-10, y*material_thickness/2, 0]) circle(r=0.1, $fn=12);
        }
      }
      
      translate([-(material_thickness) / 4, 0, 0]) {
        translate([0, material_thickness/2, 0]) circle(r=material_thickness / 8, $fn=12);
        translate([0, material_thickness/-2, 0]) circle(r=material_thickness / 8, $fn=12);
      }
    }
  }
}




// for (i=[0:num_positions-1]) {
//   rotate([0, 0, i*360/num_positions]) {
//     translate([0, torus_r, 0]) rotate([90, 0, -90])   color([120/255, 0, 0]) ext() wheel_arm();
//   }
// }
// 
// translate([0, 0, material_thickness]) {
//   color([0/255, 120/255, 0/255]) {
//     difference() {
//       cylinder(r=central_gear_r, h=material_thickness, center=true);
//       // gear(mm_per_tooth=mm_per_tooth, number_of_teeth = central_gear_num_teeth, thickness=material_thickness);
//       cylinder(r=1.6, h=material_thickness+0.1, center=true);
//     }
//   }
// }
// 
// for (i=[0:num_positions-1]) {
//   rotate([0, 0, (i + 0.5)*360/num_positions]) {
//     translate([0, center_distance(central_gear_num_teeth, planet_gear_num_teeth, mm_per_tooth), material_thickness]) {
//       planet_assembly();
//     }
//   }
// }
// 
// for (i=[0:num_positions-1]) {
//   rotate([0, 0, (i)*360/num_positions]) {
//     translate([material_thickness, torus_r+20-material_thickness/2, disc_r+5]) rotate([90, 0, 90]) {
//       disc_assembly();
//     }
//   }
// }
// 
// ext() support_disk();

support_disk();


translate([torus_r + 25, 0, 0]) {
  // main_disc();
  //   translate([0, disc_r*2+5, 0]) planet_pulley_outer();
  //   translate([0, -(disc_r*2+5), 0]) planet_pulley_inner();
  // translate([disc_r+10+20, 0, 0]) 
  wheel_arm();
}
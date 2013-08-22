// TODOs
// cut actual holes in the faceplate
// model rear features
// cut out rear features
// add screw holes to drawer frame
// add board table to drawer frame
// position raspi
// position power supply


use <raspberry pi.scad>
use <external_parts.scad>

tube_d = 31;
tube_h = 60;

tube_spacing = 40;
num_tubes = 12;

face_height = 130;
face_width = tube_spacing * num_tubes + 20;
overall_depth = 150;

handle_d = 6;
handle_h = 30;
handle_w = 80;
handle_corner_r = 15;

t = 5.2;
k = 0.005 * 25.4;

module top() {
  render()
  difference() {
    cube(size=[face_width, overall_depth, t], center=true);
    translate([-tube_spacing * (num_tubes/2 - 0.5), 0, 0]) {
      for (x = [0:(num_tubes-1)]) {
        translate([x * tube_spacing, 0, 0]) cylinder(r=tube_d/2 + 1, h=t*2, center=true, $fn=72);
      }
    }

    for (x=[-1,1]) {
      translate([x * (face_width / 2), 0, 0]) cube(size=[t*2-k, overall_depth/3, t*2], center=true);
    }

    for (x=[-1:1]) {
      translate([x * face_width/3, overall_depth/2 - t*1.5, 0]) cube(size=[10-k, t+k, t*2], center=true);
    }
  }
}

module bottom() {
  render()
  difference() {
    cube(size=[face_width, overall_depth, t], center=true);
    for (x=[-1,1]) {
      translate([x * (face_width / 2), 0, 0]) cube(size=[t*2-k, overall_depth/3, t*2], center=true);
    }

    for (x=[-1:1]) {
      translate([x * face_width/3, overall_depth/2 - t*1.5, 0]) cube(size=[10-k, t+k, t*2], center=true);
    }
  }
}

module back() {
  color("red")
  
  difference() {
    union() {
      cube(size=[face_width-t*2+k, face_height-t*2+k, t], center=true);
      for (x=[-1:1], y=[-1,1]) {
        translate([x * face_width/3, y * (face_height/2 - t/2), 0]) cube(size=[10+k, t+k, t], center=true);
      }

      for (x=[-1,1], y=[-1,1]) {
        translate([x * (face_width/2 - t/2), y * (face_height/3), 0]) cube(size=[t+k, 10+k, t], center=true);
      }
    }
    translate([(face_width - t*4) / 2 - 35/2, -(face_height - t*4) / 2 + 35/2, 0]) cylinder(r=30/2, h=t*2, center=true);;
  }

}

module handle() {
  color("silver")
  union() {
    for (y=[-1,1]) {
      translate([0, y * (handle_w/2 - handle_d/2), handle_h/2]) cylinder(r=handle_d/2, h=handle_h, center=true, $fn=36);
    }
    translate([0, 0, handle_h - handle_d/2]) rotate([90, 0, 0]) cylinder(r=handle_d/2, h=handle_w, center=true, $fn=36);
  }
}

module face() {
  color("red")
  // render()
  difference() {
    union() {
      translate([0, t/2, 0]) cube(size=[face_width - t*4, face_height - t*3, t], center=true);
      for (x=[-1,1]) {
        translate([x * (face_width - 2 * t) / 3, -(face_height - t*2)/2 + t/2, 0]) cube(size=[10+k, t+k, t], center=true);
        for (y=[-1,1]) {
          translate([x * ((face_width - 2 * t) / 2 - t/2), y * (face_height - t*2)/3, 0]) cube(size=[t+k, 10+k, t], center=true);
        }
      }
    }

    // meter body
    translate([0, -101/2 + 67.26 - 64.25/2, 0]) cylinder(r=67/2, h=t*2, center=true);

    // handles
    for (x=[-1,1]) {
      translate([x * (face_width/2 - 2*t - 10 - 5), 0, 0]) {
        for (y=[-86.2/2 + 6.5/2, 86.2/2 - 6.5/2, 86.2/2 - 35.4 + 6.5/2]) {
          translate([0, y, 0]) 
          cylinder(r=4/2, h=10, center=true);
        }
      }
    }
    
    translate([face_width/2 - 2*t - 10 - 10 - 25 - 16.24/2, 0, 0]) {
      // _power_switch();
      cylinder(r=12/2, h=10, center=true);
    }
    
    
    translate([121/2 + 25 + 25, 0, 0]) cylinder(r=9.5/2, h=10, center=true);
    
    translate([-(121/2 + 25 + 12), 0, 0]) {
      translate([0, 25, 0]) cylinder(r=9.5/2, h=10, center=true);
      translate([0, -25, 0]) cylinder(r=9.5/2, h=10, center=true);
    }
    
    translate([-face_width/2 + 2*t + 10 + 10 + 50, 0, 0]) {
      for (x=[-1,1], y=[-1,1]) {
        translate([x * 20, y*20, 0]) rotate([0, 0, 45]) {
          for (y=[-1,1]) {
            translate([0, y * 17, 0]) cylinder(r=1.5, h=t*2, center=true, $fn=36);
          }
        }
      }
    }
  }
}

module transistor_cap() {
  difference() {
    hull() {
      for (y=[-1,1]) {
        translate([0, y * 17, 0]) cylinder(r=3, h=t, center=true, $fn=36);
      }
      cylinder(r=12.5, h=t, center=true, $fn=72);
    }
    for (y=[-1,1]) {
      translate([0, y * 17, 0]) cylinder(r=1.5, h=t*2, center=true, $fn=36);
    }
  }
}

module face_assembly() {
  face();

  for (x=[-1,1]) {
    translate([x * (face_width/2 - 2*t - 10 - 5), 0, 0]) _handle();
  }

  translate([face_width/2 - 2*t - 10 - 10 - 25 - 16.24/2, 0, -t/2]) _power_switch();

  translate([0, 0, t/2]) _meter();

  translate([121/2 + 25 + 25, 0, -t/2]) _selector_switch();

  translate([-(121/2 + 25 + 12), 0, -t/2]) {
    translate([0, 25, 0]) _pot_250();
    translate([0, -25, 0]) _pot20();
  }
  
  translate([-face_width/2 + 2*t + 10 + 10 + 50, 0, t]) {
    for (x=[-1,1], y=[-1,1]) {
      translate([x * 20, y*20, 0]) rotate([0, 0, 45]) transistor_cap();
    }
  }
}

module side() {
  color("blue")
  render()
  difference() {
    cube(size=[overall_depth, face_height, t], center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * overall_depth/2, y * face_height/2, 0]) cube(size=[overall_depth/3*2-k, t*2-k, t*2], center=true);
    }

    for (x=[1], y=[-1,1]) {
      translate([x * (overall_depth/2 - t*1.5), y * (face_height/3), 0]) cube(size=[t+k, 10-k, t*2], center=true);
    }
  }
}

module drawer_bottom() {
  render()
  assign(drawer_depth = overall_depth - 3*t)
  difference() {
    cube(size=[face_width - 2*t, drawer_depth, t], center=true);

    for (x=[-1,1], y=[-1,1]) {
      translate([x * (face_width/2 - t), y * drawer_depth / 3, 0]) cube(size=[t*2-k, 10-k, t*2], center=true);
      translate([x * (face_width - 2 * t) / 3, y * (drawer_depth/2 + k/2), 0]) cube(size=[10-k, 2*t, t*2], center=true);
    }
  }
}

module drawer_side() {
  color("darkblue")
  render()
  assign(drawer_depth = overall_depth - 3*t)
  difference() {
    union() {
      linear_extrude(height=t, center=true)
        polygon(points=[
          [-t/2, -(face_height/2 - t) + t],
          [-t/2, (face_height/2 - t)],
          [t*2, (face_height/2 - t)],
          [drawer_depth - t/2, -(face_height/2 - t) + 55],
          [drawer_depth - t/2, -(face_height/2 - t) + t],
        ]);

      for (x=[-1,1]) {
        translate([(drawer_depth) / 2 - t/2 + x * (drawer_depth) / 3, -(face_height/2 - t) + t/2, 0]) cube(size=[10+k, t+k, t], center=true);
      }
    }
    translate([overall_depth - t/2 - 2*t - t/2 + k, -(face_height/2 - t) + 25, 0]) cube(size=[t, 10-k, t*2], center=true);
    for (y=[-1,1]) {
      translate([-k/2, y * (face_height - 2*t)/3, 0]) cube(size=[t, 10-k, t*2], center=true);
    }
  }
}

module drawer_back() {
  color("darkred")
  difference() {
    union() {
      translate([0, t/2, 0]) cube(size=[face_width - t*4, 50-t, t], center=true);
      for (x=[-1,1]) {
        translate([x * (face_width/2 - t - t/2), 0, 0]) cube(size=[t+k, 10+k, t], center=true);
        translate([x * (face_width - 2 * t) / 3, -25 + t/2, 0]) cube(size=[10+k, t+k, t], center=true);
      }
    }
    
    translate([(face_width - t*4) / 2 - 35/2, -(50-t*2) / 2 + 35/2, 0]) {
      for (y=[-1,1]) {
         translate([y * (25.2/2 - 12/2), 0, 0]) cylinder(r=12/2, h=t*2, center=true);
         translate([0, y * (19.5/2 - 2.8/2), 0]) cylinder(r=1.5, h=t*2, center=true, $fn=36);
       }
    }
  }
}

module drawer_assembly() {
  assign(drawer_depth=overall_depth - t*3){
    rotate([90, 0, 0]) face_assembly();
    translate([0, overall_depth/2 - 2*t, -face_height/2 + t + t/2]) drawer_bottom();

    for (x=[-1,1]) {
      translate([x * (face_width/2 - t - t/2), 0, 0]) rotate([90, 0, 90]) drawer_side();
    }

    translate([0, drawer_depth - t, -face_height/2 + t + 25]) rotate([90, 0, 0]) drawer_back();

    translate([(face_width - t*4) / 2 - 35/2, drawer_depth - t/2, -(face_height - t*4) / 2 + 35/2]) 
      rotate([-90, 0, 0]) _ac_plug();
  }
}

module assembled() {
  translate([0, 0, face_height/2 - t/2]) top();
  translate([0, 0, -face_height/2 + t/2]) bottom();

  translate([0, overall_depth/-2 + 1.5*t, 0]) drawer_assembly();
  translate([0, overall_depth/2 - 1.5*t, 0]) rotate([90, 0, 0]) back();

  translate([face_width/2 - t/2, 0, 0]) rotate([90, 0, 90]) side();
  translate([-face_width/2 + t/2, 0, 0]) rotate([90, 0, 90]) side();

  translate([100, -30, -face_height/2 + 15]) raspi();

  translate([0, 0, face_height/2 - t])
  for (x=[-1:1]) {
    translate([x * 160, 0, 0]) _pcba();
  }
}

assembled();


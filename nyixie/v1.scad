// TODOs
// center the logo precisely in the space!

use <bbb.scad>
use <external_parts.scad>

tube_d = 31;
tube_h = 60;

tube_spacing = 40;
num_tubes = 12;

face_height = 150;
face_width = tube_spacing * num_tubes + 20;
echo("face width: ", face_width);
overall_depth = 200;

handle_d = 6;
handle_h = 30;
handle_w = 80;
handle_corner_r = 15;

t = 4.8;
k = 0.005 * 25.4;

foot_spacing_x = face_width - 8 * t;
foot_spacing_y = overall_depth - 8 * t;
foot_r = 7.5;
foot_height = 16;
foot_screw_r = 4.9/2;
foot_screw_len = t+2;


module _foot() {
  color("black")
    translate([0, 0, -foot_height / 2]) 
      cylinder(r=foot_r, h=foot_height, center=true);
  color("gray")
    translate([0, 0, foot_screw_len / 2]) 
      cylinder(r=foot_screw_r, h=foot_screw_len, center=true);
}

module top() {
  render()
  difference() {
    cube(size=[face_width+k, overall_depth-t+k, t], center=true);

    // ports for tubes
    translate([-tube_spacing * (num_tubes/2 - 0.5), t/2, 0]) {
      for (x = [0:(num_tubes-1)]) {
        translate([x * tube_spacing, -t, 0]) cylinder(r=tube_d/2 + 1, h=t*2, center=true, $fn=72);
      }
    }

    // side tabs
    for (x=[-1,1], y=[-1,0,1]) {
      translate([x * (face_width / 2), y * (overall_depth - t) / 3, 0]) 
        cube(size=[t*2-k, 10-k, t*2], center=true);
    }

    // back tabs
    for (x=[-1:1]) {
      translate([x * face_width/3, overall_depth/2 - t/2, 0]) 
        cube(size=[10-k, 2*t+k, t*2], center=true);
    }
  }
}

module bottom() {
  render()
  difference() {
    cube(size=[face_width+k, overall_depth+k-t, t], center=true);

    // side tabs
    for (x=[-1,1], y=[-1,0,1]) {
      translate([x * (face_width / 2), y * (overall_depth - t) / 3, 0]) 
        cube(size=[t*2-k, 10-k, t*2], center=true);
    }

    // back tabs
    for (x=[-1:1]) {
      translate([x * face_width/3, overall_depth/2 - t/2, 0]) 
        cube(size=[10-k, 2*t+k, t*2], center=true);
    }

    // holes for feet screws
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (foot_spacing_x / 2), t/2 + y * foot_spacing_y/2, 0]) 
        cylinder(r=foot_screw_r, h=t*2, center=true, $fn=36);
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

    translate([(face_width - t*4) / 2 - 35/2, -(face_height - t*4) / 2 + 35/2, 0]) {
      cylinder(r=30/2, h=t*2, center=true);

      translate([0, 35/2 + 10, 0]) {
        for (x=[-1,1]) {
          translate([x * (31.87 / 2 - 1.5 - 3.3/2 ), -11.17/2 + 1.5 + 3.3/2, 0]) cylinder(r=(3-k)/2, h=t*2, center=true, $fn=36);
        }
      }
    }

    translate([0, -face_height/2 + t + 25, 0]) 
    for (x=[-1,1]) {
      translate([x * face_width/3, 0, 0]) cylinder(r=3-k, h=t*2, center=true, $fn=36);
    }
    
    
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
  assign(drawer_depth = overall_depth - 3*t)
  difference() {
    union() {
      cube(size=[face_width, face_height, t], center=true);
    }

    // face/side tabs
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (face_width / 2 - t - t/2), y * (face_height - 2*t)/3, 0]) 
        cube(size=[t-k, 10-k, t*2], center=true);
    }
    
    // face/bottom tabs
    for (x=[-1,0,1]) {
      // front/back tabs
      translate([x * (face_width - 2 * t) / 3, -1 * (face_height/2 - t - t/2 + k/2), 0]) 
        cube(size=[10-k, t-k, t*2], center=true);
    }

    // meter body
    translate([0, -101/2 + 67.26 - 64.25/2, 0]) cylinder(r=67/2, h=t*2, center=true);
    // meter mounting screws
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (103.73 - 3.91) / 2, y * (83.69 - 3.91) / 2, 0]) cylinder(r=2, h=t*2, center=true, $fn=36);
    }

    // probe plug
    translate([121/2 + 25 + 25 + 15 + 41/2, -(face_height - 4*t) / 2 + 41/2 + 5, 0]) {
      cylinder(r=25/2+0.1, h=t*2, center=true);
      for (a=[0:2]) {
        rotate([0, 0, 90 + a*120]) translate([35.6 - (41/2) + 3/2, 0, 1]) cylinder(r=3/2, h=t*2, center=true, $fn=12);
      }
    }

    // handles
    for (x=[-1,1]) {
      translate([x * (face_width/2 - 2*t - 10 - 5), 0, 0]) {
        for (y=[-86.2/2 + 6.5/2, 86.2/2 - 6.5/2, 86.2/2 - 35.4 + 6.5/2]) {
          translate([0, y, 0]) 
          cylinder(r=4/2 + k, h=10, center=true, $fn=16);
        }
      }
    }

    // lamp holder and power switch
    translate([face_width/2 - 2*t - 10 - 10 - 25 - 16.24/2, 0, 0]) {
      translate([0, -20, 0]) cylinder(r=12/2, h=t*2, center=true);
      translate([0, 20, 0]) cylinder(r=17.5/2, h=t*2, center=true);
    }

    // selector switch
    translate([121/2 + 25 + 25, 0, 0]) 
      cylinder(r=9.5/2+0.1, h=10, center=true);

    // pot holes
    translate([-(121/2 + 25 + 12), 0, 0]) {
      translate([0, 25, 0]) cylinder(r=9.5/2 + 0.1, h=10, center=true);
      translate([0, -25, 0]) cylinder(r=9.5/2 + 0.1, h=10, center=true);
    }
  }
}

module face_assembly() {
  face();

  for (x=[-1,1]) {
    translate([x * (face_width/2 - 2*t - 10 - 5), 0, 0]) _handle();
  }

  translate([face_width/2 - 2*t - 10 - 10 - 25 - 16.24/2, 0, -t/2]) {
    translate([0, -20, 0]) _power_switch();
    translate([0, 20, t]) _lamp();
  }

  translate([0, 0, t/2]) _meter();

  translate([121/2 + 25 + 25, 0, -t/2]) _selector_switch();

  translate([121/2 + 25 + 25 + 15 + 41/2, -(face_height - 4*t) / 2 + 41/2 + 5, t/2]) _probe_plug();

  translate([-(121/2 + 25 + 12), 0, -t/2]) {
    translate([0, 25, 0]) _pot_250();
    translate([0, -25, 0]) _pot20();
  }
}

module side() {
  color("blue")
  render()
  difference() {
    union() {
      cube(size=[overall_depth-t+k, face_height-2*t+k, t], center=true);

      // tabs for top/bottom
      for (x = [-1,0,1], y=[-1,1]) {
        translate([x * (overall_depth - t) / 3, y * (face_height - 2 * t) / 2, 0]) 
        cube(size=[10+k, 2*t+k, t], center=true);
      }
    }

    // // cut outs for top tab
    // for (x=[-1,1], y=[-1,1]) {
    //   translate([x * overall_depth/2, y * face_height/2, 0]) cube(size=[overall_depth/3*2-k, t*2-k, t*2], center=true);
    // }

    // cut outs for back tabs
    for (x=[1], y=[-1,1]) {
      translate([x * (overall_depth/2 - t/2), y * (face_height/3), 0]) 
        cube(size=[t*2-k, 10-k, t*2], center=true);
    }
  }
}

module drawer_bottom() {
  color("orange")
  render()
  assign(drawer_inside_width = face_width - t*4)
  assign(drawer_depth = overall_depth - 2*t)
  difference() {
    union() {
      cube(size=[face_width - 2*t + k, drawer_depth - t + k, t], center=true);      

      for (x=[-1,0,1], y=[-1,1]) {
        // front/back tabs
        translate([x * (face_width - 2 * t) / 3, y * (drawer_depth/2 - t/2 + k/2), 0]) 
          cube(size=[10+k, 2*t+k, t], center=true);
      }
    }

    translate([0, t/2, 0]) cube(size=[10, t, 2*t], center=true);

    for (x=[-1,1], y=[-1,1]) {
      // side tab-ins
      translate([x * (face_width/2 - t), y * (overall_depth-t) / 3, 0])
        cube(size=[t*2-k, 10-k, t*2], center=true);
    }

    // beaglebone black screw footprint
    assign(inch = 25.4)
    assign(holeR = 0.125/2 * inch)
    translate([-drawer_inside_width/2 + 60, drawer_depth/2 - 75 + t/2, 0]) {
      for (xyz=[[0.575 * inch, 0.125 * inch, 0], [0.575 * inch, 2.025 * inch, 0], [3.175 * inch, 0.250 * inch, 0], [3.175 * inch, 1.900 * inch, 0]]) {
        translate(xyz) cylinder(r=holeR-k-0.1, h=t*2, center=true, $fn=36);
      }
    }

    // clear-outs for the screw heads of the feet
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (foot_spacing_x / 2), t/2 + y * foot_spacing_y/2, 0]) 
        cylinder(r=foot_screw_r*2, h=t*2, center=true);
    }
  }
}

module drawer_side() {
  color("darkblue")
  render()
  assign(drawer_depth = overall_depth - t)
  difference() {
    union() {
      linear_extrude(height=t, center=true)
        polygon(points=[
          [t/2, -(face_height/2 - t) + t ],
          [t/2, (face_height/2 - t)],
          [t/2 + t, (face_height/2 - t)],
          [t/2 + t + t, (face_height/2 - t) - t],
          [-t/2 + drawer_depth/2 + 35 + 10, (face_height/2 - t) - t],
          [drawer_depth - t/2, -(face_height/2 - t) + 55],
          [drawer_depth - t/2, -(face_height/2 - t) + t ],
        ]);

      // bottom tabs
      for (x=[-1,1]) {
        translate([(drawer_depth) / 2 - t/2 + x * (drawer_depth) / 3, -(face_height/2 - t) + t/2, 0]) 
          cube(size=[10+k, t+k, t], center=true);
      }

      // face tabs
      for (y=[-1,1]) {
        translate([0, y * (face_height - 2*t)/3, 0]) 
          cube(size=[t+k, 10+k, t], center=true);
      }
    }

    // back tab
    translate([overall_depth - t - t/2 + k, -(face_height/2 - t) + 25, 0]) 
      cube(size=[2*t-k, 10-k, t*2], center=true);

    // slots for pcb tray
    translate([drawer_depth/2, face_height / 2 - t - 4 - 1.7/2 - 25.7, 0]) {
      translate([0, -10 - t, 0]) cube(size=[t-k, 10-k, t*2], center=true);
      for (x=[-1,1]) {
        translate([x * 30, -t/2, 0]) cube(size=[10-k, t-k, t*2], center=true);
      }
    }
  }
}

module drawer_back() {
  color("darkred")
  render()
  difference() {
    union() {
      translate([0, 0, 0]) 
        cube(size=[face_width - t*4, 50, t], center=true);

      // side tabs
      for (x=[-1,1]) {
        translate([x * (face_width/2 - t - t/2), 0, 0]) 
          cube(size=[t+k, 10+k, t], center=true);
      }
    }

    // bottom tab slots
    for (x=[-1,0,1]) {
      translate([x * (face_width - 2 * t) / 3, -25, 0]) 
        cube(size=[10-k, 2*t-k, t*2], center=true);
    }

    // screw holes
    for (x=[-1,1]) {
      translate([x * face_width/3, 0, 0]) 
        cylinder(r=3-k-0.1, h=t*2, center=true, $fn=36);
    }

    // plug holes
    translate([(face_width - t*4) / 2 - 35/2, -(50-t*2) / 2 + 35/2, 0]) {
      for (y=[-1,1]) {
         translate([y * (25.2/2 - 12/2), 0, 0]) cylinder(r=12/2, h=t*2, center=true);
         translate([0, y * (19.5/2 - 2.8/2), 0]) cylinder(r=1.5, h=t*2, center=true, $fn=36);
       }
    }
  }
}

module pcb_deck() {
  color("orange")
  assign(drawer_inside_width = face_width - t*4) 
  render()
  difference () {
    cube(size=[drawer_inside_width + t*2, 70, t], center=true);
    for (x=[-1:1]) {
      translate([x * 160, 0, 0]) {
        for (x1=[-1:1], y=[-1,1]) {
          translate([x1*70, y*30, 0]) cylinder(r=3/2, h=t*2, center=true, $fn=36);
        }
      }
    }

    for (x = [-1,1]) {
      translate([x * (drawer_inside_width + t*2)/2, 0, 0]) cube(size=[t*2-k, 70-20-k, t*2], center=true);
    }

    for (x=[-1:1]) {
      translate([x*150, 0, 0]) cube(size=[10-k, t-k, t*2], center=true);
    }
  }
}

module pcb_deck_support() {
  color("green")
  assign(drawer_inside_width = face_width - t*4) 
  assign(pillar_height = face_height - t - 4 - 1.7 - 25.7 - t - 20 - 2 * t + t/4)
  render()
  difference () {
    union() {
      cube(size=[drawer_inside_width, 20+k, t], center=true);

      translate([0, - 10 - pillar_height/2, 0]) 
        cube(size=[40, pillar_height, t], center=true);

      translate([0, -10 - pillar_height, 0]) 
        cube(size=[10, 2*t, t], center=true);

      for (x = [-1:1]) {
        translate([x * 150, 10+t/2, 0]) cube(size=[10+k, t+k, t], center=true);
      }

      for (x=[-1,1]) {
        translate([x * (drawer_inside_width / 2 + t/2), 0, 0]) cube(size=[t+k, 10+k, t], center=true);
      }
    }
  }
}

module drawer_assembly() {
  assign(drawer_depth=overall_depth - t)
  assign(drawer_inside_width = face_width - t*4) {
    translate([0, t/2, 0]) rotate([90, 0, 0]) face_assembly();
    translate([0, overall_depth/2 - t/2, -face_height/2 + t + t/2]) 
      drawer_bottom();

    // for (x=[-1,1]) {
    //   translate([x * (face_width/2 - t - t/2), t/2, 0]) 
    //     rotate([90, 0, 90]) 
    //       drawer_side();
    // }

    translate([0, drawer_depth - t/2, -face_height/2 + t + 25]) 
      rotate([90, 0, 0]) drawer_back();

    translate([(face_width - t*4) / 2 - 35/2, drawer_depth - t/2, -(face_height - t*4) / 2 + 35/2]) 
      rotate([-90, 0, 0]) _ac_plug();

    translate([drawer_inside_width/2 - 50 - 50, drawer_depth - 40, -face_height/2 + 10 + 20]) 
      _power_supply();

    translate([-drawer_inside_width/2 + 60, drawer_depth - 75, -35]) 
      beagleboneblack();

    translate([0, drawer_depth/2 + t/2, face_height / 2 - t - 4 - 1.7/2 - 25.7]) {
      translate([0, 0, -t/2]) pcb_deck();
      translate([0, 0, -t - 10]) rotate([90, 0, 0]) pcb_deck_support();
    }
  }
}

module assembled() {
  translate([0, t/2, face_height/2 - t/2]) top();
  // translate([0, t/2, -face_height/2 + t/2]) bottom();

  translate([0, -overall_depth/2, 0]) drawer_assembly();
  translate([0, overall_depth/2 - t / 2, 0]) rotate([90, 0, 0]) back();

  // translate([face_width/2 - t/2, t/2, 0]) rotate([90, 0, 90]) side();
  // translate([-face_width/2 + t/2, t/2, 0]) rotate([90, 0, 90]) side();

  translate([0, 0, face_height/2 - t - 4])
  for (x=[-1:1]) {
    translate([x * 160, 0, 0]) _pcba();
  }

  translate([(face_width - t*4) / 2 - 35/2, overall_depth / 2 + 0.5, -(face_height - t*4) / 2 + 35 + 10]) 
    rotate([90, 0, 0]) 
      _voltage_plate();

  for (x = [-1,1], y = [-1,1]) {
    translate([x * (foot_spacing_x / 2), y * (foot_spacing_y/2), -face_height/2]) 
      _foot();
  }
  
}

// assembled();

projection(cut=true) {
  // face();
  // drawer_bottom();
  // drawer_side();
  // drawer_back();
  // pcb_deck();
  // pcb_deck_support();
  
  // top();
  bottom();
  // side();
  // back();
}



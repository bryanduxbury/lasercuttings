// TODOs
// - design the external case
// - zip tie holes

use <../publicDomainGearV1.1.scad>

render_gears = true;

// Parameters

// material thickness
t = 4.5;

// 1/4" rod for shafts
shaft_diameter = 6.1;
// nut dims
//   t = 5.66 mm 
//   shortest across = 10.97 mm
//   longest across = 12.34 mm
//   id = 5.22mm
nut_t = 5.75;
nut_shortest_dia = 11;

// slot-tab size
tab_size = 10;

// panels used to display numerals
numeral_h = 2.25 * 25.4;
numeral_w = 1.25 * 25.4;

// gear parameters
mm_per_tooth = 17; // arbitrary

// number of teeth on the numeral drums
major_gear_num_teeth = 40;
// ... and some consequences of this choice
function partial_gear_num_hidden_teeth() = major_gear_num_teeth - major_gear_num_teeth / 10;
function minor_gear_num_teeth() = major_gear_num_teeth/4;
function major_gear_outer_diameter() = 2 * outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth = mm_per_tooth);

// number of teeth on the connecting gears (as well as on the drive gear)
connecting_gear_num_teeth = 8;

gear_minimum_width = 20;

// case 

// flange dims
//   outside dia = 77.12 mm
//   opposite holes outside to outside = 60.66 mm
//   hole diameter = 7.0mm
// 
//   inner dia = 18.19 mm
//   cylinder dia = 27.75mm
// 
//   base t = 5.6mm
//   total t = 14.36

flange_hole_r = 7/2;
flange_hole_distance_from_center = 60.66 / 2 - flange_hole_r;
flange_pipe_id = 18.19;

case_clearance = 12.5;

motor_body_length = 22 + 30 + 12.5;
motor_nonconnecting_shaft_length = 10;
case_width = 9 * drum_width() + 10 * t + 2 * case_clearance + motor_body_length + motor_nonconnecting_shaft_length;
echo("case width: ", case_width);
case_height = major_gear_outer_diameter() + 2*case_clearance;
echo("case height: ", case_height);
case_depth = major_gear_outer_diameter() + 2*case_clearance;

// some functionalized parameters
function numeral_radius() = 10 * (numeral_h + 2) / 3.141592 / 2;
function drum_width() = numeral_w + 2*t;

// tslot stuff
tslot_screw_d = 6;
tslot_screw_nut_t = nut_t;
tslot_screw_nut_dia = nut_shortest_dia;
echo("tslot bolt length: ", (t + t/2 + tslot_screw_nut_t));

module tslot_cutout() {
  assign(total_len = t + tslot_screw_nut_t)
  union() {
    translate([0, total_len/2 - 0.1, 0]) cube(size=[tslot_screw_d, total_len, t+0.1], center=true);
    translate([0, t/2 + tslot_screw_nut_t/2, 0]) cube(size=[tslot_screw_nut_dia, tslot_screw_nut_t, t+0.1], center=true);
  }
}

// gear related functions
function p(
  mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
  number_of_teeth = 11    //total number of teeth around the entire perimeter
) = mm_per_tooth * number_of_teeth / 3.1415926 / 2;

function c(
  mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
  number_of_teeth = 11,   //total number of teeth around the entire perimeter
  clearance       = 0.0   //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
) = p(mm_per_tooth, number_of_teeth) + mm_per_tooth / 3.1415926 - clearance;

function root_radius(
  number_of_teeth = 11,   //total number of teeth around the entire perimeter
  clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
) = p(mm_per_tooth, number_of_teeth)-(c(mm_per_tooth, number_of_teeth, clearance)-p(mm_per_tooth, number_of_teeth))-clearance;

function center_distance(t1, t2) = pitch_radius(number_of_teeth=t1, mm_per_tooth = mm_per_tooth) 
  + pitch_radius(number_of_teeth=t2, mm_per_tooth = mm_per_tooth);

// save some parameters on calls to gear()
module my_gear(number_of_teeth, teeth_to_hide=0) {
  render() gear(mm_per_tooth = mm_per_tooth, 
    number_of_teeth = number_of_teeth, 
    thickness = t, 
    hole_diameter=shaft_diameter, 
    teeth_to_hide=teeth_to_hide);
}

module connecting_gear() {
  color([128/255, 192/255, 0/255]) my_gear(connecting_gear_num_teeth);
}

module drive_gear() {
  color([64/255, 225/255, 64/255]) union() {
    my_gear(connecting_gear_num_teeth);
    translate([0, shaft_diameter/2, 0]) cube(size=[shaft_diameter, 1.2, t], center=true);
  }
}

module drum_gear_cutouts() {
  assign(or = root_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth = mm_per_tooth) - gear_minimum_width) difference()  {
    cylinder(r=or, h=10, center=true, $fn=72);
    cylinder(r=gear_minimum_width + shaft_diameter/2, h=11, center=true, $fn=250);
    for (a=[0:3]) {
      rotate([0, 0, a*90]) 
        translate([0, or/2, 0]) cube(size=[gear_minimum_width, or, 11], center=true);
    }
  }
}

module drum_complete_gear() {
  render() difference() {
    my_gear(number_of_teeth = major_gear_num_teeth);
    drum_gear_cutouts();
    for (a=[0:9]) {
      rotate([0, 0, a*36+18]) translate([numeral_radius(), 0, 0]) cube(size=[t, tab_size, t+0.1], center=true);
    }
  }
}

module drum_partial_gear() {
  render() difference() {
    union() {
      rotate([0, 0, -360/major_gear_num_teeth * 4]) my_gear(number_of_teeth = major_gear_num_teeth, teeth_to_hide=partial_gear_num_hidden_teeth());
      cylinder(r=root_radius(major_gear_num_teeth,0), h=t, center=true, $fn=128);
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true, $fn=36);
    drum_gear_cutouts();
    for (a=[0:9]) {
      rotate([0, 0, a*36+18]) translate([numeral_radius(), 0, 0]) cube(size=[t, tab_size, t+0.1], center=true);
    }
  }
}

module drum_support() {
  color([128/255, 0/255, 0/255]) 
  render() 
  assign(h=outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth=mm_per_tooth)+case_clearance)
  difference() {
    union() {
      cylinder(r=10, h=t, center=true, $fn=36);
      translate([0, -h/2, 0]) cube(size=[h, h, t], center=true);
      translate([0, -h + 10, 0]) cube(size=[h, 20, t], center=true);
      for (x=[-1,1]) translate([x * h/2, -h + t, 0]) intersection() {
        cylinder(r=20 - t, h=t, center=true);
        translate([0, 20, 0]) cube(size=[40, 40, 10], center=true);
      }
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true);
    for (x=[-1,1]) translate([x * h/2, 0, 0]) scale([(h-20)/2, h-20, 1]) cylinder(r=1, h=t+0.1, center=true, $fn=720);
    
    for (x=[-1:1]) {
      translate([x * (h/2 - (h-2*tab_size)/3/2), -h, 0]) cube(size=[(h-2*tab_size)/3, 2*t, t+0.1], center=true);
    }

    translate([0, -h + t, 0]) tslot_cutout();
  }
}

module connecting_gear_support() {
  color([128/255, 0/255, 0/255]) 
  render()
  assign(cd = center_distance(connecting_gear_num_teeth, major_gear_num_teeth))
  assign(pr1 = pitch_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(or1 = outer_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(c = case_clearance + (or1 - pr1))
  assign(h=(or1 + case_clearance) - (cd * cos(45)))
  difference() {
    union() {
      cylinder(r=10, h=t, center=true, $fn=72);
      translate([40, -h/2, 0]) cube(size=[100, h, t], center=true);
      translate([90, -h+t, 0]) intersection() {
        cylinder(r=20-t, h=t, center=true);
        translate([0, 20, 0]) cube(size=[40, 40, 10], center=true);
      }
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true, $fn=72);
    translate([90, 0, 0]) scale([80, (h-20), 1]) cylinder(r=1, h=10, center=true, $fn=720);
    translate([40, 0, 0]) for (x=[-1:1]) {
      translate([x * (100/2 - (100-2*tab_size)/3/2), -h, 0]) cube(size=[(100-2*tab_size)/3+0.1, 2*t, t+0.1], center=true);
    }
    
    translate([40, -h+t, 0]) tslot_cutout();
  }
}

module numeral_plate() {
  color([200/255, 200/255, 200/255]) union() {
    cube(size=[numeral_w, numeral_h, t], center=true);
    cube(size=[numeral_w + 2*t, tab_size, t], center=true);
  }
}

module drum_assembly() {
  translate([numeral_w/2 + t/2, 0, 0]) rotate([0, 90, 0]) drum_complete_gear();
  translate([-numeral_w/2 - t/2, 0, 0]) rotate([0, 90, 0]) drum_partial_gear();

  for (n=[0:9]) {
    rotate([360/10*n, 0, 0]) translate([0, numeral_radius(), 0]) rotate([90, 0, 0]) numeral_plate();
  }
}

module bottom() {
  color([240/255, 240/255, 240/255, 0.5]) 
  render() 
  assign(h=outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth=mm_per_tooth)+case_clearance)
  difference() {
    top();
    translate([case_width/2 - case_clearance - 2100/1000 * 25.4 / 2, 0, 0]) rotate([0, 0, -90]) arduino_hole_pattern();

    // tab cutouts for the drum supports
    translate([-case_width/2 + case_clearance + t/2, 0, 0]) for (i=[0:9]) {
      translate([i * (drum_width() + t), 0, 0]) {
        for (y=[-1,1]) translate([0, y*(h+tab_size)/6, 0]) cube(size=[t, tab_size, t+0.1], center=true);
        cylinder(r=tslot_screw_d/2+0.1, h=t+0.1, center=true, $fn=36);
      }
    }

    // tab cutouts for the connecting gear supports
    assign(startx = -case_width/2 + case_clearance + t + drum_width() - t - t/2)
    assign(yoff = center_distance(major_gear_num_teeth, connecting_gear_num_teeth) * sin(45))
    translate([startx, yoff, 0]) for (x2=[0, 4]) for (x=[0:7]) {
      translate([x2 * t + x * (drum_width() + t), 0, 0]) {
        for (y=[-1,1]) translate([0, -40 + y * ((100+tab_size)/6), 0]) cube(size=[t, tab_size, t+0.1], center=true);
        translate([0, -40, 0]) cylinder(r=tslot_screw_d/2+0.1, h=t+0.1, center=true, $fn=36);
      }
    }

    // tab + screw hole for motor mount
    assign(yoff = center_distance(major_gear_num_teeth, connecting_gear_num_teeth) * sin(45))
    translate([-case_width/2 + case_clearance + t + drum_width()/2 + 8.5 * (drum_width()+t) - t/2 + 10, 0, 0]) 
      translate([0, yoff, 0]) {
        cylinder(r=tslot_screw_d/2+0.1, h=t+0.1, center=true, $fn=36);
        for (y=[-1,1]) {
          translate([0, y * ((36.8 - 2 * tab_size) / 2 + tab_size/2), 0]) cube(size=[t, tab_size, t+0.1], center=true);
        }
      }
  }
}

module top() {
  color([240/255, 240/255, 240/255, 0.5])
  render()
  difference() {
    cube(size=[case_width+2*t, case_depth, t], center=true);

    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([case_width/2 * x, case_depth/2 * y, 0]) 
          cube(size=[case_width / 3 * 2 - tab_size, 2*t, t+0.1], center=true);
        translate([0, case_depth/2 * y, 0]) cube(size=[case_width/3 - tab_size, 2*t, t+0.1], center=true);

        translate([(case_width/2 - t/2) * x, case_depth/6 * y, 0]) cube(size=[t, tab_size, t+0.1], center=true);
        // translate([case_width/2 * x, 0, 0]) cube(size=[2*t, case_depth/3 - tab_size, t+0.1], center=true);
      }
    }
  }
}

module front_back_base() {
  render()
  difference() {
    union() {
      echo("front/back height: ", case_height + nut_shortest_dia + 2 * (nut_shortest_dia/2 + t));
      cube(size=[case_width + nut_shortest_dia, case_height + nut_shortest_dia, t], center=true);

      // bolt tabs
      for (x=[-1:1]) {
        for (y=[-1,1]) {
          echo("bolt tab dia: ", 2 * (nut_shortest_dia/2 + t));
          translate([x * (-case_width/2 + 2 * t + nut_shortest_dia/2), y * (-case_height/2 - nut_shortest_dia/2), 0]) 
            cylinder(r=nut_shortest_dia/2 + t, h=t, center=true,$fn=36);
        }
      }

      // for (x=[-1,1]) for (y=[-1,1]) {
      //   translate([x * (-case_width/2 - nut_shortest_dia/2), y * (-case_height/2 + 2 * t + nut_shortest_dia/2), 0]) 
      //     cylinder(r=nut_shortest_dia/2 + t, h=t, center=true,$fn=36);
      // }
    }

    // bolt drill-outs
    for (x=[-1:1]) {
      for (y=[-1,1]) {
        translate([x * (-case_width/2 + 2 * t + nut_shortest_dia/2), y * (-case_height/2 - nut_shortest_dia/2), 0]) 
          cylinder(r=shaft_diameter/2, h=t+0.1, center=true,$fn=36);
      }
    }
    
    // for (x=[-1,1]) for (y=[-1,1]) {
    //   translate([x * (-case_width/2 - nut_shortest_dia/2), y * (-case_height/2 + 2 * t + nut_shortest_dia/2), 0]) 
    //     cylinder(r=shaft_diameter/2, h=t+0.1, center=true,$fn=36);
    // }

    for (x=[-1,1]) for (y=[-1,1]) {
      translate([x * (case_width/6), y * (case_height/2 - t/2), 0]) cube(size=[tab_size, t, t+0.1], center=true);
      translate([x * (case_width/2 - t/2), y * (case_height/6), 0]) cube(size=[t, tab_size, t+0.1], center=true);
    }
  }
}

module front() {
  color([240/255, 240/255, 240/255, 0.5]) front_back_base();
}

module back() {
  color([240/255, 240/255, 240/255, 0.5]) front_back_base();
}


module side() {
  color([240/255, 240/255, 240/255, 0.5])
  render()
  difference() {
    cube(size=[case_depth, case_height, t], center=true);
    for (x=[-1,1]) for (y=[-1,1]) {
      translate([case_height/2 * x, case_depth/2 * y, 0]) 
        cube(size=[case_height / 3 * 2 - tab_size, 2*t, t+0.1], center=true);
      translate([0, case_depth/2*y, 0]) cube(size=[case_height/3 - tab_size, 2*t, t+0.1], center=true);

      translate([case_height/2 * x, case_depth/2 * y, 0]) 
        cube(size=[2*t, case_height / 3 * 2 - tab_size, t+0.1], center=true);
      translate([case_height/2 * y, 0, 0]) cube(size=[2*t, case_height/3 - tab_size, t+0.1], center=true);
    }

    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([flange_hole_distance_from_center, 0, 0]) cylinder(r=flange_hole_r, h=t+0.1, center=true);
    }

    cylinder(r=flange_pipe_id/2, h=t+0.1, center=true);
  }
}

module motor_basket() {
  translate([0, -7, 0]) 
  assign(cd = center_distance(connecting_gear_num_teeth, major_gear_num_teeth))
  assign(pr1 = pitch_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(or1 = outer_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(c = case_clearance + (or1 - pr1))
  assign(h=(or1 + case_clearance) - (cd * cos(45)) - 7)
  render() difference() {
    union() {
      cylinder(r=36.8/2, h=t, center=true, $fn=72);
      translate([0, -h/2, 0]) cube(size=[36.8, h, t], center=true);
    }
    
    cylinder(r=36.8/2+0.1, h=10, center=true);
    
    cube(size=[40, 36.8/2, 10], center=true);


    translate([0, -h, 0]) cube(size=[40, 2*t, t+0.1], center=true);

    for (x=[-1,1]) {
      translate([x*(36.8/2 - t), -h + 2 * t + 1.6, 0]) cylinder(r=1.6, h=10, center=true,$fn=36);
    }
  }
}

module motor_face_bracket() {
  translate([0, -7, 0]) 
  assign(cd = center_distance(connecting_gear_num_teeth, major_gear_num_teeth))
  assign(pr1 = pitch_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(or1 = outer_radius(number_of_teeth=major_gear_num_teeth, mm_per_tooth=mm_per_tooth))
  assign(c = case_clearance + (or1 - pr1))
  assign(h=(or1 + case_clearance) - (cd * cos(45)) - 7)
  difference() {
    union() {
      cylinder(r=36.8/2, h=t, center=true, $fn=72);
      translate([0, -h/2, 0]) cube(size=[36.8, h, t], center=true);
    }

    translate([0, 7, 0]) cylinder(r=6, h=10, center=true, $fn=36);

    for (a=[0:5]) {
      rotate([0, 0, a*60]) translate([15.5, 0, 0]) cylinder(r=1.5, h=10, center=true, $fn=36);
    }

    translate([0, -h, 0]) cube(size=[36.8 - 2 * tab_size, t*2, t+0.1], center=true);
    translate([0, -h + t, 0]) tslot_cutout();
    // for (x=[-1,1]) {
    //       translate([x * 36.8/2, -h, 0]) cube(size=[(36.8-tab_size), 2*t, t+0.1], center=true);
    //       translate([x*(36.8/2 - t), -h + 2 * t + 1.6, 0]) cylinder(r=1.6, h=10, center=true,$fn=36);
    //     }
  }
}

module mock_motor() {
  color([128/255, 128/255, 128/255]) translate([0, 7, -10]) union() {
    translate([0, 0, -11]) difference() {
      cylinder(r=36.8/2, h=22, center=true, $fn=72);
      for (i=[0:5]) {
        rotate([0, 0, i*60]) translate([15.5, 0, 22/2 - 1.4]) cylinder(r=1.5, h=3, center=true, $fn=36);
      }
    }
    translate([0, 0, -22 - 15]) cylinder(r=(36.8-2)/2, h=30, center=true, $fn=72);
    translate([0, 0, -52 - 12.5/2]) cylinder(r=24.1/2, h=12.5, center=true);
    
    // offset shaft
    translate([0, -7, 0]) {
      translate([0, 0, 6.5/2]) cylinder(r=12/2, h=6.5, center=true, $fn=36);
      translate([0, 0, 6.5 + 3.5/2]) cylinder(r=6/2, h=3.5, center=true, $fn=36);
      translate([0, 0, 6.5 + 3.5 + 12/2]) difference() {
        cylinder(r=6/2, h=12, center=true, $fn=36);
        translate([0, 3, 0]) cube(size=[7, 1.2, 13], center=true);
      }
    }
  }
  
}

module mock_arduino() {
  difference() {
    scale(1/1000 * 25.4) cube(size=[2700, 2100, 125], center=true);
    arduino_hole_pattern();
  }
  
}

module arduino_hole_pattern() {
  scale(1/1000 * 25.4) translate([-2700/2, -2100/2, 0]) {
    for (pt=[[550,100],[600,2000],[2600,300],[2600,1400]]) {
      translate([pt[0], pt[1], 0]) cylinder(r=125/2, h=t/25.4*1000+0.1, center=true);
    }
  }
}

// flange dims
//   outside dia = 77.12 mm
//   opposite holes outside to outside = 60.66 mm
//   hole diameter = 7.0mm
// 
//   inner dia = 18.19 mm
//   cylinder dia = 27.75mm
// 
//   base t = 5.6mm
//   total t = 14.36
module flange() {
  color([64/255, 64/255, 64/255]) render() difference() {
    union() {
      translate([0, 0, 5.6/2]) cylinder(r=77/2, h=5.6, center=true, $fn=72);
      translate([0, 0, 5.6 + (14.36-5.6)/2]) cylinder(r=27.75/2, h=(14.36 - 5.6), center=true);
    }
    cylinder(r=18.19/2, h=50, center=true);
    for (a=[0:3]) {
      rotate([0, 0, a*90]) translate([(60.66 - 7) / 2, 0, 0]) cylinder(r=3.5, h=50, center=true, $fn=36);
    }
    
  }
}


module assembled() {
  // drum assemblies
  translate([-case_width/2 + case_clearance + t + drum_width()/2, 0, 0]) for (i=[0:8]) {
    translate([i*(3*t + numeral_w), 0, 0]) {
        drum_assembly();
    }
  }

  // stacks of connecting gears
  translate([-case_width/2 + case_clearance + t + drum_width()/2, 0, 0]) for (i=[1:8]) {
    translate([i*(3*t + numeral_w), 0, 0]) {
      rotate([-45, 0, 0]) 
        translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
          for (x=[0, t, 2*t]) {
            translate([-(numeral_w/2 + t/2 + x), 0, 0]) rotate([360/connecting_gear_num_teeth/2, 0, 0]) rotate([0, 90, 0]) connecting_gear();
          }
    }
  }

  // singular drive gear
  translate([-case_width/2 + case_clearance + t + drum_width()/2 + 8 * (drum_width()+t), 0, 0]) {
    rotate([-45, 0, 0]) 
      translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
        translate([(numeral_w/2 + t/2), 0, 0]) rotate([360/connecting_gear_num_teeth/2, 0, 0]) rotate([0, 90, 0]) drive_gear();
  }

  // support struts for the main drums
  translate([-case_width/2 + case_clearance + t/2, 0, 0]) for (i=[0:9]) {
    translate([i * (drum_width() + t), 0, 0]) rotate([90, 0, 90]) drum_support();
  }

  // support struts for the connecting gears
  translate([-case_width/2 + case_clearance + t + drum_width() - t - t/2, 0, 0]) rotate([-45, 0, 0]) for (x2=[0, 4]) for (x=[0:7]) {
    translate([x2 * t + x * (drum_width() + t), center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
      rotate([45, 0, 0]) rotate([90, 0, -90]) connecting_gear_support();
  }

  // mock motor + bracket
  translate([-case_width/2 + case_clearance + t + drum_width()/2 + 8.5 * (drum_width()+t), 0, 0]) rotate([-45, 0, 0]) 
    translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) {
      rotate([-45, 0, 0]) rotate([0, -90, 0]) mock_motor();
      translate([10 - t/2, 0, 0]) rotate([135, 0, 0]) rotate([0, 90, 0]) motor_face_bracket();
      for (i=[1:ceil(22/t)]) {
        translate([10 - t/2 + i*t, 0, 0]) rotate([135, 0, 0]) rotate([0, 90, 0]) motor_basket();
      }
    }

  // drum shaft
  translate([-case_width/2 + case_clearance + t / 2 + 4.5*(drum_width()+t), 0, 0]) rotate([0, 90, 0]) 
    cylinder(r=shaft_diameter/2, h=9*(drum_width()+t) + nut_t * 3, center=true, $fn=36);
  // connecting gear shaft
  translate([-case_width/2 + case_clearance + drum_width() + t + 3.5*(drum_width()+t), 0, 0]) rotate([-45, 0, 0]) translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
    rotate([0, 90, 0]) cylinder(r=shaft_diameter/2, h=7*(drum_width()+t) + shaft_diameter*6, center=true, $fn=36);

  for (i=[-1,1]) {
    translate([i * (-case_width/2 - t/2), 0, 0]) rotate([0, -i*90, 0]) flange();
  }
  

  // case
  translate([0, 0, -case_height/2 + t/2]) bottom();
  translate([0, 0, case_height/2 - t/2]) top();
  for (x=[-1,1]) {
    translate([x * (case_width/2 - t/2), 0, 0]) rotate([0, 90, 0]) side();
  }

  translate([0, -case_depth/2 + t/2, 0]) rotate([90, 0, 0]) front();
  translate([0, case_depth/2 - t/2, 0]) rotate([90, 0, 0]) back();

}

assembled();

module panelized() {
  projection(cut=true) {
    // bottom();
    // drum_support();
    // connecting_gear_support();
    // connecting_gear();
    front();
  }
}

// panelized();
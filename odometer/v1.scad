// TODOs
// - create drum stands
// - add tab-ins for numeral plates
// - create connecting gear stands
// - create a motor mount bracket
// - mock up the arduino
// - create arduino mounting holes/bracket
// - design the external case
// - decide if the pipe mounting plan is the right way to go, figure out the mounting hole situation for that


use <../publicDomainGearV1.1.scad>

render_gears = true;

// Parameters

// material thickness
t = 0.177 * 25.4;

// 1/4" rod for shafts
shaft_diameter = .250 * 25.4;

// slot-tab size
tab_size = 10;

// panels used to display numerals
numeral_h = 2.5 * 25.4;
numeral_w = 1.75 * 25.4;

// gear parameters
mm_per_tooth = 19; // arbitrary

// number of teeth on the numeral drums
major_gear_num_teeth = 40;
// ... and some consequences of this choice
function partial_gear_num_hidden_teeth() = major_gear_num_teeth - major_gear_num_teeth / 10;
function minor_gear_num_teeth() = major_gear_num_teeth/4;
function major_gear_outer_diameter() = 2 * outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth = mm_per_tooth);

// number of teeth on the connecting gears (as well as on the drive gear)
connecting_gear_num_teeth = 8;

gear_minimum_width = 15;

// case 
case_clearance = 15;


motor_body_length = 22 + 30 + 12.5;
motor_nonconnecting_shaft_length = 10;
case_width = 9 * drum_width() + 10 * t + 2 * case_clearance + motor_body_length + motor_nonconnecting_shaft_length;
case_height = major_gear_outer_diameter() + 2*case_clearance;
case_depth = major_gear_outer_diameter() + 2*case_clearance;

// some functionalized parameters
function numeral_radius() = 10 * (numeral_h + 2) / 3.141592 / 2;
function drum_width() = numeral_w + 2*t;


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
    my_gear(number_of_teeth = 40);
    drum_gear_cutouts();
    for (a=[0:9]) {
      rotate([0, 0, a*36+18]) translate([numeral_radius(), 0, 0]) cube(size=[t, tab_size, t+0.1], center=true);
    }
  }
}

module drum_partial_gear() {
  render() difference() {
    union() {
      my_gear(number_of_teeth = major_gear_num_teeth, teeth_to_hide=partial_gear_num_hidden_teeth());
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
  difference() {
    union() {
      cylinder(r=10, h=t, center=true, $fn=36);
      assign(h=outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth=mm_per_tooth)+case_clearance) {
        translate([0, -h/2, 0]) cube(size=[20, h, t], center=true);
        translate([0, -h + 10, 0]) cube(size=[h, 20, t], center=true);
      }
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true);
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
  cube(size=[case_width, case_depth, t], center=true);
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


  translate([-case_width/2 + case_clearance + t/2, 0, 0]) for (i=[0:9]) {
    translate([i * (drum_width() + t), 0, 0]) rotate([90, 0, 90]) color([128/255, 0/255, 0/255]) drum_support();
  }


  translate([0, 0, -case_height/2]) bottom();

  // mock motor!
  translate([-case_width/2 + case_clearance + t + drum_width()/2 + 8.5 * (drum_width()+t), 0, 0]) rotate([-45, 0, 0]) 
    translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
      rotate([-45, 0, 0]) rotate([0, -90, 0]) mock_motor();

  // // drum shaft
  // rotate([0, 90, 0]) cylinder(r=shaft_diameter/2, h=9*(drum_width()+t) + shaft_diameter*4, center=true, $fn=36);
  // // connecting gear shaft
  // rotate([-45, 0, 0]) translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
  //   rotate([0, 90, 0]) cylinder(r=shaft_diameter/2, h=7*(drum_width()+t) + shaft_diameter*6, center=true, $fn=36);

}

assembled();
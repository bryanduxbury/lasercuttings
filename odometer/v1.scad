// TODOs
// - create drum stands
// - add tab-ins for numeral plates
// - create connecting gear stands
// - create the d-cutout drive gear
// - mock up the motor
// - create a motor mount bracket
// - mock up the arduino
// - create arduino mounting holes/bracket
// - design the external case
// - create cutouts in drum sides
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

// number of teeth on the connecting gears (as well as on the drive gear)
connecting_gear_num_teeth = 10;

// case 
case_width = 24*25.4;
case_height = 10 * 25.4 + 30;
case_depth = 10 * 25.4;

// some functionalized parameters
function numeral_radius() = 10 * (numeral_h + 2) / 3.141592 / 2;
function drum_width() = numeral_w + 2*t;

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

module my_gear(number_of_teeth, teeth_to_hide=0) {
  render() gear(mm_per_tooth = mm_per_tooth, 
    number_of_teeth = number_of_teeth, 
    thickness = t, 
    hole_diameter=shaft_diameter, 
    teeth_to_hide=teeth_to_hide);
}

module connecting_gear() {
  my_gear(connecting_gear_num_teeth);
}

module drum_complete_gear() {
  difference() {
    my_gear(number_of_teeth = 40);
    // for (a=[0:9]) {
    //   rotate([0, 0, a*360/10]) {
    //     translate([0, outer_radius(mm_per_tooth = 19, number_of_teeth = 40)/2, 0]) cube(size=[5, outer_radius(mm_per_tooth = 19, number_of_teeth = 40)/2 - 10, 3.1], center=true);
    //   }
    // }
    
  }
}

module drum_partial_gear() {
  difference() {
    union() {
      my_gear(number_of_teeth = major_gear_num_teeth, teeth_to_hide=partial_gear_num_hidden_teeth());
      cylinder(r=root_radius(major_gear_num_teeth,0), h=t, center=true, $fn=128);
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true, $fn=36);
  }
}

module drum_support() {
  difference() {
    union() {
      cylinder(r=10, h=t, center=true, $fn=36);
      assign(h=outer_radius(number_of_teeth = major_gear_num_teeth, mm_per_tooth=mm_per_tooth)+10) {
        translate([0, -h/2, 0]) cube(size=[20, h, t], center=true);
        translate([0, -h, 0]) cube(size=[h, 20, t], center=true);
      }
    }
    cylinder(r=shaft_diameter/2, h=t+0.1, center=true);
  }
}

module numeral_plate() {
  union() {
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
  !color([128/255, 128/255, 128/255]) union() {
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

for (i=[-4:4]) {
  translate([-i*(3*t + numeral_w), 0, 0]) {
    // render() 
      drum_assembly();
    rotate([-30, 0, 0]) 
      translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) 
        for (x=[0, t, 2*t]) {
          translate([-(numeral_w/2 + t/2 + x), 0, 0]) rotate([360/10/6, 0, 0]) rotate([0, 90, 0]) connecting_gear();
        }
  }
}

for (i=[-5:4]) {
  translate([i * (drum_width() + t) + drum_width()/2 + t/2, 0, 0]) rotate([90, 0, 90]) color([128/255, 0/255, 0/255]) drum_support();
}
  


translate([0, 0, -case_height/2]) bottom();

translate([5 * drum_width(), 0, 0]) rotate([-30, 0, 0]) translate([0, center_distance(major_gear_num_teeth, connecting_gear_num_teeth), 0]) rotate([0, -90, 0]) mock_motor();
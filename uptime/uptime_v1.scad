use <publicDomainGearV1.1.scad>

// extra gear related functions

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



// threaded rods and bolts to be used for gears
gear_axle_diameter = 3;

numeral_width = 10;
numeral_height = 10;

// primary material: gears, supports
t1 = 3; // 1/8" acrylic

// secondary material: enclosed base
t2 = 5.2; // cabinet board

// tertiary material: clear top enclosure
t3 = 3;

// laser beam width
l = 0.005 * 25.4;

// gear parameters
mm_per_tooth = 3;

numeral_drum_num_teeth = 120;


module numeral_plate() {
  
}

module numeral_drum_complete_gear() {
  render() 
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth=numeral_drum_num_teeth,thickness=t1,hole_diameter=gear_axle_diameter, pressure_angle=14.5);
}

module numeral_drum_partial_gear() {
  difference() {
    union() {
      gear(mm_per_tooth=mm_per_tooth, number_of_teeth=numeral_drum_num_teeth,thickness=t1,hole_diameter=gear_axle_diameter,teeth_to_hide=numeral_drum_num_teeth/10 * 9, pressure_angle=14.5);
      cylinder(r=root_radius(number_of_teeth=numeral_drum_num_teeth), h=t1, center=true, $fn=128);
    }
    cylinder(r=gear_axle_diameter/2, h=t1*2, center=true, $fn=36);
  }
}

module numeral_drum_center_support() {
  
}

module numeral_drum_assembly(num_positions) {
  translate([numeral_width/2 + t1/2, 0, 0]) rotate([0, 90, 0]) numeral_drum_complete_gear();
  translate([-(numeral_width/2 + t1/2), 0, 0]) rotate([0, 90, 0]) numeral_drum_partial_gear();
}

module numeral_drum_stand() {
  
}

module drive_gear() {
  
}

module gear3() {
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth=18, thickness=t1);
}

module gear5() {
  
}

module gear4() {
  
}

module gear1() {
  
}

module gear10() {
}

module assembled() {
  numeral_drum_assembly(num_positions=10);
  translate([numeral_width/-2 - t1/2, center_distance(240, 10), 0]) rotate([18, 0, 0]) rotate([0, 90, 0]) 
    render() gear(mm_per_tooth=mm_per_tooth, number_of_teeth=10, thickness=t1, pressure_angle=14.5);
  translate([numeral_width/-2 - t1/2, center_distance(240, 50), 0]) rotate([0, 90, 0]) 
    render() gear(mm_per_tooth=mm_per_tooth, number_of_teeth=30, thickness=t1, pressure_angle=14.5);
  translate([(numeral_width + 2 * t1)/-2 - 3/2*t1, center_distance(240, 50), 0]) rotate([360/50/2, 0, 0]) rotate([0, 90, 0]) 
    gear(mm_per_tooth=mm_per_tooth, number_of_teeth=50, thickness=t1, pressure_angle=14.5);

  translate([-numeral_width - t1*3, 0, 0]) numeral_drum_assembly(num_positions=10);
  
  translate([3*(numeral_width + 2 * t1)/-2 - 5/2*t1, center_distance(240, 10), 0]) rotate([18, 0, 0]) rotate([0, 90, 0]) 
    render() gear(mm_per_tooth=mm_per_tooth, number_of_teeth=10, thickness=t1, pressure_angle=14.5);
  translate([3*(numeral_width + 2 * t1)/-2 - 5/2*t1, center_distance(240, 50), 0]) rotate([0, 90, 0]) 
    render() gear(mm_per_tooth=mm_per_tooth, number_of_teeth=30, thickness=t1, pressure_angle=14.5);
  translate([-numeral_width - t1*3 - numeral_width/2 - t1/2, center_distance(240, 50), 0]) rotate([360/50/2, 0, 0]) rotate([0, 90, 0]) 
    gear(mm_per_tooth=mm_per_tooth, number_of_teeth=50, thickness=t1, pressure_angle=14.5);
  
  translate([2 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  
  translate([3 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  
  translate([4 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  
  translate([5 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  
  translate([6 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  translate([7 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
  translate([8 * (-numeral_width - t1*3), 0, 0]) numeral_drum_assembly(num_positions=10);
}

assembled();
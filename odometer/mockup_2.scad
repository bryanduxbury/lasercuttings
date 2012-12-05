use <../publicDomainGearV1.1.scad>

render_gears = true;

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
  mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
  number_of_teeth = 11,   //total number of teeth around the entire perimeter
  clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
) = p(mm_per_tooth, number_of_teeth)-(c(mm_per_tooth, number_of_teeth, clearance)-p(mm_per_tooth, number_of_teeth))-clearance;

module quick_gear(
  mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
  number_of_teeth = 11,   //total number of teeth around the entire perimeter
  thickness       = 6,    //thickness of gear in mm
  hole_diameter   = 3,    //diameter of the hole in the center, in mm
  twist           = 0,    //teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
  teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
  pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
  clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
  backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle  
) {
  if (render_gears) {
    echo("would render the real gear here");
    gear(
      mm_per_tooth,
      number_of_teeth,
      thickness,
      hole_diameter,
      twist,
      teeth_to_hide,
      pressure_angle,
      clearance,
      backlash
    );
  } else {
    echo("would render the fake quasi-gear");
    %render() difference() {
      cylinder(r=outer_radius(mm_per_tooth,number_of_teeth, clearance), h=thickness, center=true, $fn=72);
      cylinder(r=pitch_radius(mm_per_tooth,number_of_teeth, clearance), h=thickness+0.1, center=true, $fn=72);
    }
    difference() {
      cylinder(r=pitch_radius(mm_per_tooth,number_of_teeth, clearance), h=thickness+0.1, center=true, $fn=72);
    }
  }
}


module connecting_gear() {
  render() quick_gear(mm_per_tooth = 19, number_of_teeth = 10, thickness = 3, hole_diameter=6);
}

module drum_complete_gear() {
  difference() {
    quick_gear(mm_per_tooth = 19, number_of_teeth = 40, thickness = 3, hole_diameter=6);
    for (a=[0:9]) {
      rotate([0, 0, a*360/10]) {
        translate([0, outer_radius(mm_per_tooth = 19, number_of_teeth = 40)/2, 0]) cube(size=[5, outer_radius(mm_per_tooth = 19, number_of_teeth = 40)/2 - 10, 3.1], center=true);
      }
    }
    
  }
}

module drum_partial_gear() {
  difference() {
    union() {
      quick_gear(mm_per_tooth = 19, number_of_teeth = 40, thickness = 3, hole_diameter=6, teeth_to_hide=36);
      cylinder(r=root_radius(19, 40,0), h=3, center=true, $fn=128);
    }
    cylinder(r=3, h=10, center=true, $fn=128);
  }
}

module drum_support() {
  union() {
    cube(size=[30, 10 * (2.5 * 25.4 + 2) / 3.141592 / 2, 3], center=true);
    translate([0, - 10 * (2.5 * 25.4 + 2) / 3.141592 / 2 /2, 0]) cube(size=[10 * (2.5 * 25.4 + 2) / 3.141592 / 2, 30, 3], center=true);
  }
}

module drum_assembly() {
  translate([25+1.5, 0, 0]) rotate([0, 90, 0]) drum_complete_gear();
  translate([-25 + -1.5, 0, 0]) rotate([0, 90, 0]) drum_partial_gear();

  numeral_h = 2.5 * 25.4;
  numeral_w = 2 * 25.4;
  for (n=[0:9]) {
    rotate([360/10*n, 0, 0]) translate([0, 10 * (numeral_h + 2) / 3.141592 / 2, 0]) cube(size=[numeral_w, 3, numeral_h], center=true);
  }
}

for (i=[0:8]) {
  translate([-i*59, 0, 0]) {
    render() drum_assembly();
    rotate([-30, 0, 0]) 
      translate([0, pitch_radius(mm_per_tooth = 19, number_of_teeth = 40) + pitch_radius(mm_per_tooth = 19, number_of_teeth = 10), 0]) 
        for (x=[-26.5,26.5,26.5+3]) {
          translate([x, 0, 0]) rotate([360/10/6, 0, 0]) rotate([0, 90, 0]) connecting_gear();
        }
  }
}

drum_assembly();

for (i=[0:9]) {
  translate([29.5 + -i * 59, 0, - 10 * (2.5 * 25.4 + 2) / 3.141592 / 2 /2 - 10]) rotate([90, 0, 90]) drum_support();
}

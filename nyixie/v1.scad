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

module top() {
  difference() {
    cube(size=[face_width, overall_depth, t], center=true);
    translate([-tube_spacing * (num_tubes/2 - 0.5), 0, 0]) {
      for (x = [0:(num_tubes-1)]) {
        translate([x * tube_spacing, 0, 0]) cylinder(r=tube_d/2 + 1, h=t*2, center=true);
      }
    }
  }
}

module bottom() {
  difference() {
    cube(size=[face_width, overall_depth, t], center=true);
    // translate([-tube_spacing * (num_tubes/2 - 0.5), 0, 0]) {
    //   for (x = [0:(num_tubes-1)]) {
    //     translate([x * tube_spacing, 0, 0]) cylinder(r=tube_d/2 + 1, h=t*2, center=true);
    //   }
    // }
  }
}

module back() {
  color("red")
  cube(size=[face_width, face_height, t], center=true);
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
  render()
  difference() {
    cube(size=[face_width - t*2, face_height - t*2, t], center=true);
  }
}

module face_assembly() {
  for (x=[-1,1]) {
    translate([x * (face_width/2 - 2*t - 10 - 5), 0, 0]) _handle();
  }

  translate([face_width/2 - 2*t - 10 - 10 - 25 - 16.24/2, 0, -t/2]) _power_switch();
  
  
  translate([0, 0, t/2]) _meter();
  
  translate([121/2 + 25 + 25, 0, -t/2]) _selector_switch();
  
  translate([-(121/2 + 25 + 25), 0, -t/2]) {
    translate([0, 25, 0]) _selector_switch();
    translate([0, -25, 0]) _selector_switch();
  }

  face();
}

module side() {
  color("blue")
  cube(size=[overall_depth, face_height, t], center=true);
}

module assembled() {
  translate([0, 0, face_height/2 - t/2]) top();
  translate([0, 0, -face_height/2 + t/2]) bottom();

  translate([0, overall_depth/-2 + 1.5*t, 0]) rotate([90, 0, 0]) face_assembly();
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
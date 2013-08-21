use <raspberry pi.scad>

tube_d = 31;
tube_h = 60;

tube_spacing = 40;
num_tubes = 12;

face_height = 100;
face_width = tube_spacing * num_tubes + 20;
overall_depth = 150;

handle_d = 6;
handle_h = 30;
handle_w = 80;
handle_corner_r = 15;

t = 5.2;

module _tube() {
  color([128/255, 128/255, 128/255, 0.5])
  translate([0, 0, tube_h/2]) 
  render()
  union() {
    cylinder(r=tube_d/2, h=tube_h, center=true, $fn=72);
    translate([0, 0, tube_h/2]) sphere(r=tube_d/2, $fn=128);
  }
}

module _pcb(args) {
  color("darkgreen")
  difference() {
    cube(size=[150, 70, 1.5], center=true);
    for (x=[-1:1], y=[-1,1]) {
      translate([x * 70, y * 30, 0]) cylinder(r=1.5, h=10, center=true, $fn=36); 
    }
  }
}

module _pcba() {
  _pcb();
  for (x=[-1.5, -0.5, 0.5, 1.5]) {
    translate([x * tube_spacing, 0, 0.75]) _tube();
  }
}

module _power_switch() {
  color("silver")
  union() {
    translate([0, 0, -14.65/2]) cube(size=[16.24, 24, 14.65], center=true);
    translate([0, 0, 10]) cylinder(r=12/2, h=20, center=true);
  }
}

module _meter() {
  color("black")
  union() {
    translate([0, 0, 11.2/2]) cube(size=[121, 101, 11.2], center=true);
    translate([0, -101/2 + 67.26 - 64.25/2, (42-11.2)/-2]) cylinder(r=64.25/2, h=(42-11.2), center=true);
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (103.73/2 - 3.91/2), y * (83.69/2 - 3.91/2), 0]) cylinder(r=3.91/2, h=20, center=true);
    }
  }
}

module _selector_switch() {
  color("silver")
  union() {
    translate([0, 0, -16.6/2]) cylinder(r=32.64/2, h=16.6, center=true);
    translate([0, 0, 25/2]) cylinder(r=9.5/2, h=25, center=true);
  }
  
  translate([0, 0, 20]) {
    color("grey")
    union() {
      cylinder(r=20/2, h=19.1, center=true);
      cube(size=[12, 31.5, 19.1], center=true);
    }
  }
}

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

power_switch_width = t*5;
power_switch_shaft_len = 10;
power_switch_shaft_t = 3;

module switch_guard() {
  difference() {
    cylinder(r=10 + power_switch_shaft_len, h=t, center=true, $fn=72);
    cylinder(r=1.5, h=t*2, center=true, $fn=36);
    for (x=[-1,1]) {
      translate([x * (10 + power_switch_shaft_len), -5-t*1.5, 0]) 
        cube(size=[(10 + power_switch_shaft_len) - power_switch_width/2, 2*(10 + power_switch_shaft_len), t*2], center=true);
    }
  }
}

module switch_slice() {
  union() {
    difference() {
      cylinder(r=10, h=t, center=true);
      cylinder(r=1.5, h=t*2, center=true, $fn=36);
    }

    translate([10 + power_switch_shaft_len/2 - 0.5, 0, 0]) cube(size=[power_switch_shaft_len, power_switch_shaft_t, t], center=true);
  }
}

module switch_assembly() {
  for (x=[-1:1]) {
    translate([t*x, 0, 0]) rotate([0, -90, 0]) switch_slice();
  }
  for (x=[-1,1]) {
    translate([t*2*x, 0, 0]) rotate([90, 0, 90]) switch_guard();
  }
}

vu_meter_w = 80;
vu_meter_h = face_height - t*2 - 10 * 2;

module vu_meter_frame() {
  cube(size=[vu_meter_w, vu_meter_h, t], center=true);
}

module vu_meter_window() {
  
}

module vu_meter_assembly() {
  vu_meter_frame();
}

module channel_selector_assembly() {
  // dial
}

module face() {
  color("red")
  render()
  difference() {
    cube(size=[face_width - t*2, face_height - t*2, t], center=true);
    // translate([face_width/2 - t*3 - power_switch_width/2, 0, 0]) cube(size=[power_switch_width, power_switch_width, t*2], center=true);
  }
}

module face_assembly() {
  translate([(face_width/2 - t * 3 - handle_d - 10 - power_switch_width/2), 0, -5]) 
    switch_assembly();

  for (x=[-1,1]) {
    translate([x * (face_width/2 - t*3 - handle_d/2), 0, 0]) handle();
  }
  
  translate([(face_width/2 - t * 3 - handle_d - 10 - power_switch_width - 10 - vu_meter_w / 2), 0, t]) 
    vu_meter_assembly();

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

  translate([-tube_spacing * (num_tubes/2 - 0.5), 0, face_height/2]) {
    for (x = [0:(num_tubes-1)]) {
      translate([x * tube_spacing, 0, 0]) _tube();
    }
  }
}

assembled();
// !_meter();
// !_power_switch();
// !_pcb();
// !_pcba();
!_selector_switch();
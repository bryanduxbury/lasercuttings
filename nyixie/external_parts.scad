use <raspberry pi.scad>

tube_spacing = 40;
tube_d = 31;
tube_h = 71;

handle_d = 6;
handle_h = 30;
handle_w = 80;
handle_corner_r = 15;

t = 5.2;

module _tube() {
  color([128/255, 128/255, 128/255, 0.5])
  render()
  union() {
    translate([0, 0, (tube_h - tube_d/2)/2]) cylinder(r=tube_d/2, h=tube_h - tube_d/2, center=true, $fn=72);
    translate([0, 0, (tube_h - tube_d/2)]) sphere(r=tube_d/2, $fn=64);
    translate([0, 0, -7/2]) cylinder(r=18.5/2, h=7, center=true);
    translate([0, 0, -17/2]) cylinder(r=7.5/2, h=17, center=true);
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
  translate([0, 0, -0.75]) _pcb();
  for (x=[-1.5, -0.5, 0.5, 1.5]) {
    translate([x * tube_spacing, 0, 3.5]) _tube();
  }
  translate([0, 20, -1.5 - 5]) color("black") cube(size=[1.4*25.4, 12, 10], center=true);
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

module _standoff(d,h) {
  difference() {
    cylinder(r=d/2, h=h, center=true, $fn=36);
    cylinder(r=d/2-1, h=h+2, center=true, $fn=36);
  }
}

module _handle() {
  color("silver")
  union() {
    translate([0, 0, 27/2]) cube(size=[10, 86.2, 27], center=true);
    translate([0, 0, -5]) 
    for (y=[-86.2/2 + 6.5/2, 86.2/2 - 6.5/2, 86.2/2 - 35.4 + 6.5/2]) {
      translate([0, y, 0]) 
      cylinder(r=4/2, h=10, center=true);
    }
  }
}

module _pot_250() {
  color("silver")
  union() {
    translate([0, 0, 10/2]) cylinder(r=9.5/2, h=10, center=true);
    translate([0, 0, -15.2/2]) cylinder(r=28/2, h=15.2, center=true);
  }

  translate([0, 0, 10]) {
    color("grey")
    union() {
      translate([0, 0, 19.2/2]) cylinder(r=19.2/2, h=19, center=true);
      translate([0, 0, 2]) cylinder(r=24/2, h=4, center=true);
    }
    
  }
}

module _pot20() {
  color("silver")
  union() {
    translate([0, 0, 10/2]) cylinder(r=9.5/2, h=10, center=true);
    translate([0, 0, -28/2]) cylinder(r=32/2, h=28, center=true);
  }

  translate([0, 0, 10]) {
    color("grey")
    union() {
      translate([0, 0, 19.2/2]) cylinder(r=19.2/2, h=19, center=true);
      translate([0, 0, 2]) cylinder(r=24/2, h=4, center=true);
    }
    
  }
}

module _ac_plug() {
  color("black")
  union() {
    translate([0, 0, 8.13/2]) 
      cylinder(r=28.3/2, h=8.13, center=true);
    for (y=[-1,1]) {
      translate([y * (25.2/2 - 12/2), 0, -6.5/2]) cylinder(r=12/2, h=6.5, center=true);

      // translate([0, y * (19.5/2 - 2.8/2), -20/2]) cylinder(r=2.8/2, h=20, center=true, $fn=36);
    }
    
  }
  color("silver")
  for (y=[-1,1]) {
    translate([0, y * (19.5/2 - 2.8/2), -20/2]) cylinder(r=2.8/2, h=20, center=true, $fn=36);
  }
}

module _power_supply() {
  color("white")
  cube(size=[115, 52, 37], center=true);
}

module _lamp() {
  color("orange")
    translate([0, 0, (22.75 - 11.23)/2]) cylinder(r=16/2, h=22.75 - 11.23, center=true);

  color("silver")
    translate([0, 0, 1]) cylinder(r=19/2, h=2, center=true);

  color("silver")
    translate([0, 0, -11.25/2]) cylinder(r=17/2, h=11.25, center=true);
}

module _voltage_plate() {
  color("black")
  difference() {
    cube(size=[31.87, 11.17, 1], center=true);
    translate([0, -11.17/2 + 1.5 + 3.3/2, 0]) {
      for (x=[-1,1]) {
        translate([x * (31.87 / 2 - 1.5 - 3.3/2 ), 0, 0]) cylinder(r=3.3/2, h=2, center=true, $fn=36);
      }
    }
  }
}

module _probe_plug() {
  color("silver") {
    difference() {
      union() {
        translate([0, 0, 1]) cylinder(r=41/2, h=2, center=true);
        translate([0, 0, (21 - 13.4 - 2)/2 + 2]) cylinder(r=25/2, h=(21 - 13.4 - 2), center=true);
        translate([0, 0, -13.4/2]) cylinder(r=25/2, h=13.4, center=true);
      }

      for (a=[0:2]) {
        rotate([0, 0, 90 + a*120]) translate([41 / 2 - 2.5, 0, 1]) cylinder(r=3/2, h=4, center=true, $fn=12);
      }
    }
  }
}
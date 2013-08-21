use <raspberry pi.scad>

tube_spacing = 40;
tube_d = 31;
tube_h = 60;

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
  translate([0, 0, -0.75]) _pcb();
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
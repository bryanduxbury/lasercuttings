t = 3.2;
corner_r = 1.5;


function polar(r, theta) = [cos(theta) * r, sin(theta) * r];

// shorthand for acrylic
module a() {
  color("white", 0.4)
  linear_extrude(height=t, center=true) children(0);
}

module dogbone() {
  square(size=[t, 10], center=true);
  for (x=[-1,1], y=[-1,1]) {
    a = (1.7/2/sqrt(2));
    translate([x * (t/2 - a), y * (10/2 - a), 0]) circle(r=1.7/2, $fn=12);
  }
}

module _lcd() {
  color("grey")
  translate([0, 0, -9.9/2]) 
    cube(size=[97, 39.5, 9.9], center=true);

  color("blue")
    cube(size=[76, 26, 1], center=true);

  color("green")
  translate([0, 0, -9.9-1.6/2])
  difference() {
    cube(size=[98, 60, 1.6], center=true);
    for (x = [-1,1], y = [-1, 1]) {
      translate([93/2 * x, 55 / 2 * y, 0]) 
        cylinder(r=1.5, h=2, center=true, $fn=36);
    }
  }

  color("grey")
  translate([0, 0, -14 + 2]) 
    cube(size=[97, 39.5, 4], center=true);
}

module face2d() {
  difference() {
    hull() {
      for (x=[-1,1], y=[-1,1]) {
        translate([x * (100 + t * 4 - corner_r*2) / 2, y * (75 - 3) / 2, 0]) 
          circle(r=corner_r, $fn=16);
      }
    }

    for (x = [-1,1], y = [-1, 1]) {
      translate([93/2 * x, 55 / 2 * y, 0]) 
        circle(r=1.55, center=true, $fn=36);

      translate([x * ((100 + t * 4) / 2 - t), y * 25, 0]) dogbone();
    }
  }
}

module side2d() {
  union() {
    polygon(points=[
      [0,0],
      [0, 75],
      polar(50, 15),
      [0,0]
    ]);

    for (y=[-1,1]) {
      translate([0, 75/2 + y * 25, 0]) square(size=[t*2, 10], center=true);

      rotate([0, 0, -75]) 
        translate([0, 50/2 + y * 15, 0]) 
          square(size=[t*2, 10], center=true);
    }
  }
}

module base2d() {
  difference() {
    hull() {
      for (x=[-1,1], y=[-1,1]) {
        translate([x * (100 + t * 4 - 3) / 2, y * (50 - 3) / 2, 0]) 
          circle(r=1.5, $fn=16);
      }
    }

    for (x = [-1,1], y = [-1, 1]) {
      translate([x * ((100 + t * 4) / 2 - t), y * 15, 0]) dogbone();
    }
  }
}

translate([0, 0, 75/2 * cos(15)])
rotate([75, 0, 0]) {
  _lcd();

  translate([0, 0, t/2]) a() face2d();

  for (x=[-1,1]) {
    translate([x * ((100 + t * 4) / 2 - t), -75/2, 0]) 
      rotate([0, 90, 0]) a() side2d();
  }
}

translate([0, 50/2 - 75/2 * sin(15), -t/2])
  a() !base2d();


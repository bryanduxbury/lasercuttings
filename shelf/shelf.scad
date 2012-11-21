l=0.005 * 25.4;
// t = 5;
t = 0.234 * 25.4;
w = 16 * 25.4;
d = 5.5 * 25.4;
r1 = 1 * 25.4;
r2 = d - r1 * 2 - t;

stud_spacing = 14 * 25.4;
screw_r = 1/4 * 25.4 / 2;

module ext() {
  translate([0, 0, -t/2]) linear_extrude(height=t) child(0);
}


module quarter_circle(r) {
  intersection() {
    circle(r=r1, $fn=72);
    translate([r1/2, -r1/2, 0]) square(size=[r1, r1], center=true);
  }
}

module bracket() {
  render() difference() {
    union() {
      translate([-r1/2, r1/2, 0]) difference() {
        square(size=[d - r1, d - r1], center=true);
        translate([(d - r1)/2, -(d - r1)/2, 0]) circle(r=r2, $fn=72);
      }
      translate([-d/2 + t, -d/2 + r1, 0]) quarter_circle(r1);
      translate([d/2 - r1, d/2 - t,  0]) quarter_circle(r1);

      translate([-d/2 + t/2, -d/2 + r1/2, 0]) square(size=[t, r1], center=true);
      translate([d/2 - r1/2, d/2 - t/2,  0]) square(size=[r1, t], center=true);
    }
    for (a=[0,-90]) rotate([0, 0, a]) {
      for (y=[0:9]) {
        translate([-d/2, -d/2 + (2 * y) * d/10, 0]) square(size=[t*2-l, d/10 - l], center=true);
      }
    }
    
    translate([0, d/2 - t - r1/2, 0]) square(size=[t-l, r1/2-l], center=true);
  }
}

module back() {
  render() difference() {
    square(size=[w, d], center=true);

    for (x=[-1,1]) {
      for (y=[0:9]) {
        translate([x * (w/2), -d/2 - d/10 + 2 * y * d/10, 0]) square(size=[t*2-l, d/10 - l], center=true);
      }
      
      translate([x*(stud_spacing/2), d/2 - r1 * 1.5, 0]) circle(r=screw_r);
    }

    for (x=[0:9]) {
      translate([-w/2 - w/10 + 2 * x * w/10, d/2, 0]) square(size=[w/10 - l, t*2-l], center=true);
    }
  }
  
}

module top() {
  difference() {
    square(size=[w, d], center=true);
    for (x=[-1,1]) {
      for (y=[0:9]) {
        translate([x * (w/2), -d/2 - d/10 + 2 * y * d/10, 0]) square(size=[t*2-l, d/10 - l], center=true);
      }
    }
    for (x=[0:9]) {
      translate([-w/2 + 2 * x * w/10, d/2, 0]) square(size=[w/10 - l, t*2-l], center=true);
    }
  }
}

module support() {
  difference() {
    square(size=[w, r1], center=true);
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([x * w/2, y*r1/2, 0]) square(size=[t*2-l, r1/2 - l], center=true);
      }
      
    }
    
  }
}

module assembled() {
  for (x=[-1,1]) {
    translate([x * (w/2 - t/2), 0, 0]) rotate([90, 0, -90]) ext() bracket();
  }
  translate([0, d/2 - t/2, 0]) color([128/255, 128/255, 128/255]) rotate([90, 0, 0]) ext() back();

  translate([0, 0, d/2 - t/2]) color([192/255, 128/255, 128/255]) rotate([0, 0, 0]) ext() top();

  translate([0, 0, d/2 - t - r1/2]) color([128/255, 192/255, 128/255]) rotate([90, 0, 0]) ext() support();
}

module panelized() {
  back();
  translate([0, d+2, 0]) top();
  translate([0, -d/2 - 2 - r1 / 2, 0]) support();
  translate([w/2 + 2 + d/2, 0, 0]) bracket();
  translate([w/2 + 2 + d/2, d + 2, 0]) bracket();
}

// assembled();

panelized();
pipe_d = (1 + 3/8) * 25.4;

tee_w = 50;
tee_d = 86;
tee_metal_thickness = 2.6;

elbow_width = 95;
elbow_inner_d = 39;
eid = elbow_inner_d;
elbow_outer_d = 42.5;
elbow_flange_w = 55 - elbow_inner_d;
elbow_flange_t = 15;

lower_shelf_height = 150;
lower_shelf_width = 12 * 25;
desktop_height = 3.5 * 12 * 25;
desktop_width = 30 * 25;
top_shelf_height = 6.5 * 12 * 25;
top_shelf_width = 12 * 25;

width = 7 * 12 * 25;

module _tee() {
  color("red")
  render()
  assign(tee_rad = pipe_d/2 + tee_metal_thickness)
  assign(tee_leg_d = tee_d - tee_rad)
  // guessed, not measured!
  assign(tee_half_thickness = 3)
  difference() {
    union() {
      cylinder(r=tee_rad, h=tee_w, center=true);

      translate([0, -tee_leg_d / 2, 0]) 
        rotate([90, 0, 0]) 
          cylinder(r=tee_rad, h=tee_leg_d, center=true);
    }
    cylinder(r=tee_rad-tee_metal_thickness, h=tee_w+1, center=true);

    translate([0, -tee_leg_d / 2, 0]) 
      rotate([90, 0, 0]) 
        cylinder(r=tee_rad-tee_metal_thickness, h=tee_leg_d+1, center=true);

    rotate([0, 90, 0]) 
      cube(size=[tee_d*2, tee_d*2, tee_rad - 2 * tee_half_thickness], center=true);
  }
}

module _elbow() {
  color("red")
  render()
  assign(ew = elbow_width)
  assign(id = elbow_inner_d)
  assign(od = elbow_outer_d)
  for (tx=[[0,1],[-90,-1]]) {
    rotate([0, tx[0], 0]) 
    scale([tx[1], 1, 1]) 
    translate([0, 0, -ew/2+id/2]) 
      difference() {
        union() {
          cylinder(r=id/2, h=ew, center=true);
          translate([0, 0, -ew/2 + 1.5]) 
            cylinder(r=od/2, h=3, center=true); 
          translate([id/2, 0, 0]) 
            cube(size=[elbow_flange_w*2, elbow_flange_t, ew], center=true);
        }

        translate([id/2, 0, ew/2]) 
          rotate([0, 45, 0]) 
            cube(size=[(id*sqrt(2)+0.1)*2, id*sqrt(2)+0.1, id*sqrt(2)], center=true);
      }
  }
  
}

module pipe(l) {
  difference() {
    cylinder(r=pipe_d/2, h=l, center=true, $fn=36);
    cylinder(r=pipe_d/2 - 3, h=l+3, center=true, $fn=36);
  }
}

module pipe_frame() {
  // rear vertical tubes
  for (x=[-1,1]) {
    translate([x * (width / 2 - pipe_d / 2), -pipe_d/2, top_shelf_height/2]) 
      pipe(top_shelf_height);
  }

  // front legs + tees
  for (x=[-1,1]) {
    translate([x * (width / 2 - pipe_d / 2), -desktop_width + elbow_width + tee_w/2, desktop_height/2]) 
      pipe(desktop_height);
    translate([x * (width / 2 - pipe_d / 2), -desktop_width + elbow_width + tee_w/2, desktop_height - pipe_d/2]) 
      rotate([90, 0, 0]) _tee();
  }

  // desktop sides
  for (x=[-1,1]) {
    translate([x * (width / 2 - pipe_d / 2), -desktop_width/2, desktop_height - pipe_d/2]) {
      rotate([90, 0, 0]) pipe(desktop_width);
      translate([0, desktop_width/2 - pipe_d/2, 0]) _tee();
    }
  }

  // leg stabilizers
  assign(stabilizer_len = desktop_width - elbow_width - tee_w / 2 - pipe_d - pipe_d/2)
  for (x=[-1,1]) 
  translate([x * (width / 2 - pipe_d / 2), -stabilizer_len/2 - pipe_d, lower_shelf_height - pipe_d/2]) {
    rotate([90, 0, 0]) pipe(stabilizer_len);
    for (y=[-1,1]) {
      translate([0, y * (stabilizer_len/2 + pipe_d/2), 0]) 
      rotate([0, 0, -90 + y * 90]) _tee();
    }
  }

  // lower shelf support
  translate([0, -lower_shelf_width/2, lower_shelf_height - pipe_d/2]) {
    rotate([0, 90, 0]) pipe(width - 2 * pipe_d);
    for (x=[-1,1]) {
      translate([x * (width/2 - pipe_d/2), 0, 0]) 
      rotate([0, 90, x * -90]) _tee();
    }
    
  }
    

  // front desktop support
  translate([0, -desktop_width + pipe_d/2, desktop_height - pipe_d/2]) 
    rotate([0, 90, 0]) pipe(width);

  // front elbows
  for (tx=[[-1, 0],[1,180]]) {
    translate([tx[0] * (width/2 - pipe_d/2), -desktop_width + pipe_d/2, desktop_height - pipe_d/2]) 
    rotate([90, tx[1], 0]) _elbow();
  }

  // back desktop support
  translate([0, -pipe_d - tee_d - tee_w/2, desktop_height - pipe_d/2]) {
    rotate([0, 90, 0]) pipe(width-2*pipe_d);
    for (tx=[[-1,90],[1,-90]]) {
      translate([tx[0] * (width/2 - pipe_d/2), 0, 0]) 
      rotate([0, 90, tx[1]]) _tee();
    }
  }

  // rear top shelf support
  translate([0, -pipe_d/2, top_shelf_height - pipe_d/2]) {
    rotate([0, 90, 0]) pipe(width-2*pipe_d);
    for (tx=[[-1,0],[1,180]]) {
      translate([tx[0] * (width/2 - pipe_d/2), 0, 0]) 
      rotate([0, 0, tx[1]]) 
      _elbow();
    }
  }

  // front top shelf support
  translate([0, -top_shelf_width, top_shelf_height - pipe_d/2]) {
    rotate([0, 90, 0]) pipe(width-2*pipe_d);
    for (tx=[[-1,0],[1,180]]) {
      translate([tx[0] * (width/2 - pipe_d/2), 0, 0]) 
      rotate([0, 0, tx[1]]) 
      _elbow();
    }
  }

  // top shelf pillars
  assign(pillar_height = top_shelf_height - desktop_height)
  for (x = [-1,1]) 
  translate([x * (width / 2 - pipe_d / 2), -top_shelf_width, desktop_height + pillar_height/2]){
    translate([0, 0, -pipe_d/2]) pipe(pillar_height - pipe_d);
    translate([0, 0, -pillar_height/2 - pipe_d/2])
    rotate([-90, 0, 0])  _tee();
  }
}

pipe_frame();
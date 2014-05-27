// TODOs
// - add mounting holes for all the pipe clamps on the desktop
// - add mounting holes for all the pipe clamps on the top shelf
// - add mounting holes for all the pipe clamps on the bottom shelf
// - design adjustable feet
// - add center desktop support
// - add pipe clamps for pegboard connections

// pipe_d = (1 + 3/8) * 25.4; // nom.
pipe_d = 33.6; // measured

tee_w = 50;
tee_d = 86;
tee_metal_thickness = 2.6;
tee_end_to_bolt_hole = 39.5;
tee_pipe_len_adj = tee_d - pipe_d/2 - tee_end_to_bolt_hole;
tee_bolt_hole_w = 8.9;

elbow_width = 95;
elbow_inner_d = 39;
eid = elbow_inner_d;
elbow_outer_d = 42.5;
elbow_flange_w = 55 - elbow_inner_d;
elbow_flange_t = 15;

lower_shelf_height = 150;
lower_shelf_depth = 12 * 25;
desktop_height = 3 * 12 * 25;
desktop_depth = 30 * 25;
top_shelf_height = 6 * 12 * 25;
top_shelf_depth = 12 * 25;

corner_r = 10;

width = 7 * 12 * 25;

wood_t = 3/4 * 25.4;
top_overlap = 35;

pegboard_t = 12;

desktop_to_pipe_spacing = 5;
clamp_screw_d = 6;
clamp_screw_margin = 5;
clamp_w = pipe_d + 2 * (clamp_screw_margin * 2 + clamp_screw_d);
clamp_min_t = 5;

carriage_bolt_head_d = 17.5;
carriage_bolt_total_len = 54;
carriage_bolt_thread_len = 45.7;
carriage_bolt_thread_and_square_len = 49.4;
carriage_bolt_head_t = carriage_bolt_total_len - carriage_bolt_thread_and_square_len;
carriage_bolt_square_len = carriage_bolt_thread_and_square_len - carriage_bolt_thread_len;
carriage_bolt_nut_t = 7;
carriage_bolt_nut_d = 14.5;

module _tee() {
  echo("tee");
  #color("lime")
  render()
  assign(tee_rad = pipe_d/2 + tee_metal_thickness)
  assign(tee_leg_d = tee_d - tee_rad)
  assign(tee_half_thickness = 18.2)
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

    translate([0, -tee_leg_d + tee_end_to_bolt_hole + tee_bolt_hole_w/2, 0]) 
      cube(size=[2 * tee_rad+0.1, tee_bolt_hole_w, tee_bolt_hole_w], center=true);

    rotate([0, 90, 0]) 
      cube(size=[tee_d*2, tee_d*2, 2*tee_rad - 2 * tee_half_thickness], center=true);
  }
}

module _elbow() {
  #color("lime")
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

module _foot_scale(n=10) {
  translate([0, 0, 6 * 25.4]) 
  for (i=[0:n-1]) {
    translate([-1 * (i % 2) * 50 + 25, 0, 12 * 25.4 * i]) 
      cube(size=[50, 1, 12 * 25.4], center=true);
  }
}

module _pegboard(w, h) {
  color("sienna")
  difference() {
    cube(size=[w, h, pegboard_t], center=true);
    assign(hole_spacing = 75)
    assign(hole_d = 6)
    assign(num_holes_x = floor(w / hole_spacing))
    assign(num_holes_y = floor(h / hole_spacing))
    translate([(-num_holes_x / 2 + 0.5) * hole_spacing, (-num_holes_y / 2 + 0.5) * hole_spacing, 0]) 
    for (x=[0:num_holes_x-1], y=[0:num_holes_y-1]) {
      translate([x * hole_spacing, y * hole_spacing, 0]) 
        cylinder(r=hole_d/2, h=pegboard_t*2, center=true);
    }
  }
}

module _clamp_assembly() {
  clamp_top();
  clamp_bottom();
}

module clamp_top() {
  color("burlywood")
  assign(h=pipe_d/2 + desktop_to_pipe_spacing)
  difference() {
    translate([0, h/2, 0]) 
      cube(size=[clamp_w, h, wood_t], center=true);
    cylinder(r=pipe_d/2, h=wood_t*2, center=true, $fn=72);
    for (x=[-1,1]) {
      translate([x * (pipe_d / 2 + clamp_screw_margin + clamp_screw_d / 2), 0, 0]) 
        rotate([90, 0, 0]) 
          cylinder(r=clamp_screw_d/2, h=h*2, center=true, $fn=20);
    }
  }
}

module clamp_bottom() {
  color("tan")
  assign(h=pipe_d/2 + clamp_min_t)
  difference() {
    intersection() {
      translate([0, -h/2, 0]) 
        cube(size=[clamp_w, h, wood_t], center=true);
      translate([0, -clamp_min_t, 0]) {
        scale([1, (h-clamp_min_t) / clamp_w * 2, 1]) render() union() {
          cylinder(r=clamp_w/2, h=wood_t, center=true, $fn=72);
          translate([0, clamp_w/2/2, 0]) 
            cube(size=[clamp_w+0.1, clamp_w/2, wood_t], center=true);
        }
      }
    }

    cylinder(r=pipe_d/2, h=wood_t*2, center=true, $fn=72);
    for (x=[-1,1]) {
      translate([x * (pipe_d / 2 + clamp_screw_margin + clamp_screw_d / 2), 0, 0]) 
        rotate([90, 0, 0]) 
          cylinder(r=clamp_screw_d/2, h=h*2, center=true, $fn=20);
    }
  }
}

module pipe(n,l) {
  echo("Pipe for ", n);
  echo("Pipe of length ", l / 25.4);
  color("silver")
  difference() {
    cylinder(r=pipe_d/2, h=l, center=true, $fn=36);
    cylinder(r=pipe_d/2 - 3, h=l+3, center=true, $fn=36);
  }
}

module pipe_frame() {
  assign(adjusted_w = width - 2 * top_overlap)
  assign(adjusted_d = desktop_depth - 2 * top_overlap) 
  assign(long_support_w = adjusted_w - 2 * pipe_d) {
    // rear vertical tubes
    assign(vertical_tube_h = top_shelf_height - wood_t - pipe_d - desktop_to_pipe_spacing)
    for (x=[-1,1]) {
      translate([x * (adjusted_w / 2 - pipe_d / 2), -pipe_d/2 - top_overlap, vertical_tube_h/2]) 
        pipe("rear vertical", vertical_tube_h);
    }

    // front legs + tees
    assign(front_leg_h = desktop_height - desktop_to_pipe_spacing - pipe_d/2 - wood_t - tee_pipe_len_adj)
    translate([0, -desktop_depth + elbow_width + tee_w/2 + top_overlap, 0])
    for (x=[-1,1]) 
    translate([x * (adjusted_w / 2 - pipe_d / 2), 0, 0]) {
      translate([0, 0, front_leg_h/2]) {
        pipe("front leg", front_leg_h);
        translate([0, 0, (front_leg_h)/2 + tee_pipe_len_adj]) 
          rotate([90, 0, 0]) _tee();
      }
      for (z=[lower_shelf_height + wood_t/2, desktop_height - wood_t - desktop_to_pipe_spacing - tee_d - wood_t/2]) {
        translate([0, 0, z]) 
          rotate([0, 0, x * -90]) _clamp_assembly();
      }
    }

    // lower level
    translate([0, 0, lower_shelf_height - wood_t - desktop_to_pipe_spacing - pipe_d/2]) {
      // leg stabilizers
      assign(stabilizer_len = desktop_depth - top_overlap - elbow_width - tee_w / 2 - pipe_d / 2 - pipe_d / 2 - pipe_d / 2 - top_overlap)
      for (x=[-1,1]) 
      translate([x * (adjusted_w / 2 - pipe_d / 2), 0, 0]) {
        translate([0, -stabilizer_len/2 - pipe_d - top_overlap, 0]) {
          rotate([90, 0, 0]) 
            pipe("leg stabilizer", stabilizer_len - tee_pipe_len_adj);
          for (y=[-1,1]) {
            translate([0, y * (stabilizer_len/2 + pipe_d/2), 0]) 
              rotate([0, 0, -90 + y * 90]) _tee();
          }
        }
        translate([0, -lower_shelf_depth + top_overlap - wood_t/2, 0]) 
          rotate([90, 0, 0]) _clamp_assembly();
      }

      // lower shelf support
      translate([0, -lower_shelf_depth/2, 0]) {
        rotate([0, 90, 0]) pipe("lower shelf", long_support_w - tee_pipe_len_adj);
        for (x=[-1,1]) {
          translate([x * (long_support_w/2+pipe_d/2), 0, 0]) 
            rotate([0, 90, x * -90]) _tee();
        }
        for (x=[-1,-1/3,1/3,1]) {
          translate([x * (long_support_w/2+pipe_d/2 - tee_d - wood_t/2), 0, 0])
            rotate([90, 0, 90]) _clamp_assembly();
        }
      }
    }

    // desktop level
    translate([0, 0, desktop_height - wood_t - desktop_to_pipe_spacing - pipe_d/2]) {
      translate([0, -desktop_depth + pipe_d/2 + top_overlap, 0]) {
        // front desktop support
        rotate([0, 90, 0]) pipe("front support", long_support_w);

        // front elbows
        for (tx=[[-1, 0],[1,180]]) {
          translate([tx[0] * (adjusted_w/2 - pipe_d/2), 0, 0]) 
          rotate([90, tx[1], 0]) _elbow();
        }

        for (x=[-1,-1/3,1/3,1]) {
          translate([x * (long_support_w/2+pipe_d/2 - tee_d - wood_t/2), 0, 0])
            rotate([90, 0, 90]) _clamp_assembly();
        }
      }

      // desktop sides
      for (x=[-1,1]) {
        translate([x * (adjusted_w/2 - pipe_d / 2), 0, 0]) {
          translate([0, -desktop_depth/2, 0]) {
            translate([0, - tee_pipe_len_adj/4, 0]) 
              rotate([90, 0, 0]) 
                pipe("desktop side", desktop_depth - top_overlap * 2 - pipe_d*2 - tee_pipe_len_adj/2);
            translate([0, desktop_depth/2 - pipe_d/2 - top_overlap, 0]) 
              _tee();
          }

          for (y=[-desktop_depth + top_overlap + elbow_width + tee_w + wood_t/2, 
                  -top_overlap - tee_d - tee_w - wood_t/2,
                  -top_shelf_depth + top_overlap + pipe_d/2 - tee_w/2 - wood_t/2])
          {
            translate([0, y, 0]) 
              rotate([90, 0, 0]) 
                _clamp_assembly();
          }
        }
      }

      // back desktop support
      translate([0, - top_overlap - tee_d - tee_w/2, 0]) {
        rotate([0, 90, 0]) pipe("rear support", long_support_w - tee_pipe_len_adj);
        for (tx=[[-1,90],[1,-90]]) {
          translate([tx[0] * (adjusted_w/2 - pipe_d/2), 0, 0]) 
            rotate([0, 90, tx[1]]) 
              _tee();
        }

        for (x=[-1,-1/3,1/3,1]) {
          translate([x * (long_support_w/2+pipe_d/2 - tee_d - wood_t/2), 0, 0])
            rotate([90, 0, 90]) _clamp_assembly();
        }
      }
    }

    // top shelf level
    assign(rear_y = -pipe_d/2 - top_overlap)
    assign(front_y = -top_shelf_depth + pipe_d/2 + top_overlap)
    translate([0, 0, top_shelf_height - wood_t - desktop_to_pipe_spacing - pipe_d/2]) {
      // front and rear top shelf support
      for (y = [rear_y, front_y]) {
        translate([0, y, 0]) {
          rotate([0, 90, 0]) pipe("top shelf", long_support_w);
          for (tx=[[-1,0],[1,180]]) {
            translate([tx[0] * (width/2 - pipe_d/2-top_overlap), 0, 0]) 
              rotate([0, 0, tx[1]]) 
                _elbow();
          }
          for (x=[-1,-1/3,1/3,1]) {
            translate([x * (long_support_w/2 +pipe_d/2 - elbow_width + wood_t/2), 0, 0])
              rotate([90, 0, 90]) _clamp_assembly();
          }
        }
      }

      // top shelf cross supports
      for (x=[-1,1]) {
        translate([x * (adjusted_w / 2 - elbow_width - tee_w/2 - wood_t), -(rear_y - front_y) / 2 + rear_y, 0]) {
          rotate([90, 0, 0]) pipe("shelf cross", rear_y - front_y - pipe_d - tee_pipe_len_adj);
          for (y=[-1,1]) {
            translate([0, y * (rear_y - front_y) / 2, 0]) 
              rotate([-90 + y * 90, 90, 0]) _tee();
          }
          rotate([90, 0, 0]) _clamp_assembly();
        }
      }
    }

    // top shelf pillars
    assign(zupper = top_shelf_height - wood_t - desktop_to_pipe_spacing - pipe_d)
    assign(zlower = desktop_height - wood_t - desktop_to_pipe_spacing)
    assign(pillar_height = zupper - zlower)
    assign(yo = -top_shelf_depth + pipe_d/2 + top_overlap)
    assign(ho = zlower + pillar_height/2)
    for (x = [-1,1]) 
    translate([x * (adjusted_w / 2 - pipe_d / 2), yo, ho]) {
      translate([0, 0, tee_pipe_len_adj/2/2]) 
        pipe("top shelf pillar", pillar_height - tee_pipe_len_adj/2);
      translate([0, 0, -pillar_height/2 - pipe_d/2])
        rotate([-90, 0, 0]) 
          _tee();
    }
  }
}

module lower_shelf() {
  color("tan")
  assign(narrow_w = width - top_overlap * 2 - pipe_d * 2 - tee_metal_thickness * 2)
  assign(narrow_d = top_overlap + tee_metal_thickness * 2 + pipe_d)
  assign(r = pipe_d / 2 + tee_metal_thickness)
  linear_extrude(height=wood_t, center=true) {
    difference() {
      union() {
        translate([0, lower_shelf_depth/2 - narrow_d/2, 0]) 
          _rounded_rect(narrow_w, narrow_d, corner_r);

        assign(d = lower_shelf_depth - (top_overlap + tee_metal_thickness * 2 + pipe_d))
        translate([0, -lower_shelf_depth/2 + d/2, 0]) 
          _rounded_rect(width, d, corner_r);

        translate([0, lower_shelf_depth / 2 - (top_overlap + tee_metal_thickness * 2 + pipe_d), 0]) 
          square(size=[width - 2 * top_overlap - 2 * r, r*2], center=true);
      }
      for (x=[-1,1]) {
        translate([x * (narrow_w/2 + r), lower_shelf_depth/2 - narrow_d + r, 0]) {
          circle(r=r);
        }
      }
      
    }
  }
}

module top_shelf() {
  color("tan")
  linear_extrude(height=wood_t, center=true) {
    _rounded_rect(width, top_shelf_depth, corner_r);
  }
}

module _rounded_rect(w, h, r) {
  hull() {
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (w/2 - r), y * (h/2 - r), 0]) {
        circle(r=r, $fn=144);
      }
    }
  }
}

module desktop() {
  color("tan")
  difference() {
    linear_extrude(height=wood_t, center=true) {
      difference() {
        union() {
          // front rect
          assign(h=(desktop_depth - top_shelf_depth + top_overlap - tee_metal_thickness))
          translate([0, - desktop_depth/2 + h / 2, 0]) 
            _rounded_rect(width, h, corner_r);
          // mid rect
          assign(h=top_shelf_depth - top_overlap * 2 - pipe_d*2 - tee_metal_thickness*2)
          translate([0, desktop_depth/2 - top_shelf_depth/2, 0])
            _rounded_rect(width, h, corner_r);
          // back rect
          assign(h=top_overlap*2)
          translate([0, desktop_depth/2 - top_overlap, 0]) 
            _rounded_rect(width - 2 * top_overlap - 2 * pipe_d - 2 * tee_metal_thickness, h, corner_r);
          // joining rect
          translate([0, -top_overlap/2 - pipe_d/4, 0]) 
            square(size=[width - 2 * top_overlap - pipe_d, desktop_depth-top_overlap - pipe_d/2], center=true);
        }
        // pipe cutouts
        for (x=[-1,1]) {
          translate([x * (width - 2 * top_overlap - pipe_d) / 2, 0, 0]) {
            for (y=[desktop_depth/2 - top_shelf_depth + top_overlap + pipe_d/2, desktop_depth/2 - top_overlap - pipe_d/2]) {
              translate([0, y, 0]) 
              circle(r=pipe_d/2+tee_metal_thickness);
            }
          }
        }
      }
    }
  }
}

module assembled() {
  pipe_frame();
  translate([0, -desktop_depth/2, desktop_height - wood_t/2]) desktop();
  translate([0, -lower_shelf_depth/2, lower_shelf_height - wood_t/2]) lower_shelf();
  translate([0, -top_shelf_depth/2, top_shelf_height - wood_t/2]) top_shelf();

  assign(rear_pegboard_height = top_shelf_height - desktop_height - wood_t)
  translate([0, -top_overlap + pegboard_t/2, desktop_height + rear_pegboard_height/2]) 
    rotate([90, 0, 0]) 
      _pegboard(width, rear_pegboard_height);

  assign(side_pegboard_height = desktop_height - lower_shelf_height - wood_t - pipe_d - desktop_to_pipe_spacing)
  assign(side_pegboard_depth = desktop_depth - top_overlap - elbow_width)
  translate([0, -side_pegboard_depth/2, lower_shelf_height + side_pegboard_height/2]) 
  for(x=[-1,1]) {
    translate([x * (width + pegboard_t - top_overlap * 2 + desktop_to_pipe_spacing * 2) / 2, 0, 0]) 
    rotate([90, 0, 90]) 
      _pegboard(side_pegboard_depth, side_pegboard_height);
  }
}

translate([-width/2 - 500, 100, 0]) rotate([0, 0, 90]) _foot_scale(7);
translate([-width/2, 100, -100]) rotate([0, 90, 0]) _foot_scale(10);
translate([-width/2 - 500, 0, -100]) rotate([90, 90, 0]) _foot_scale(7);

assembled();
use <oshw.scad>

// arguments
laser_beam_width=.005*25.4;
material_thickness=3;
// material_thickness=5.4;
echo("Material thickness: ", material_thickness);
h = 50;
w = 260 + material_thickness*6 + 5;
d = 155 + material_thickness*2 + 5;

lid_h = 25;

// calculated
bottom_h = h-lid_h;

strut_width=10;
strut_pivot_r=5;
strut_pivot_hole_r=5.1;

rear_strut_sagitta_ratio=7;
rear_strut_bottom_dx = d / 2 - material_thickness - strut_pivot_r * 1.5;
rear_strut_bottom_dy = -1;
rear_strut_top_dx = d / 2 - material_thickness - strut_width * 5;
rear_strut_top_dy = -1;



rear_strut_delta_x = abs(rear_strut_bottom_dx - rear_strut_top_dx);
rear_strut_delta_y = abs((bottom_h / 2 - rear_strut_bottom_dy) + (lid_h / 2 - rear_strut_top_dy));
echo("rear_strut_delta_y", rear_strut_delta_y);
rear_strut_length = sqrt(pow(rear_strut_delta_x, 2) + pow(rear_strut_delta_y, 2));
rear_strut_init_angle = asin(rear_strut_delta_y / rear_strut_length);
echo("closed angle", rear_strut_init_angle);
rear_strut_max_angle = 120;
// rear_strut_max_angle = rear_strut_init_angle;

front_strut_sagitta_ratio=13;
front_strut_bottom_dx = d / 2 - material_thickness - strut_width * 4 - 1;
front_strut_bottom_dy = -1;
front_strut_top_dx = -(d / 2 - material_thickness - strut_width * 0.5 - 1);
front_strut_top_dy = -1;

front_strut_delta_x = abs(front_strut_bottom_dx - front_strut_top_dx);
front_strut_delta_y = abs((bottom_h / 2 - front_strut_bottom_dy) + (lid_h / 2 - front_strut_top_dy));
echo("front_strut_delta_y", front_strut_delta_y);
front_strut_length = sqrt(pow(front_strut_delta_x, 2) + pow(front_strut_delta_y, 2));
front_strut_init_angle = asin(front_strut_delta_y / front_strut_length);
echo("expected front strut init angle:", front_strut_init_angle);

bottom_bar = abs(front_strut_bottom_dx - rear_strut_bottom_dx);
diagonal_len = sqrt(pow(rear_strut_length, 2) + pow(bottom_bar, 2) - 2*rear_strut_length*bottom_bar*cos(rear_strut_max_angle));

echo("Diagonal len:", diagonal_len);

top_bar = abs(front_strut_top_dx - rear_strut_top_dx);
theta_upper = acos(
  (pow(front_strut_length, 2) + pow(diagonal_len, 2) - pow(top_bar, 2))
  /(2*front_strut_length*diagonal_len)
);
x = 
  (pow(diagonal_len, 2) + pow(bottom_bar, 2) - pow(rear_strut_length, 2))
  /(2*diagonal_len*bottom_bar);
theta_lower = acos(min(max(x, -1), 1));
echo("theta_lower:", theta_lower);

front_strut_max_angle = theta_lower + theta_upper;
echo ("front_strut_max_angle", front_strut_max_angle);

lid_angle_top = acos((pow(top_bar, 2) + pow(diagonal_len, 2) - pow(front_strut_length, 2))/(2*top_bar*diagonal_len));
lid_angle_bottom = (180 - rear_strut_max_angle - theta_lower);
lid_angle = lid_angle_top + lid_angle_bottom;
echo("lid_angle:", lid_angle);

latch_plate_radius = (lid_h - material_thickness) / 2 + (bottom_h - material_thickness) / 2;

module mirror_around() {
  for (a=[0,180]) {
    rotate([0, a, 0]) {
      child(0);
    }
  }
}

module front_back_base(h) {
  difference() {
    cube(size=[w+laser_beam_width, h+laser_beam_width, material_thickness], center=true);

    // end groove for matching to sides
    mirror_around() {
      translate([w/2, h/2 - (h-material_thickness)/2, 0]) {
        cube(size=[material_thickness*2-laser_beam_width, (h-material_thickness)/2 - laser_beam_width, material_thickness*2], center=true);
      }
    }

    // bottom tab
    translate([0, -h/2, 0]) {
      for (a=[0,180]) rotate([0, a, 0]) {
        translate([w/2 - w/6 + laser_beam_width, 0, 0]) cube(size=[w / 3, material_thickness*2 - laser_beam_width, material_thickness*2], center=true);
      }
    }

    // inward-offset groove for matching to retainers
    mirror_around() {
      translate([w/2 - material_thickness/2 - 2*material_thickness, h/2 - (h-material_thickness)/2, 0]) {
        cube(size=[material_thickness - laser_beam_width, (h-material_thickness)/2 - laser_beam_width, material_thickness*2], center=true);
      }
    }
  }
}

module front() {
  color([255/255, 0/255, 0/255]) {
    render() difference() {
      front_back_base(bottom_h);
      translate([0, material_thickness/2, 0]) cylinder(r=4, h=material_thickness+0.1, center=true);
      translate([0, latch_plate_radius + material_thickness/2, 0]) difference() {
        cylinder(r=latch_plate_radius + 4, h=10, center=true);
        cylinder(r=latch_plate_radius - 4, h=10, center=true);
        translate([latch_plate_radius + 4, 0, 0]) cube(size=[(latch_plate_radius + 4) * 2, (latch_plate_radius + 4) *2, material_thickness+0.1], center=true);
      }
    }
  }
}

module back() {
  color([255/255, 0/255, 0/255]) {
    render() front_back_base(bottom_h);
  }
}

module side_retainer_base(h) {
  difference() {
    cube(size=[d+laser_beam_width, h+laser_beam_width, material_thickness], center=true);
    mirror_around() {
      translate([d/2, h/2 - (h-material_thickness)/2, 0]) {
        for (i=[0,180]) rotate([0, 0, i]) {
          translate([0, (h-material_thickness)/2, 0]) cube(size=[material_thickness*2-laser_beam_width, (h-material_thickness)/2-laser_beam_width, material_thickness*2], center=true);
        }
      }
    }

    translate([0, -h/2, 0]) {
      for (a=[0,180]) rotate([0, a, 0]) {
        translate([d/2 - d/6 + laser_beam_width, 0, 0]) cube(size=[d / 3, material_thickness*2-laser_beam_width, material_thickness*2], center=true);
      }
    }
  }
}

module side() {
  color([0/255, 255/255, 0/255]) {
    render() side_retainer_base(bottom_h);
  }
}

module bottom_base() {
  difference() {
    cube(size=[w+laser_beam_width, d+laser_beam_width, material_thickness], center=true);
    for (a =[0,180]) rotate([0, 0, a]) {
      translate([0, -d/2, 0]) cube(size=[w / 3 - laser_beam_width, material_thickness*2-laser_beam_width, material_thickness*2], center=true);
      translate([-w/2, 0, 0]) cube(size=[material_thickness*2-laser_beam_width, d / 3 - laser_beam_width, material_thickness*2], center=true);
      translate([-w/2 + material_thickness/2 + 2*material_thickness - laser_beam_width/2, 0, 0]) cube(size=[material_thickness - laser_beam_width, d / 3 - laser_beam_width, material_thickness*2], center=true);
    }

    translate([-w/2 + material_thickness*3 + 10, 0, 0]) cube(size=[10 - laser_beam_width, material_thickness-laser_beam_width, material_thickness*1.1], center=true);

    translate([257/2 - 102 + material_thickness / 2, 0, 0]) for (a=[0,180]) {
      rotate([0, 0, a]) translate([0, 92/2, 0]) cube(size=[material_thickness-laser_beam_width, 10 - laser_beam_width, material_thickness+0.1], center=true);
    }
  }
}

module bottom() {
  color([0/255, 0/255, 255/255]) {
    render() bottom_base();
  }
}

module bottom_retainer_base() {
  difference() {
    side_retainer_base(bottom_h);

    for (t = [[rear_strut_bottom_dx, rear_strut_bottom_dy, 0], [front_strut_bottom_dx, front_strut_bottom_dy, 0]]) {
      translate(t) cylinder(r=strut_pivot_hole_r - laser_beam_width/2, h=material_thickness*2, center=true, $fn=100);
    }
  }
}

module left_bottom_retainer() {
  color([125/255, 125/255, 0/255]) {
    render() 
    difference() {
      bottom_retainer_base();
      translate([0, material_thickness/2, 0]) cube(size=[material_thickness - laser_beam_width, (bottom_h - material_thickness)/2 - laser_beam_width, material_thickness+0.1], center=true);
    }
  }
}

module right_bottom_retainer() {
  color([125/255, 125/255, 0/255]) {
    render() 
    difference() {
      bottom_retainer_base();
    }
  }
}

module complete_box() {
  translate([0, -d/2 + material_thickness/2 - 0.001, 0]) rotate([90, 0, 0]) front();
  translate([0, d/2 - material_thickness/2, 0]) rotate([0, 0, 180]) rotate([90, 0, 0]) back();
  translate([-w/2 + material_thickness/2, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) side();
  translate([w/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) side();
  translate([0, 0, -bottom_h/2 + material_thickness/2]) bottom();

  translate([-w/2 + material_thickness/2 + 2*material_thickness, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) left_bottom_retainer();
  translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 180]) right_bottom_retainer();
  
  translate([-w/2 + material_thickness*3 + 15 - material_thickness, 0, 0]) rotate([90, 0, 0]) face_support(bottom_h);
  
  translate([257/2 - 102 + material_thickness / 2, 0, 0]) for (a=[0,180]) {
    rotate([0, 0, a]) translate([0, -92/2, 0]) rotate([90, 0, 90]) blade_support(bottom_h);
  }
}

module lid_front() {
  color([255/255, 0/255, 0/255]) {
    render() difference() {
      front_back_base(lid_h);
      translate([0, material_thickness/2, 0]) {
        cylinder(r=4, h=material_thickness+0.1, center=true, $fn=72);
        rotate([0, 0, -60]) translate([0, latch_plate_radius, 0]) cylinder(r=4, h=material_thickness+0.1, center=true, $fn=72);
        rotate([0, 0, 210]) difference() {
          cylinder(r=latch_plate_radius + 4, h=material_thickness+0.1, center=true, $fn=1000);
          cylinder(r=latch_plate_radius - 4, h=material_thickness+0.15, center=true, $fn=1000);
          translate([latch_plate_radius + 4, 0, 0]) cube(size=[(latch_plate_radius + 4) * 2, (latch_plate_radius + 4) *2, material_thickness+0.2], center=true);
          rotate([0, 0, 90]) translate([latch_plate_radius + 4, 0, 0]) cube(size=[(latch_plate_radius + 4) * 2, (latch_plate_radius + 4) *2, material_thickness+0.2], center=true);
        }
      }
    }
  }
}

module lid_back() {
  color([255/255, 0/255, 0/255]) render() {
    front_back_base(lid_h);
  }
}

module lid_side() {
  color([0/255, 255/255, 0/255]) {
    render() side_retainer_base(lid_h);
  }
}

module lid_bottom() {
  color([0/255, 0/255, 255/255]) {
    render() difference() {
      bottom_base();
      linear_extrude(height=material_thickness*2, center=true) oshw(-laser_beam_width/2, 1.5);
    }
  }
}

module lid_retainer_base() {
  difference () {
    side_retainer_base(lid_h);

    for (t = [[rear_strut_top_dx, rear_strut_top_dy, 0], [front_strut_top_dx, front_strut_top_dy, 0]]) {
      translate(t) cylinder(r=strut_pivot_r - laser_beam_width/2, h=material_thickness*2, center=true);
    }
  }
}

module right_lid_retainer() {
  color([125/255, 125/255, 0/255]) {
    render() lid_retainer_base();
  }
}

module left_lid_retainer() {
  color([125/255, 125/255, 0/255]) {
    render()
    difference() {
      lid_retainer_base();
      translate([0, material_thickness/2, 0]) cube(size=[material_thickness - laser_beam_width, (lid_h - material_thickness)/2 - laser_beam_width, material_thickness+0.1], center=true);
    }
  }
}

module complete_lid() {
  translate([0, -d/2 + material_thickness/2 - 0.001, 0]) rotate([90, 0, 0]) lid_front();
  translate([0, d/2 - material_thickness/2, 0]) rotate([0, 0, 180]) rotate([90, 0, 0]) lid_back();
  translate([-w/2 + material_thickness/2, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) lid_side();
  translate([w/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) lid_side();
  translate([0, 0, -lid_h/2 + material_thickness/2]) rotate([0, 0, 180]) lid_bottom();

  translate([-w/2 + material_thickness/2 + 2*material_thickness, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) right_lid_retainer();
  translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 180]) left_lid_retainer();

  translate([w/2 - material_thickness*3 - 15 + material_thickness, 0, 0]) rotate([90, 0, 180]) face_support(lid_h);

  rotate([0, 0, 180]) translate([257/2 - 102 + material_thickness / 2, 0, 0]) for (a=[0,180]) {
    rotate([0, 0, a]) translate([0, -92/2, 0]) rotate([90, 0, 90]) blade_support(bottom_h);
  }

  translate([0, -d/2 - material_thickness/2, +material_thickness/2]) rotate([0, 0, 0]) rotate([90, 180, 0]) latch_assembly();
}

module strut_pivot(pivot_r) {
  render() difference() {
    cylinder(r=pivot_r+laser_beam_width/2, h=material_thickness, center=true, $fn=100);
    alignment_mark();
  }
}

module strut(length, width, sagitta, dir, pivot_r) {
  render() {
    union() {
      // the end cylinders
      for (x = [0,length]) translate([x, 0, 0]) {
        difference() {
          cylinder(r=pivot_r+0.5, h=material_thickness, center=true, $fn=100);
          alignment_mark();
        }
      }

      // the arc
      intersection() {
        translate([length/2, -length*length/8/sagitta+sagitta/2, 0]) {
          difference() {
            cylinder(r=length*length/8/sagitta+sagitta/2 + width/2, h=material_thickness, center=true, $fn=1000);
            cylinder(r=length*length/8/sagitta+sagitta/2 - width/2, h=11, center=true, $fn=1000);
          }
        }
        difference() {
          translate([length/2, length/2, 0]) cube(size=[length+width-pivot_r, length+width, material_thickness*2], center=true);
          for (x = [0,length]) translate([x, 0, 0]) {
            cylinder(r=pivot_r+0.5, h=material_thickness*2.1, center=true, $fn=100);
          }
        }
      }
    }
  }
}

module curve_strut_assembly(length, width, sagitta, dir, pivot_r) {
  strut(length, width, sagitta, dir, pivot_r);
  translate([0, 0, dir * (material_thickness+1)]) for (x = [0, length]) translate([x, 0, 0]) {
    strut_pivot(pivot_r);
  }
}

module face_support(h) {
  render() intersection() {
    difference() {
      cube(size=[30+laser_beam_width, h+laser_beam_width, material_thickness], center=true);

      translate([30/2 - 10 + laser_beam_width, h/2 + laser_beam_width , 0]) cube(size=[20, 13.5, material_thickness+0.1], center=true);

      for (a=[0,180]) {
        rotate([0, a, 0]) translate([30/2, -h/2, 0]) cube(size=[20, material_thickness*2, material_thickness+0.1], center=true);
        translate([0, material_thickness/2, 0]) rotate([a, 0, 0]) translate([-30/2 - laser_beam_width, (h-material_thickness)/2, 0]) cube(size=[material_thickness*2, (h - material_thickness) / 2, material_thickness+0.1], center=true);
      }
    }
    translate([-20, -h/2 + material_thickness, 0]) scale([1, .65, 1]) cylinder(r=35, h=material_thickness, center=true, $fn=1000);
  }
}

module blade_support(h) {
  render() {
    intersection() {
      difference() {
        cube(size=[30+laser_beam_width, h+laser_beam_width, material_thickness], center=true);

        for (a=[0,180]) {
          rotate([0, a, 0]) translate([30/2, -h/2, 0]) cube(size=[20-laser_beam_width, material_thickness*2-laser_beam_width, material_thickness+0.1], center=true);
        }

        translate([15+laser_beam_width/2, h/2, 0]) cube(size=[30-laser_beam_width, 6.25-laser_beam_width, material_thickness+0.1], center=true);
      }
      translate([20, -h/2 + material_thickness, 0]) cylinder(r=35, h=material_thickness, center=true, $fn=1000);
      translate([-20, -h/2 + material_thickness, 0]) cylinder(r=35, h=material_thickness, center=true, $fn=1000);
    }
  }
}

module alignment_mark() {
  union() {
    cube(size=[2, .1, material_thickness+0.1], center=true);
    cube(size=[.1, 2, material_thickness+0.1], center=true);
  }
}

module latch_plate() {
  render() 
  translate([0, -latch_plate_radius/2, 0]) difference() {
    intersection() {
      intersection_for (a=[0,180]) rotate([0, 0, a]) {
        translate([0, 60-latch_plate_radius/2-6, 0]) cylinder(r=60, h=material_thickness, center=true, $fn=1000);
      }
      cylinder(r=latch_plate_radius + 10, h=material_thickness, center=true, $fn=1000);
    }
    for (i=[0,180]) {
      rotate([0, 0, i]) translate([0, latch_plate_radius/2, 0]) alignment_mark();
    }
  }
}

module latch_catch() {
  difference() {
    cylinder(r=4+laser_beam_width/2, h=material_thickness, center=true, $fn=72);
    alignment_mark();
  }
}

module latch_pivot_inside() {
  latch_catch();
}

module latch_pivot_endplate() {
  difference() {
    cylinder(r=6+laser_beam_width/2, h=material_thickness, center=true, $fn=72);
    alignment_mark();
  }
}

module latch_assembly() {
  latch_plate();
  translate([0, -latch_plate_radius, -material_thickness]) latch_catch();
  translate([0, 0, -material_thickness]) latch_pivot_inside();
  translate([0, 0, -2 * material_thickness]) latch_pivot_endplate();
}

module assembled() {
  complete_box();

  translate([-w/2 + material_thickness * 3/2, front_strut_bottom_dx, front_strut_bottom_dy]) 
    rotate([-180 + front_strut_max_angle, 0, 0]) 
      rotate([-90, 0, -90]) 
        curve_strut_assembly(front_strut_length, strut_width, front_strut_length/front_strut_sagitta_ratio, 1, strut_pivot_r);

  translate([-w/2 + material_thickness * 3/2, rear_strut_bottom_dx, rear_strut_bottom_dy]) 
    rotate([-rear_strut_max_angle, 0, 0]) {
      rotate([-90, 0, -90]) 
        curve_strut_assembly(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);
    }

  translate([w/2 - material_thickness * 3/2, front_strut_bottom_dx, front_strut_bottom_dy]) 
    rotate([-180 + front_strut_max_angle, 0, 0]) 
      rotate([-90, 0, -90]) 
        curve_strut_assembly(front_strut_length, strut_width, front_strut_length/front_strut_sagitta_ratio, -1, strut_pivot_r);

  translate([w/2 - material_thickness * 3/2, rear_strut_bottom_dx, rear_strut_bottom_dy]) 
    rotate([-rear_strut_max_angle, 0, 0]) {
      rotate([-90, 0, -90]) 
        curve_strut_assembly(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, -1, strut_pivot_r);
    }

  translate([0, rear_strut_bottom_dx, rear_strut_bottom_dy]) {
    rotate([-rear_strut_max_angle, 0, 0]) {
      translate([0, -rear_strut_length, 0]) 
        rotate([180-lid_angle, 0, 0]) 
          rotate([0, 180, 0]) 
            translate([0, -rear_strut_top_dx, -rear_strut_top_dy]) 
              complete_lid();
    }
  }
  
  
}

module paddle() {
  color([0/255, 0/255, 0/255, 0.5]) {
    translate([-102/2 + 257/2 - 102/2, -92/2, -6.25/2]) {
      linear_extrude(height=6.25) {
        polygon(points=[
          [0, 0],
          [32, 92/2 - 26.5/2],
          [102, 92/2 - 35/2],
          [102, 92/2 + 35/2],
          [32, 92/2 + 26.5/2],
          [0, 92]
        ]);
      }
      // cylinder(r1=5, h=70, center=true);
    }

    translate([257/2 - 35, 0, 0]) rotate([0, 180, 0]) translate([-35, -12, -12]) linear_extrude(height=25) {
      polygon(points=[
        [0, 0],
        [70, 24/2 - 15.5/2],
        [70, 24/2 + 15.5/2],
        [0, 25]
      ]);
    }

    // translate([257/2, -9.25, 6.25/2]) scale([1, 1, 1.1]) rotate([0, 0, -3]) rotate([0, 90, 0]) cylinder(r=8, h=70, center=true, $fn=36);
    translate([-257/2 + 155/2, 0, 0]) {
      // cylinder(r=155 + , h=10, center=true);
      cube(size=[155, 155, 13.5], center=true);
    }
  }
}

module array(sep) {
  for (i = [0:$children-1]) {
    translate([0, sep * i, 0]) child(i);
  }
}

module panelized() {
  translate([0, d/2+1, 0]) lid_bottom();
  translate([0, -d/2-1, 0]) bottom();
  
  render() 
  translate([0, d+2 + bottom_h/2, 0]) array(bottom_h+1) {
    front();
    back();
    union() {
      translate([-d/2-1, 0, 0]) side();
      translate([d/2+1, 0, 0]) side();
    }
    union() {
      translate([-d/2-1, 0, 0]) right_bottom_retainer();
      translate([d/2+1, 0, 0]) left_bottom_retainer();
    }
    union() {
      translate([-31, 0, 0]) face_support(bottom_h);
      blade_support(bottom_h);
      translate([31, 0, 0]) blade_support(bottom_h);
    }
    
  }

  render() 
  translate([d*2 + 3, d+2 + bottom_h/2, 0]) array(bottom_h+1) {
    lid_front();
    lid_back();
    union() {
      translate([-d/2-1, 0, 0]) lid_side();
      translate([d/2+1, 0, 0]) lid_side();
    }
    union() {
      translate([-d/2-1, 0, 0]) right_lid_retainer();
      translate([d/2+1, 0, 0]) left_lid_retainer();
    }
    union() {
      translate([-31, 0, 0]) face_support(lid_h);
      blade_support(lid_h);
      translate([31, 0, 0]) blade_support(lid_h);
    }
  }

  render() 
  translate([w/2 + 10, 0, 0]) rotate([0, 0, -90]) array(20) {
    strut(front_strut_length, strut_width, front_strut_length/front_strut_sagitta_ratio, 1, strut_pivot_r);
    strut(front_strut_length, strut_width, front_strut_length/front_strut_sagitta_ratio, -1, strut_pivot_r);
    strut(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, 1, strut_pivot_r);
    strut(rear_strut_length, strut_width, rear_strut_length/rear_strut_sagitta_ratio, -1, strut_pivot_r);
  }

  render() 
  translate([w/2 + 10, d/4, 0]) {
    for (i=[0:15]) {
      translate([(strut_pivot_r *2 + 2) * (i % 8), floor(i / 8) * -(strut_pivot_r*2 + 1), 0]) strut_pivot(strut_pivot_r);
    }
  }

  render() 
  translate([w/2 + 10, d / 2, 0]) rotate([0, 0, -90]) array(11) {
    latch_pivot_endplate();
    latch_pivot_inside();
    latch_pivot_inside();
    latch_pivot_inside();
    latch_pivot_inside();
    latch_catch();
  }

  translate([w/2 + 100, d / 2, 0]) latch_plate();

}

// assembled();
// 
// translate([0, 0, h/2 - bottom_h/2]) paddle();

// projection(cut=true) {
//   panelized();
// }
translate([w + 20, d / 2, 0]) !rotate([0, 0, -90]) array(100) {
  oshw(-laser_beam_width*1.5, 1.5);
  oshw(-laser_beam_width*2, 1.5);
  oshw(-laser_beam_width*2.5, 1.5);
}

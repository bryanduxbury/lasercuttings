include <params.scad>

module sawtooth(tab_size, tab_spacing, num_tabs) {
  for (i=[0:num_tabs-1]) {
    translate([(i - floor(num_tabs/2)) * 2 * tab_size + (num_tabs % 2 == 1 ? tab_size : 0), 0, 0]) 
    cube(size=[tab_size + 0.01, material_thickness+0.001, material_thickness*2], center=true);
  }
}

module lid_front() {
  color([255/255, 0/255, 0/255]) {
    difference() {
      cube(size=[w, lid_h, material_thickness], center=true);
      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([w/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
          }
        }
      }
      translate([0, -lid_h/2 + material_thickness/2, 0]) sawtooth(w/11, 0, 6);

      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
          }
        }
      }
    }
  }
}

module lid_back() {
  color([255/255, 0/255, 0/255]) difference() {
    cube(size=[w, lid_h, material_thickness], center=true);
    for (a = [0, 180]) {
      rotate([0, a, 0]) {
        translate([w/2 - material_thickness/2, 0, 0]) {
          rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
        }
      }
    }

    translate([0, -lid_h/2+material_thickness/2, 0]) sawtooth(w/11, 0, 6);
    
    for (a = [0, 180]) {
      rotate([0, a, 0]) {
        translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) {
          rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
        }
      }
    }
    
  }
}

module lid_side() {
  color([0/255, 255/255, 0/255]) {
    difference() {
      cube(size=[d, lid_h, material_thickness], center=true);
      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([d/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 6);
          }
        }
      }

      translate([0, -lid_h/2 + material_thickness/2, 0]) sawtooth(d/7, 0, 4);
    }
  }
}

module lid_bottom() {
  color([0/255, 0/255, 255/255]) {
    difference() {
      cube(size=[w, d, material_thickness], center=true);
      translate([0, -d/2 + material_thickness/2, 0]) sawtooth(w/11, 0, 7);
      translate([0, d/2 - material_thickness/2, 0]) sawtooth(w/11, 0, 7);
      for (a = [0, 180]) rotate([0, a, 0]) {
        translate([w/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) sawtooth(d/7, 0, 5);
      }
      
      for (a = [0, 180]) rotate([0, a, 0]) {
        translate([-w/2 + material_thickness/2 + 2*material_thickness, 0, 0]) rotate([0, 0, 90]) sawtooth(d/9, 0, 5);
      }
    }
  }
}

module lid_retainer() {
  color([125/255, 125/255, 0/255]) {
    difference () {
      cube(size=[d, lid_h, material_thickness], center=true);

      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([d/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
          }
        }
      }

      translate([0, -lid_h/2 + material_thickness/2, 0]) sawtooth(d/9, 0, 6);

      translate([rear_strut_top_dx, rear_strut_top_dy, 0]) cylinder(r=5.25, h=material_thickness*2, center=true);
      translate([front_strut_top_dx, front_strut_top_dy, 0]) cylinder(r=5.25, h=material_thickness*2, center=true);
    }
  }
}

module complete_lid() {
  translate([0, -d/2 + material_thickness/2 - 0.001, 0]) rotate([90, 0, 0]) lid_front();
  translate([0, d/2 - material_thickness/2, 0]) rotate([0, 0, 180]) rotate([90, 0, 0]) lid_back();
  // translate([-w/2 + material_thickness/2, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) lid_side();
  // translate([w/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) lid_side();
  translate([0, 0, -lid_h/2 + material_thickness/2]) lid_bottom();

  translate([-w/2 + material_thickness/2 + 2*material_thickness, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) lid_retainer();
  translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 180]) lid_retainer();
}

complete_lid();
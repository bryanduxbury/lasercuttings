include <params.scad>

module sawtooth(tab_size, tab_spacing, num_tabs) {
  for (i=[0:num_tabs-1]) {
    translate([(i - floor(num_tabs/2)) * 2 * tab_size + (num_tabs % 2 == 1 ? tab_size : 0), 0, 0]) 
    cube(size=[tab_size + 0.01, material_thickness+0.001, material_thickness*2], center=true);
  }
}

module front() {
  color([255/255, 0/255, 0/255]) {
    difference() {
      cube(size=[w, bottom_h, material_thickness], center=true);
      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([w/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
          }
        }
      }
      translate([0, -bottom_h/2 + material_thickness/2, 0]) sawtooth(w/11, 0, 6);
    }
  }
}

module back() {
  color([255/255, 0/255, 0/255]) difference() {
    cube(size=[w, bottom_h, material_thickness], center=true);
    for (a = [0, 180]) {
      rotate([0, a, 0]) {
        translate([w/2 - material_thickness/2, 0, 0]) {
          rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
        }
      }
    }

    translate([0, -bottom_h/2+material_thickness/2, 0]) sawtooth(w/11, 0, 6);
  }
}

module side() {
  color([0/255, 255/255, 0/255]) {
    difference() {
      cube(size=[d, bottom_h, material_thickness], center=true);
      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([d/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 6);
          }
        }
      }

      translate([0, -bottom_h/2 + material_thickness/2, 0]) sawtooth(d/7, 0, 4);
    }
  }
}

module bottom() {
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

module retainer() {
  color([125/255, 125/255, 0/255]) {
    difference () {
      cube(size=[d, bottom_h, material_thickness], center=true);

      for (a = [0, 180]) {
        rotate([0, a, 0]) {
          translate([d/2 - material_thickness/2, 0, 0]) {
            rotate([0, 0, 90]) sawtooth(bottom_h/9, 0, 5);
          }
        }
      }

      translate([0, -bottom_h/2 + material_thickness/2, 0]) sawtooth(d/9, 0, 6);
    }
  }
}

translate([0, -d/2 + material_thickness/2 - 0.001, 0]) rotate([90, 0, 0]) front();
translate([0, d/2 - material_thickness/2, 0]) rotate([0, 0, 180]) rotate([90, 0, 0]) back();
translate([-w/2 + material_thickness/2, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) side();
translate([w/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) side();
translate([0, 0, -bottom_h/2 + material_thickness/2]) bottom();

translate([-w/2 + material_thickness/2 + 2*material_thickness, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) retainer();
translate([w/2 - material_thickness/2 - 2*material_thickness, 0, 0]) rotate([0, 0, -90]) rotate([90, 0, 0]) retainer();

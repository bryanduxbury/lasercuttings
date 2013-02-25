use <./helpers.scad>

// params
/////////

wood_t = 5.2;
acrylic_t = 3;

trunk_w = 40;
trunk_h = 150;

central_canopy_h = 48;
central_canopy_w = 125;
central_canopy_d = 100;

side_canopy_h = 36;
side_canopy_w = 90;
side_canopy_d = 75;

canopy_overlap = 50;


// todo: add offset parameter to indicate spread of canopy

big_root_w = 75;
big_root_h = 50;
big_root_curve_r = 10;

small_root_w = 55;
small_root_h = 35;
small_root_curve_r = 7;

trunk_overlap = 5;


bottom_clearance = 10;
cord_clearance = 8;
tab_width = 10;


lay_flat = false;

function _xy() = [0,0,0];
function _xz() = lay_flat ? [0, 0, 0] : [90, 0, 0];
function _yz() = lay_flat ? [0, 0, 0] : [90, 0, 90];

brown1 = [102/255, 51/255, 0];
brown2 = [148/255, 112/255, 77/255];

module root_section(w, h, r) {
  intersection() {
    difference() {
      union() {
        translate([(w - r) / 2, (h - r) / 2, 0]) 
          square(size=[w - r, h - r], center=true);
        translate([w - r, 0, 0]) circle(r=r, $fn=36);
        translate([0, h - r, 0]) circle(r=r, $fn=36);
      }
      translate([w - r, h - r, 0]) 
        scale([w - 2 * r, h - 2 * r, 1]) 
          circle(r=1, $fn=36);
    }
    translate([w / 2, h / 2, 0]) 
      square(size=[w, h], center=true);
  }
}

module front_back_base() {
  difference() {
    union() {
      square(size=[trunk_w, trunk_h], center=true);
      for (x=[-1,1]) translate([x * (trunk_w / 2), -trunk_h/2, 0]) rotate([0, -90 + 90 * x, 0]) {
        root_section(big_root_w, big_root_h, big_root_curve_r);
      }
    }
    translate([0, -trunk_h/2 + (small_root_h - trunk_overlap) / 2, 0]) for (x=[-1,1]) {
      translate([x * (trunk_w/2 - wood_t/2), 0, 0]) square(size=[wood_t, small_root_h - trunk_overlap], center=true);
    }
    
    translate([0, trunk_h/2 - 2 * wood_t, 0]) for (x=[-1,1]) {
      translate([x * (trunk_w/2), 0, 0]) square(size=[wood_t*2, wood_t], center=true);
    }
  }
}

module front() {
  front_back_base();
}

module back() {
  difference() {
    front_back_base();
    translate([0, -trunk_h/2, 0]) {
      square(size=[cord_clearance, cord_clearance], center=true);
      translate([0, cord_clearance/2, 0]) circle(r=cord_clearance/2, $fn=36);
    }
  }
  
}

module side() {
  difference() {
    union() {
      square(size=[trunk_w - wood_t*2, trunk_h], center=true);
      translate([0, -trunk_h/2 + (small_root_h - trunk_overlap) / 2, 0]) 
        square(size=[trunk_w, small_root_h - trunk_overlap], center=true);
      for (x=[-1,1]) translate([x * (trunk_w / 2), -trunk_h/2, 0]) rotate([0, -90 + 90 * x, 0]) {
        root_section(small_root_w, small_root_h, small_root_curve_r);
      }

      translate([0, trunk_h/2 - 2 * wood_t, 0]) square(size=[trunk_w, wood_t], center=true);
    }

    translate([0, -trunk_h/2 + bottom_clearance + wood_t/2, 0]) square(size=[tab_width, wood_t], center=true);
  }
}

module bottom() {
  difference() {
    square(size=[trunk_w, trunk_w - wood_t*2], center=true);
    for (x=[-1,1], y=[-1, 1]) {
      translate([x * (trunk_w / 2), y * (trunk_w / 2), 0]) {
        square(size=[wood_t*2, trunk_w - tab_width], center=true);
      }
    }
  }
}

module internal_branch() {
  
}

module big_branch_assembly() {
  
}

module external_branch_assembly() {
  // translate([100, 10, 0]) square(size=[10, 10], center=true);
  rotate([0, 0, -90]) root_section(30, 60, 8);
}

module 3d_canopy_blank2() {
  union() {
    difference() {
      scale([central_canopy_w/2, central_canopy_d/2, central_canopy_h]) sphere(r=1, $fn=64);
      translate([0, 0, -central_canopy_h]) cube(size=[2*central_canopy_w, 2*central_canopy_d, 2*central_canopy_h], center=true);
    }
    translate([-side_canopy_w/2 - central_canopy_w/2 + canopy_overlap, 0, -central_canopy_h/2]) difference() {
      scale([side_canopy_w/2, side_canopy_d/2, side_canopy_h]) sphere(r=1, $fn=64);
      translate([0, 0, -central_canopy_h/2]) cube(size=[2*central_canopy_w, 2*central_canopy_d, central_canopy_h], center=true);
    }
  }
}


module 3d_canopy_blank() {
  union() {
    scale([75, 60, 24]) sphere(r=1, $fn=64);
    translate([0, 0, -6]) for (x=[-1,1]) {
      translate([x * 75, 0, 0]) scale([50, 50, 18]) sphere(r=1, $fn=64);
    }
  }
}

module canopy_assembly() {
  for (slicenum=[-11:11]) {
    translate([0, 0, -3 * slicenum]) ext(3) projection(cut=true) translate([0, 0, slicenum*3 + 0.1]) 3d_canopy_blank2();
  }
}



module assembled() {
  translate([0, -trunk_w / 2 + wood_t/2, 0]) rotate(_xz()) color(brown1) ext(wood_t) front();
  translate([0, trunk_w / 2 - wood_t/2, 0]) rotate(_xz()) color(brown1) ext(wood_t) back();

  for (x=[-1,1]) {
    translate([x * (trunk_w / 2 - wood_t/2), 0, 0]) rotate(_yz()) color(brown2) ext(wood_t) side();
  }
  
  translate([0, 0, -trunk_h/2 + bottom_clearance + wood_t/2]) ext(wood_t) bottom();
  translate([0, 0, trunk_h/2 - 10]) canopy_assembly();
  
  for (x=[-1]) {
    translate([x * trunk_w/2, 0, trunk_h/2 - 25]) rotate([0, 0, -90 + 90 * x]) rotate(_xz()) color(brown1) ext(wood_t) external_branch_assembly();
  }
}

assembled();

// !3d_canopy_blank2();
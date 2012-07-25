include <params.scad>

tray_h = bottom_h / 4;

tray_w = w - material_thickness * 7;
tray_d = d - material_thickness * 3;

h_teeth = 3;
w_teeth = 9;
d_teeth = 9;

h_tooth_width = (tray_h - material_thickness) / h_teeth / 2;
w_tooth_width = tray_w / w_teeth / 2;
d_tooth_width = tray_d / d_teeth / 2;

h_division_w = (tray_w - material_thickness) / 7;

top_right_quad_v = tray_d - 5 * 25;
middle_top_v = top_right_quad_v / 2;

left_v = tray_d - 9 * 25;

v3_width = h_division_w * 2 + material_thickness;

module cutout_array(num_teeth, tooth_width) {
  translate([-num_teeth * tooth_width, 0, 0]) {
    for(i=[0:num_teeth-1]) {
      translate([i * 2 * tooth_width + tooth_width, 0, 0])
        cube(size=[tooth_width-laser_beam_width, material_thickness*2, material_thickness+laser_beam_width], center=true);
    }
  }
}

module inverse_cutout_array(num_teeth, tooth_width) {
  cutout_array(num_teeth+1, tooth_width);
}


module tray_bottom() {
  color([0, 1, 0]) render() difference() {
    cube(size=[tray_w, tray_d, material_thickness], center=true);
    translate([-tray_w / 2, 0, 0]) rotate([0, 0, 90]) cutout_array(d_teeth, d_tooth_width);
    translate([tray_w / 2, 0, 0]) rotate([0, 0, 90]) cutout_array(d_teeth, d_tooth_width);
    translate([0, tray_d / 2, 0]) rotate([0, 0, 0]) cutout_array(w_teeth, w_tooth_width);
    translate([0, -tray_d / 2, 0]) rotate([0, 0, 0]) cutout_array(w_teeth, w_tooth_width);

    translate([-tray_w / 2 + material_thickness / 2, 0, 0]) {
      translate([1/6*tray_w, 0, 0]) rotate([90, 0, 90]) cutout_array(d_teeth, d_tooth_width);
      translate([1/3*tray_w, 0, 0]) rotate([90, 0, 90]) cutout_array(d_teeth, d_tooth_width);
      translate([1/2*tray_w, 0, 0]) rotate([90, 0, 90]) cutout_array(d_teeth, d_tooth_width);
      translate([13/16*tray_w, 0, 0]) rotate([90, 0, 90]) cutout_array(d_teeth, d_tooth_width);

      translate([1/4 * tray_w, 0, 0]) {
        translate([0, tray_d / 2 - tray_d / 3, 0]) rotate([90, 0, 0]) cutout_array(5, v1_width / 11);
        translate([0, tray_d / 2 - tray_d * 2 / 3, 0]) rotate([90, 0, 0]) cutout_array(5, v1_width / 11);
      }
      
      translate([(1/2 + 13/16) / 2 * tray_w, v2_v, 0]) rotate([90, 0, 0]) cutout_array(3, v2_width / 7);
    }
    
  }
}

module h_div_base() {
  difference() {
    cube(size=[tray_d, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(d_teeth, d_tooth_width);
    translate([-tray_d / 2, material_thickness, 0]) rotate([0, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    translate([tray_d / 2, material_thickness, 0]) rotate([0, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
}

module tray_l() {
  color([1, 0, 0]) render() difference() {
    h_div_base();
    translate([-tray_d / 2 + tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    translate([tray_d / 2 - tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
}

module tray_r() {
  color([1, 0, 0]) render() difference() {
    h_div_base();
  }
}


module tray_front() {
  color([0/255, 0/255, 255/255]) render() difference() {
    cube(size=[tray_w, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(w_teeth, w_tooth_width);

    translate([-tray_w / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    translate([tray_w / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);

    for (i=[1/6 * tray_w, 1/3 * tray_w, 1/2 * tray_w, 13/16 * tray_w]) {
      translate([-tray_w / 2 + material_thickness / 2 + i, material_thickness, 0]) rotate([90, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    }
  }
}

module tray_back() {
  tray_front();
}


module h_div_1() {
  color([255/255, 0/255, 0/255]) render() difference() {
    h_div_base();
    translate([-tray_d / 2 + tray_d / 3, -tray_h / 2, 0]) cube(size=[material_thickness, tray_h, material_thickness*2], center=true);
    translate([tray_d / 2 - tray_d / 3, -tray_h / 2, 0]) cube(size=[material_thickness, tray_h, material_thickness*2], center=true);
  }
}

module h_div_2() {
  color([255/255, 0/255, 0/255]) render() difference() {
    h_div_base();
    translate([-tray_d / 2 + tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    // translate([tray_d / 2 - tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    #translate([v2_v, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
}

module h_div_2_prime() {
  color([255/255, 0/255, 0/255]) render() difference() {
    h_div_base();
    // translate([-tray_d / 2 + tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    translate([tray_d / 2 - tray_d / 3, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    #translate([v2_v, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
}


module h_div_3() {
  color([255/255, 0/255, 0/255]) render() difference() {
    h_div_base();
    translate([v2_v, material_thickness, 0]) rotate([90, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
}

v1_width = 1/2 * tray_w + material_thickness;
module v_div_1() {
  color([0/255, 0/255, 255/255]) render() difference() {
    cube(size=[v1_width, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(5, v1_width/11);
    translate([-(v1_width) / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    translate([(v1_width) / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    
    translate([-v1_width/2 + v1_width / 3, tray_h/2, 0]) cube(size=[material_thickness, tray_h, material_thickness*2], center=true);
    translate([-v1_width/2 + v1_width * 2 / 3, tray_h/2, 0]) cube(size=[material_thickness, tray_h, material_thickness*2], center=true);
  }
}

v2_width = tray_w * 5 / 16 + material_thickness;
v2_v = tray_d / 2 - 5 * 25;
module v_div_2() {
  color([0/255, 0/255, 255/255]) render() difference() {
    cube(size=[v2_width, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(3, v2_width / 7);
    translate([-(v2_width) / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    translate([(v2_width) / 2, material_thickness, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
  }
}

module tray_assembled() {
  translate([0, 0, -tray_h/2 + material_thickness / 2]) tray_bottom();
  translate([-tray_w / 2 + material_thickness / 2, 0, 0]) rotate([90, 0, 90]) tray_l();
  translate([tray_w / 2 - material_thickness / 2, 0, 0]) rotate([90, 0, 90]) tray_r();
  translate([0, -tray_d / 2 + material_thickness / 2, 0]) rotate([90, 0, 0]) tray_front();
  translate([0, tray_d / 2 - material_thickness / 2, 0]) rotate([90, 0, 0]) tray_back();
  
  translate([-tray_w / 2 + material_thickness / 2, 0, 0]) {
    translate([1/6*tray_w, 0, 0]) rotate([90, 0, 90]) h_div_1();
    translate([1/3*tray_w, 0, 0]) rotate([90, 0, 90]) h_div_1();
    translate([1/2*tray_w, 0, 0]) rotate([90, 0, 90]) h_div_2();
    translate([13/16*tray_w, 0, 0]) rotate([90, 0, 90]) h_div_3();
    
    translate([1/4 * tray_w, 0, 0]) {
      translate([0, tray_d / 2 - tray_d / 3, 0]) rotate([90, 0, 0]) v_div_1();
      translate([0, tray_d / 2 - tray_d * 2 / 3, 0]) rotate([90, 0, 0]) v_div_1();
    }

    translate([(1/2 + 13/16) / 2 * tray_w, v2_v, 0]) rotate([90, 0, 0]) v_div_2();
  }

}

module array(sep) {
  for (i = [0:$children-1]) {
    translate([sep * 2 * i, 0, 0]) child(i);
  }
}

module tray_panelized() {
  projection(cut=true) array(tray_w/2) {
    // tray_bottom();
    rotate([0, 0, 90]) tray_l();
    rotate([0, 0, 90]) tray_r();
    rotate([0, 0, 90]) tray_front();
    rotate([0, 0, 90]) tray_back();
    rotate([0, 0, 90]) h_div_1();
    rotate([0, 0, 90]) h_div_1();
    rotate([0, 0, 90]) h_div_2();
    rotate([0, 0, 90]) h_div_2_prime();
    rotate([0, 0, 90]) h_div_3();
    
    rotate([0, 0, 90]) v_div_1();
    rotate([0, 0, 90]) v_div_1();
    rotate([0, 0, 90]) v_div_2();
  }
}

// tray_assembled();

tray_panelized();

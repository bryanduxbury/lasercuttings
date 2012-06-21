include <params.scad>

tray_h = bottom_h / 4;

tray_w = w - material_thickness * 7;
tray_d = d - material_thickness * 3;

h_teeth = 3;
w_teeth = 9;
d_teeth = 9;

h_tooth_width = tray_h / h_teeth / 2;
w_tooth_width = tray_w / w_teeth / 2;
d_tooth_width = tray_d / d_teeth / 2;

module cutout_array(num_teeth, tooth_width) {
  translate([-num_teeth * tooth_width, 0, 0]) {
    for(i=[0:num_teeth-1]) {
      translate([i * 2 * tooth_width + tooth_width, 0, 0]) cube(size=[tooth_width, material_thickness*2, material_thickness*2], center=true);
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
  }
  
}

module tray_side1() {
  color([1, 0, 0]) render() difference() {
    cube(size=[tray_d, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(d_teeth, d_tooth_width);
    translate([-tray_d / 2, 0, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
    translate([tray_d / 2, 0, 0]) rotate([0, 0, 90]) cutout_array(h_teeth, h_tooth_width);
  }
  
}

module tray_side2() {
  color([0/255, 0/255, 255/255]) render() difference() {
    cube(size=[tray_w, tray_h, material_thickness], center=true);
    translate([0, -tray_h / 2, 0]) inverse_cutout_array(w_teeth, w_tooth_width);
    translate([-tray_w / 2, 0, 0]) rotate([0, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
    translate([tray_w / 2, 0, 0]) rotate([0, 0, 90]) inverse_cutout_array(h_teeth, h_tooth_width);
  }
  
}

module tray_assembled() {
  translate([0, 0, -tray_h/2 + material_thickness / 2]) tray_bottom();
  translate([-tray_w / 2 + material_thickness / 2, 0, 0]) rotate([90, 0, 90]) tray_side1();
  translate([tray_w / 2 - material_thickness / 2, 0, 0]) rotate([90, 0, 90]) tray_side1();
  translate([0, -tray_d / 2 + material_thickness / 2, 0]) rotate([90, 0, 0]) tray_side2();
  translate([0, tray_d / 2 - material_thickness / 2, 0]) rotate([90, 0, 0]) tray_side2();
}

tray_assembled();
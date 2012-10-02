material_thickness = 0.5 * 25.4;

feet_height = 25.4;

// fridge dimensions
fridge_total_height = 3 * 12 * 25.4;
fridge_width = 18 * 25.4;
fridge_depth = 18 * 25.4;

fridge_freezer_height = 12 * 25.4;

// stove dimensions
stove_height = 18 * 25.4;
stove_width = 18 * 25.4;
stove_depth = 18 * 25.4;

// sink dimensions
sink_height = 18 * 25.4;
sink_width = 18 * 25.4;
sink_depth = 18 * 25.4;

// microwave
microwave_height = 8 * 25.4;
microwave_width = 36 * 25.4;
microwave_depth = 8 * 25.4;

cupboard_width = 16 * 25.4;

control_panel_width = 4 * 25.4;

microwave_proper_width = microwave_width - cupboard_width - control_panel_width;


// calculated
total_width = fridge_width+stove_width+sink_width;
total_height = fridge_total_height;
total_depth = fridge_depth;

module back_plate() {
  cube(size=[total_width, total_height, material_thickness], center=true);
}

module combined_bottom() {
  union() {
    translate([-total_width/2 + fridge_width/2, 0, 0]) cube(size=[fridge_width, fridge_depth, material_thickness], center=true);

    translate([-total_width/2 + fridge_width + stove_width / 2, 0, 0]) cube(size=[stove_width, stove_depth, material_thickness], center=true);

    translate([-total_width/2 + fridge_width + stove_width + sink_width / 2, 0, 0]) cube(size=[sink_width, sink_depth, material_thickness], center=true);
  }
}

module combined_countertop() {
  union() {
    translate([-(stove_width + sink_width)/2 + stove_width / 2, 0, 0]) cube(size=[stove_width, stove_depth, material_thickness], center=true);
    translate([(stove_width + sink_width)/2 - sink_width / 2, 0, 0]) cube(size=[sink_width, sink_depth, material_thickness], center=true);
  }
}

module combined_top() {
  union() {
    translate([-total_width/2 + fridge_width/2, 0, 0]) cube(size=[fridge_width, fridge_depth, material_thickness], center=true);

    translate([-total_width/2 + fridge_width + microwave_width / 2, fridge_depth / 2 - microwave_depth/2, 0]) cube(size=[microwave_width, microwave_depth, material_thickness], center=true);
  }
}

module fridge_left() {
  cube(size=[fridge_depth, fridge_total_height, material_thickness], center=true);
}

module fridge_right() {
  cube(size=[fridge_depth, fridge_total_height, material_thickness], center=true);
}

module fridge_divider() {
  cube(size=[fridge_width, fridge_depth, material_thickness], center=true);
}

module fridge_bottom() {
  cube(size=[fridge_width, fridge_depth, material_thickness], center=true);
}


module fridge_assembly() {
  translate([-fridge_width/2 + material_thickness/2, 0, 0]) rotate([90, 0, 90]) fridge_left();
  translate([fridge_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) fridge_right();
  translate([0, 0, fridge_total_height / 2 - fridge_freezer_height]) fridge_divider();
  // translate([0, 0, -fridge_total_height / 2 + feet_height]) fridge_divider();
  fridge_door();
  fridge_freezer_door();
}

module stove_top() {
  cube(size=[stove_width, stove_depth, material_thickness], center=true);
}

module stove_bottom() {
  cube(size=[stove_width, stove_depth, material_thickness], center=true);
}

module stove_right() {
  cube(size=[stove_depth, stove_height, material_thickness], center=true);
}

module oven_assembly() {
  // translate([0, 0, stove_height / 2 - material_thickness / 2]) stove_top();
  stove_front();
  translate([stove_width/2, 0, 0]) rotate([90, 0, 90]) stove_right();
  // translate([0, 0, -stove_height / 2 + feet_height]) stove_bottom();
  stove_door();
  stove_control_panel();
}

module sink_top() {
  cube(size=[sink_width, sink_depth, material_thickness], center=true);
}

module sink_right() {
  cube(size=[sink_depth, sink_height, material_thickness], center=true);
}

module sink_bottom() {
  cube(size=[sink_width, sink_depth, material_thickness], center=true);
}


module sink_assembly() {
  // translate([0, 0, sink_height / 2 - material_thickness / 2]) sink_top();
  translate([sink_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) sink_right();
  // translate([0, 0, -sink_height / 2 + feet_height]) sink_bottom();
}

module microwave_cupboard_bottom() {
  cube(size=[microwave_width, microwave_depth, material_thickness], center=true);
}

module microwave_cupboard_right() {
  cube(size=[microwave_depth, microwave_height, material_thickness], center=true);
}

module microwave_right() {
  cube(size=[microwave_depth, microwave_height, material_thickness], center=true);
}

module cupboard_left() {
  cube(size=[microwave_depth, microwave_height, material_thickness], center=true);
}


module microwave_cupboard_assembly() {
  translate([0, 0, -microwave_height/2 + material_thickness/2]) microwave_cupboard_bottom();
  translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) microwave_cupboard_right();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width, 0, 0]) rotate([90, 0, -90]) cupboard_left();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width - control_panel_width, 0, 0]) rotate([90, 0, -90]) microwave_right();

  microwave_control_panel();
}


translate([0, fridge_depth/2, 0]) rotate([90, 0, 0]) color([120/255, 120/255, 120/255]) back_plate();

translate([0, 0, -total_height/2 + feet_height]) color([64/255, 64/255, 64/255]) combined_bottom();

translate([0, 0, total_height/2 - material_thickness/2]) combined_top();

translate([total_width/2 - (sink_width + stove_width) / 2, 0, -total_height/2 + stove_height - material_thickness/2]) combined_countertop();

translate([-total_width/2 + fridge_width/2, 0, 0]) {
  fridge_assembly();
}

translate([-total_width/2 + fridge_width + stove_width / 2, 0, -fridge_total_height/2 + stove_height/2]) 
  color([128/255, 0/255, 0/255]) 
{
  oven_assembly();
}

translate([-total_width/2 + fridge_width + stove_width + sink_width / 2, 0, -fridge_total_height/2 + sink_height/2]) 
  color([0/255, 128/255, 0/255]) 
{
  sink_assembly();
}
  
translate([-total_width/2 + fridge_width + microwave_width / 2, fridge_depth / 2 - microwave_depth / 2, fridge_total_height/2 - microwave_height/2]) 
  color([0/255, 0/255, 128/255]) 
{
  microwave_cupboard_assembly();
}
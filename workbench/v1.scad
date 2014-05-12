// TODO:
// - sculpt the verticals
// - tab slots in surfaces
// - tabs on supports
// - drop supports down below surfaces
// - add cross supports in y axis (maybe just to main desk)
// - drop-in locks on cross supports and verticals
// - t-slots everywhere???
// - mock in the pegboard
// - add outlet box holes
// - bottom shelf needs to fit inside the legs

t = 3/4 * 25.4; // 3/4" plywood / mdf

function feet(ft) = ft * 12 * 25.4;

module _xy() {
  color([255/255, 64/255, 64/255]) linear_extrude(t, center=true) child(0);
}

module _yz() {
  color([64/255, 255/255, 64/255]) rotate([90, 0, 90]) linear_extrude(t, center=true) child(0);
}

module _xz() {
  color([64/255, 64/255, 255/255]) rotate([90, 0, 0]) linear_extrude(t, center=true) child(0);
}


main_desk_height = feet(3.5);
main_desk_depth = feet(2.5);
main_desk_width = feet(6);

top_shelf_height = feet(6);
top_shelf_depth = feet(2);
bottom_shelf_height = feet(0.5);
bottom_shelf_depth = feet(1);

overhang = t;
support_w = 75;
foot_w = 150;

module main_desktop() {
  square(size=[main_desk_width, main_desk_depth], center=true);
}

module top_shelf() {
  square(size=[main_desk_width, top_shelf_depth], center=true);
}

module bottom_shelf() {
  square(size=[main_desk_width, bottom_shelf_depth], center=true);
}

module _outer_leg() {
  // translate([0, top_shelf_height/2, 0]) 
//     square(size=[main_desk_depth, top_shelf_height], center=true);

  assign(surface_support_w = support_w + 2*t) 
  assign(bottom_leg_w = 400)
  assign(support_angle = 30)
  union() {
    // bottom "foot"
    // translate([0, foot_w/2, 0]) 
    //   square(size=[main_desk_depth, foot_w], center=true);

    // bottom leg
    translate([0, (main_desk_height - t)/2, 0]) 
    square(size=[main_desk_depth, main_desk_height - t], center=true);

    // desk support
    // translate([0, main_desk_height - surface_support_w / 2 - t, 0]) 
    //   square(size=[main_desk_depth, surface_support_w], center=true);
  
    // top shelf support
    translate([main_desk_depth/2 - top_shelf_depth/2, top_shelf_height - surface_support_w / 2 - t, 0]) 
      square(size=[top_shelf_depth, surface_support_w], center=true);
  }
}

module left_leg() {
  _outer_leg();
}

module right_leg() {
  scale([1, 1, -1]) _outer_leg();
}

module cross_support() {
  square(size=[main_desk_width, support_w], center=true);
}

module assembled() {
  translate([0, 0, main_desk_height - t/2]) _xy() main_desktop();
  translate([0, main_desk_depth / 2 - top_shelf_depth / 2, top_shelf_height - t/2]) 
    _xy() top_shelf();
  translate([0, main_desk_depth / 2 - bottom_shelf_depth / 2, bottom_shelf_height - t/2]) 
    _xy() bottom_shelf();
    
  translate([-main_desk_width/2 + t/2 + overhang, 0, 0]) 
    _yz() left_leg();
  translate([main_desk_width/2 - t/2 - overhang, 0, 0]) 
    _yz() right_leg();

  // cross supports for bottom shelf
  for (depth=[-1,1]) {
    translate([0, main_desk_depth / 2 - bottom_shelf_depth / 2 + depth * (bottom_shelf_depth/2 - overhang - t/2), bottom_shelf_height - support_w/2 - t]) 
      _xz() cross_support();
  }
  
  // cross supports for main desktop
  for (depth=[-1,1]) {
    translate([0, depth * (main_desk_depth/2 - overhang - t/2), main_desk_height - support_w/2 - t]) 
      _xz() cross_support();
  }
  
  // cross supports for top shelf
  for (depth=[-1,1]) {
    translate([0, main_desk_depth / 2 - top_shelf_depth / 2 + depth * (top_shelf_depth/2 - overhang - t/2), top_shelf_height - support_w/2 - t]) 
      _xz() cross_support();
  }
}

assembled();
use <compartment_organizer.scad>;

drawer_slide_t = 1/2;
drawer_slide_w = 1;

caster_h = 3.5;

overall_h = 34;
overall_d = 22;

top_shelf_height = 8;

d_s = 1/8; // spacing between drawers and other stuff
d_t = 1/2; // drawer material thickness
d_w = compartment_organizer_w() + d_t * 2 + drawer_slide_t * 2;
d_d = compartment_organizer_d() + d_t * 2;
d_h1 = 1.5;
d_h = d_t + compartment_organizer_h();

c_t = 3/4; // carcass plywood thickness
c_d = overall_d - c_t * 2;
c_w = 3 * d_w + 4 * c_t;
c_h = overall_h - caster_h - c_t; // total carcass height
c_outside_h = c_h - c_t / 2; // outside panel height
c_inside_h = c_h - top_shelf_height - c_t; // height of inside panels

door_h = c_h - d_s - top_shelf_height - c_t/2;
door_w = c_w / 2 - d_s / 2;
door_strip_w = 2.5;

module _caster() {
  color("black")
  rotate([90, 0, 0])
    cylinder(r=caster_h/2, h=2, center=true, $fn=36);
}

module _drawer_assembly() {
  translate([0, d_d / 2, 0]) {
    color("GreenYellow")
    translate([0, -d_d / 2 + d_t / 2, d_h1/2])
      cube(size=[d_w - d_s * 2, d_t, d_h1], center=true);

    color("tan")
    translate([0, 0, d_t/2])
      cube(size=[compartment_organizer_w() + d_t,
        compartment_organizer_d() + d_t, d_t], center=true);

    for (x=[-1,1]) {
      translate([x * (d_w / 2 - drawer_slide_t - d_t / 2), 0, d_h1 / 2])
        cube(size=[d_t, d_d - d_t, d_h1], center=true);
    }

    color("GreenYellow")
    translate([0, d_d / 2 - d_t / 2, d_h1/2])
      cube(size=[d_w - 2 * drawer_slide_t, d_t, d_h1], center=true);

    translate([0, 0, compartment_organizer_h() / 2 + d_t])
      compartment_organizer();
  }
}

module carcass() {
  translate([0, 0, c_t/2])
    cube(size=[c_w, c_d, c_t], center=true);

  color("CadetBlue")
  for (x=[-1,1]) {
    translate([x * (c_w / 2 - c_t / 2), 0, c_t/2 + c_outside_h/2])
      cube(size=[c_t, c_d, c_outside_h], center=true);

    translate([x * (d_w / 2 + c_t / 2), 0, c_t/2 + c_inside_h/2])
      cube(size=[c_t, c_d, c_inside_h], center=true);
  }

  color("Cyan")
  translate([0, 0, c_h - top_shelf_height - c_t / 2])
    cube(size=[c_w  - c_t, c_d, c_t], center=true);

  rear_panel_h = top_shelf_height + c_t/2;
  rear_panel_w = c_w;
  color("SlateBlue")
  translate([0, c_d/2 + c_t/2, c_h - rear_panel_h/2]) 
    cube(size=[c_w, c_t, rear_panel_h], center=true);
}

module door() {
  translate([door_w / 2, -c_t/2, door_h/2]) 
  for (a=[-1,1]) {
    color("RosyBrown")
    translate([a * (door_w / 2 - door_strip_w / 2), 0, 0]) 
      cube(size=[door_strip_w, c_t, door_h - 2 * door_strip_w], center=true);

    color("Goldenrod")
    translate([0, 0, a * (door_h / 2 - door_strip_w / 2)]) 
      cube(size=[door_w, c_t, door_strip_w], center=true);
  }
}

module assembled() {
  for (x=[-1,1], y=[-1,1]) {
    translate([x * (c_w / 2 - caster_h / 2), y * (overall_d / 2 - caster_h/2), caster_h / 2])
      _caster();
  }

  translate([0, 0, caster_h]) 
    carcass();

  translate([0, 0, c_inside_h + c_t]) 
  for (x=[-1:1], z=[-3:0]) {
    translate([x * (d_w + c_t), -c_d/2, z * (d_h + d_s)])
      _drawer_assembly();
  }
  
  for (x=[-1,1], y=[-1,1]) {
    translate([x * (c_w/2), y * (c_d/2), caster_h]) 
      scale([-x, -y, 1]) door();
  }

}


assembled();


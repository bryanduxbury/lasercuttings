material_thickness = 3;
piece_size = 22;
piece_spacing = 24;
line_width = 1.5;

count = 9;

total_height = 2*25.4;
leg_height = 1.25*25.4;
leg_top_width = 25.4;
leg_bottom_width = .75 * 25.4;

corner_radius = 5;

side_dim = (count+1)*piece_spacing;

module ext(h=material_thickness) {
  translate([0, 0, -material_thickness/2]) linear_extrude(height=h) child(0);
}

module deck() {
  difference() {
    union() {
      square(size=[side_dim-2*corner_radius, side_dim-2*corner_radius], center=true);
      for (a=[0:3]) rotate([0, 0, 90*a]) {
        translate([(side_dim-2*corner_radius)/2, (side_dim-2*corner_radius)/2, 0]) circle(r=corner_radius, $fn=36);
        translate([(side_dim-2*corner_radius)/2 + corner_radius/2, 0, 0]) square(size=[corner_radius, (side_dim-2*corner_radius)], center=true);
      }
    }

    for (x=[-floor(count/2):floor(count/2)]) {
      for (y=[-floor(count/2):floor(count/2)]) {
        translate([x*piece_spacing, y*piece_spacing, 0]) circle(r=piece_size/2 - 2, center=true, $fn=36);
      }
    }

    for (a=[0:3]) rotate([0, 0, 90*a]) {
      translate([side_dim/2 - corner_radius - material_thickness/2, side_dim/2 - corner_radius - material_thickness/2, 0]) {
        translate([-10 - material_thickness/2, 0, 0]) square(size=[10, material_thickness], center=true);
        translate([0, -10 - material_thickness/2, 0]) square(size=[material_thickness, 10], center=true);
      }
    }
  }
}

module side_base() {
  polygon(points=[
    [-side_dim/2, -total_height/2],
    [-side_dim/2 + leg_bottom_width, -total_height/2],
    [-side_dim/2 + leg_top_width, -total_height/2 + leg_height],
    [side_dim/2 - leg_top_width, -total_height/2 + leg_height],
    [side_dim/2 - leg_bottom_width, -total_height/2],
    [side_dim/2, -total_height/2],
    [side_dim/2, total_height/2 - material_thickness],
    [side_dim/2 - corner_radius - material_thickness - 5, total_height/2 - material_thickness],
    [side_dim/2 - corner_radius - material_thickness - 5, total_height/2],
    [side_dim/2 - corner_radius - material_thickness - 15, total_height/2],
    [side_dim/2 - corner_radius - material_thickness - 15, total_height/2 - material_thickness],
    [-side_dim/2 + corner_radius + material_thickness + 15, total_height/2 - material_thickness],
    [-side_dim/2 + corner_radius + material_thickness + 15, total_height/2],
    [-side_dim/2 + corner_radius + material_thickness + 5, total_height/2],
    [-side_dim/2 + corner_radius + material_thickness + 5, total_height/2 - material_thickness],
    [-side_dim/2, total_height/2 - material_thickness],
  ]);
}

module front_back() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim/2 - corner_radius - material_thickness/2), -total_height/2, 0]) square(size=[material_thickness, total_height], center=true);
    }
  }
}

module side() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim/2 - corner_radius - material_thickness/2), total_height/2, 0]) square(size=[material_thickness, total_height], center=true);
    }
  }
}

module split_circle() {
  difference() {
    circle(r=piece_size/2 + 3, $fn=36);
    circle(r=piece_size/2 + 3 - line_width, $fn=36);
    for (a=[0:1]) {
      rotate([0, 0, a*90]) square(size=[line_width*3, 2*(piece_size/2 + 3 + 1)], center=true);
    }
  }
}

module grid() {
  for (a=[0,90]) rotate([0, 0, a]) {
    for (x=[-floor(count/2):floor(count/2)]) {
      translate([x*piece_spacing, 0, 0]) square(size=[line_width, (count-1)*piece_spacing], center=true);
    }
  }

  split_circle();

  for (a=[0:3]) rotate([0, 0, 90*a]) translate([(count-1)/4*piece_spacing, (count-1)/4*piece_spacing, 0]) intersection() {
    split_circle();
    square(size=[piece_size/2 + 3 + 1, piece_size/2 + 3 + 1]);
  }
  
  
}

module assembled() {
  translate([0, 0, total_height/2 - material_thickness/2]) ext() deck();

  for (d=[-1,1]) {
    translate([0, d * (side_dim/2 - corner_radius - material_thickness/2), 0]) rotate([90, 0, 0]) color([128/255, 0/255, 0/255]) ext() front_back();
    translate([d * (side_dim/2 - corner_radius - material_thickness/2), 0, 0]) rotate([90, 0, 90]) color([128/255, 128/255, 0/255]) ext() side();
  }
}

module panelized() {
  deck();
  for (i=[0,1]) {
    rotate([0, 0, 180*i]) translate([side_dim / 2 + 5 + total_height/2, 0, 0]) {
      rotate([0, 0, -90]) front_back();
    }
    rotate([0, 0, 180*i]) translate([0, side_dim / 2 + 5 + total_height/2, 0]) {
      side();
    }
  }
}

// assembled();

// panelized();


// translate([0, 0, total_height/2 + 10]) color([0/255, 0/255, 0/255]) ext() 
grid();
// parameters

material_thickness = 5.2;
piece_size = 22;
piece_spacing = 24;
line_width = 1.5;
count = 9;
leg_height = 0.25*25.4;
leg_top_width = 25.4;
leg_bottom_width = .75 * 25.4;
bottom_gutter = 2;

drawer_height = 1.5 * 25.4;
corner_radius = 5;

laser_beam_width = 0.005 * 25.4;
l = laser_beam_width;
tab_width = 10;


// computed params
t = material_thickness;

function total_height() = leg_height + drawer_height + t + 2 + 2*t;
function side_dim() = (count+1)*piece_spacing;

module ext(h=material_thickness) {
  translate([0, 0, -h/2]) linear_extrude(height=h) child(0);
}

module deck_base() {
  union() {
    square(size=[side_dim()+l, side_dim()-corner_radius*2], center=true);
    square(size=[side_dim()-corner_radius*2, side_dim()+l], center=true);
    for (a=[0:3]) rotate([0, 0, 90*a]) {
      translate([(side_dim()-2*corner_radius)/2, (side_dim()-2*corner_radius)/2, 0]) circle(r=corner_radius, $fn=72);
    }
  }
}

module deck() {
  difference() {
    deck_base();

    for (x=[-floor(count/2):floor(count/2)]) {
      for (y=[-floor(count/2):floor(count/2)]) {
        translate([x*piece_spacing, y*piece_spacing, 0]) circle(r=piece_size/2 - 2, center=true, $fn=36);
      }
    }
  }
}

module under_deck() {
  difference() {
    deck_base();

    for (a=[0:3]) rotate([0, 0, 90*a]) translate([side_dim()/2 - corner_radius - t/2, 0, 0]) {
      for (i=[-1,1]) {
        translate([0, i * (side_dim()/2 - corner_radius - 2*t - tab_width/2), 0]) square(size=[material_thickness-l, tab_width-l], center=true);
      }
    }
    for (a=[0,2]) rotate([0, 0, 90*a]) translate([side_dim()/2 - corner_radius - t/2, 0, 0]) {
      translate([0, i * (side_dim()/2 - corner_radius - 2*t - tab_width/2), 0]) square(size=[material_thickness-l, tab_width-l], center=true);
    }
    
  }
}

function bottom_dim() = side_dim() - corner_radius*2 - material_thickness*2+l;

module bottom() {
  union() {
    square(size=[bottom_dim(), bottom_dim()], center=true);
    // for (a=[0:3]) {
    //   for (y=[-1:1]) {
    //     rotate([0, 0, a*90]) 
    //       translate([(side_dim() - corner_radius*2 - material_thickness*2)/2 + material_thickness/2 - laser_beam_width, y* (side_dim()/2 - corner_radius - material_thickness - 10), 0]) 
    //         square(size=[material_thickness-laser_beam_width, 10], center=true);
    //   }
    // }
  }
}

module outside_base() {
  polygon(points=[
      [-side_dim()/2 + corner_radius, -total_height/2],
      [-side_dim()/2 + leg_bottom_width, -total_height/2],
      [-side_dim()/2 + leg_top_width, -total_height/2 + leg_height],
      [side_dim()/2 - leg_top_width, -total_height/2 + leg_height],
      [side_dim()/2 - leg_bottom_width, -total_height/2],
      [side_dim()/2 - corner_radius, -total_height/2],
      [side_dim()/2 - corner_radius, total_height/2 - material_thickness],
      [-side_dim()/2 + corner_radius, total_height/2 - material_thickness],
    ]);
}

module side_base() {
  difference() {
    polygon(points=[
        [-side_dim()/2 + corner_radius, -total_height/2],
        [-side_dim()/2 + leg_bottom_width, -total_height/2],
        [-side_dim()/2 + leg_top_width, -total_height/2 + leg_height],
        [side_dim()/2 - leg_top_width, -total_height/2 + leg_height],
        [side_dim()/2 - leg_bottom_width, -total_height/2],
        [side_dim()/2 - corner_radius, -total_height/2],
        [side_dim()/2 - corner_radius, total_height/2 - material_thickness],
        [side_dim()/2 - corner_radius - material_thickness - 5, total_height/2 - material_thickness],
        [side_dim()/2 - corner_radius - material_thickness - 5, total_height/2],
        [side_dim()/2 - corner_radius - material_thickness - 15, total_height/2],
        [side_dim()/2 - corner_radius - material_thickness - 15, total_height/2 - material_thickness],

        [5, total_height/2 - material_thickness],
        [5, total_height/2],
        [-5, total_height/2],
        [-5, total_height/2 - material_thickness],


        [-side_dim()/2 + corner_radius + material_thickness + 15, total_height/2 - material_thickness],
        [-side_dim()/2 + corner_radius + material_thickness + 15, total_height/2],
        [-side_dim()/2 + corner_radius + material_thickness + 5, total_height/2],
        [-side_dim()/2 + corner_radius + material_thickness + 5, total_height/2 - material_thickness],
        [-side_dim()/2 + corner_radius, total_height/2 - material_thickness],
      ]);
      
    translate([0, -total_height/2 + leg_height + material_thickness, 0]) {
      square(size=[10, material_thickness-laser_beam_width], center=true);
      for (i=[0:1]) {
        rotate([0, 0, i*180]) translate([side_dim()/2 - corner_radius - material_thickness - 10, 0, 0]) square(size=[10, material_thickness-laser_beam_width], center=true);
      }
      
    }
  }
}

module front_back() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim()/2 - corner_radius - material_thickness/2), -total_height/2, 0]) 
        square(size=[material_thickness+0.1, total_height], center=true);
    }
    
    // translate([0, total_height/2 - 2* material_thickness - (total_height - leg_height - 4* material_thickness)/2 , 0]) square(size=[side_dim - corner_radius*2 - material_thickness*4, total_height - leg_height - 3* material_thickness], center=true);
  }
}

module side() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim()/2 - corner_radius - material_thickness/2), total_height/2, 0]) 
        square(size=[material_thickness + 0.1, total_height], center=true);
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

module drawer_face() {
  outside_base();
}

module drawer_mockup() {
  difference() {
    intersection() {
      cylinder(r=(side_dim() - corner_radius*2 - material_thickness*4)/2, h=drawer_total_height(), center=true, $fn=72);
      translate([side_dim()/2, 0, 0]) cube(size=[side_dim(), side_dim(), drawer_total_height()], center=true);
    }
    translate([0, 0, material_thickness]) intersection() {
      cylinder(r=(side_dim() - corner_radius*2 - material_thickness*4)/2 - material_thickness, h=drawer_total_height()+0.1, center=true, $fn=72);
      translate([side_dim()/2 + material_thickness, 0, 0]) cube(size=[side_dim(), side_dim(), drawer_total_height()+0.1], center=true);
    }
  }
}

module drawer_assembly() {
  color([128/255, 128/255, 128/255]) render() drawer_mockup();
}

module grid() {
  for (a=[0,90]) rotate([0, 0, a]) {
    for (x=[-floor(count/2):floor(count/2)]) {
      translate([x*piece_spacing, 0, 0]) square(size=[line_width, (count-1)*piece_spacing + line_width], center=true);
    }
  }

  circle(r=line_width*2, $fn=36);

  for (a=[0:3]) rotate([0, 0, 90*a]) translate([(count-1)/4*piece_spacing, (count-1)/4*piece_spacing, 0]) intersection() {
    circle(r=line_width*2, $fn=36);
  }
  
  
}

module assembled() {
  translate([0, 0, total_height()/2 - t/2]) ext() deck();
  translate([0, 0, total_height()/2 - t/2 - t]) color([192/255, 168/255, 128/255]) ext() under_deck();
  translate([0, 0, -total_height()/2 + leg_height + bottom_gutter + t/2]) ext() bottom();

  // for (d=[-1,1]) {
  //   translate([0, d * (side_dim()/2 - corner_radius - material_thickness/2), -material_thickness]) rotate([90, 0, 0]) color([128/255, 0/255, 0/255]) ext() front_back();
  //   translate([d * (side_dim()/2 - corner_radius - material_thickness/2), 0, -material_thickness]) rotate([90, 0, 90]) color([128/255, 128/255, 0/255]) ext() side();
  // }
  // 
  // for (i=[0:1]) {
  //   rotate([0, 0, i*180]) translate([side_dim()/2 - corner_radius - material_thickness, 0, 0]) rotate([0, 0, -180]) drawer_assembly();
  // }
}

module panelized() {
  deck();
  translate([side_dim() + 10 + total_height, 0, 0]) under_deck();
  for (i=[0,1]) {
    rotate([0, 0, 180*i]) translate([side_dim() / 2 + 5 + total_height/2, 0, 0]) {
      rotate([0, 0, -90]) front_back();
    }
    rotate([0, 0, 180*i]) translate([0, side_dim() / 2 + 5 + total_height/2, 0]) {
      side();
    }
  }
}

assembled();

// panelized();


// translate([0, 0, total_height/2 + 10]) color([0/255, 0/255, 0/255]) ext() 
// grid();
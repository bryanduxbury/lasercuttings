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

drawer_stack_multiple = 9 ;
corner_radius = 5;

laser_beam_width = 0.005 * 25.4;
l = laser_beam_width;
tab_width = 10;


// computed params
t = material_thickness;

function side_dim() = (count+1)*piece_spacing;

function drawer_width() = side_dim() - corner_radius*2 - t*6 - tab_width*2;
function drawer_height() = drawer_stack_multiple*t;
function bottom_height() = leg_height + drawer_height() + t + bottom_gutter + t;
function total_height() = bottom_height();

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
      square(size=[t-l, tab_width-l], center=true);
    }

    for (a=[1,3]) rotate([0, 0, 90*a]) translate([side_dim()/2 - corner_radius - t - 2.5, 0, 0]) {
      circle(r=2.5, $fn=36);
    }
  }
}

function bottom_dim() = side_dim() - corner_radius*2 - material_thickness*2+l;

module bottom() {
  union() {
    square(size=[bottom_dim(), bottom_dim()], center=true);
    for (a=[0:3]) {
      for (y=[-1:1]) {
        rotate([0, 0, a*90]) 
          translate([bottom_dim()/2 + t/2 - l, y* (bottom_dim()/2 - tab_width), 0]) 
            square(size=[material_thickness-laser_beam_width, tab_width], center=true);
      }
    }
  }
}

module side_base() {
  difference() {
    polygon(points=[
        [-side_dim()/2 + corner_radius, -bottom_height()/2],
        [-side_dim()/2 + leg_bottom_width, -bottom_height()/2],
        [-side_dim()/2 + leg_top_width, -bottom_height()/2 + leg_height],
        [side_dim()/2 - leg_top_width, -bottom_height()/2 + leg_height],
        [side_dim()/2 - leg_bottom_width, -bottom_height()/2],
        [side_dim()/2 - corner_radius, -bottom_height()/2],
        [side_dim()/2 - corner_radius, bottom_height()/2 - t],
        [side_dim()/2 - corner_radius - 2 * t, bottom_height()/2 - t],
        [side_dim()/2 - corner_radius - 2 * t, bottom_height()/2],
        [side_dim()/2 - corner_radius - 2 * t - tab_width, bottom_height()/2],
        [side_dim()/2 - corner_radius - 2 * t - tab_width, bottom_height()/2 - t],

        [tab_width/2, bottom_height()/2 - t],
        [tab_width/2, bottom_height()/2],
        [-tab_width/2, bottom_height()/2],
        [-tab_width/2, bottom_height()/2 - t],

        [-side_dim()/2 + corner_radius + 2 * t + tab_width, bottom_height()/2 - t],
        [-side_dim()/2 + corner_radius + 2 * t + tab_width, bottom_height()/2],
        [-side_dim()/2 + corner_radius + 2 * t, bottom_height()/2],
        [-side_dim()/2 + corner_radius + 2 * t, bottom_height()/2 - t],
        [-side_dim()/2 + corner_radius, bottom_height()/2 - t],
      ]);
      
    translate([0, -bottom_height()/2 + leg_height + bottom_gutter + t/2, 0]) {
      for (i=[-1:1]) {
        translate([i*(side_dim()/2 - corner_radius - t - tab_width), 0, 0]) square(size=[tab_width-l, t-l], center=true);
      }
    }
  }
}

module front_back() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim()/2 - corner_radius - material_thickness/2), -bottom_height()/2, 0]) 
        square(size=[material_thickness+0.1, bottom_height()], center=true);
    }

    translate([0, bottom_height()/2 - t, 0]) 
      square(size=[drawer_width(), 2*(drawer_height())], center=true);
  }
}

module side() {
  difference() {
    side_base();
    for (x=[-1,1]) {
      translate([x*(side_dim()/2 - corner_radius - material_thickness/2), bottom_height()/2, 0]) 
        square(size=[material_thickness + 0.1, bottom_height()], center=true);
    }
  }
}

module drawer_mockup() {
  difference() {
    intersection() {
      cylinder(r=drawer_width()/2, h=drawer_height(), center=true, $fn=72);
      translate([side_dim()/2, 0, 0]) cube(size=[side_dim(), side_dim(), drawer_height()], center=true);
    }
    translate([0, 0, material_thickness]) intersection() {
      cylinder(r=drawer_width()/2 - material_thickness, h=drawer_height()+0.1, center=true, $fn=72);
      translate([side_dim()/2 + material_thickness, 0, 0]) cube(size=[side_dim(), side_dim(), drawer_height()+0.1], center=true);
    }
  }
}

module drawer_bottom() {
  difference() {
    intersection() {
      square(size=[drawer_width(), drawer_width()/2], center=true);
      translate([0, -drawer_width()/4, 0]) circle(r=drawer_width()/2, $fn=250);
    }
    translate([0, -drawer_width()/4 + t + 2.5, 0]) circle(r=2.5, $fn=36);
  }
}

module drawer_wall() {
  union() {
    difference() {
      intersection() {
        square(size=[drawer_width(), drawer_width()/2], center=true);
        translate([0, -drawer_width()/4, 0]) circle(r=drawer_width()/2, $fn=250);
      }
      intersection() {
        translate([0, t, 0]) square(size=[drawer_width(), drawer_width()/2], center=true);
        translate([0, -drawer_width()/4, 0]) circle(r=drawer_width()/2-t, $fn=250);
      }
    }
    translate([0, -drawer_width()/4 + t + 2.5, 0]) circle(r=5, $fn=36);
    union() {
      translate([0, -drawer_width()/4 + t, 0]) square(size=[10, 5], center=true);
      for(i=[0,1]) rotate([0, i*180, 0]) translate([-5, -drawer_width()/4 + t, 0]) {
        difference() {
          translate([-1.25, 1.25, 0]) square(size=[2.5, 2.5], center=true);
          translate([-2.5, 2.5, 0]) circle(r=2.5, $fn=36);
        }
      }
    }
  }
}


module drawer_assembly() {
  translate([0, 0, -drawer_height()/2 + t/2]) color([128/255, 128/255, 128/255]) ext() drawer_bottom();
  translate([0, 0, -drawer_height()/2 + t + t/2]) {
    for (i=[0:(drawer_stack_multiple-2)]) {
      translate([0, 0, i*t]) color([128/255, 128/255, (128 + 128/(drawer_stack_multiple - 2) * i)/255]) ext() drawer_wall();
    }
  }
  translate([0, -drawer_width()/4 + t + 2.5, 0]) translate([0, 0, -drawer_height()/2 + t * (drawer_stack_multiple) + t/2]) ext() circle(r=2.5, $fn=36);
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
  %translate([0, 0, total_height()/2 - t/2]) ext() deck();
  %translate([0, 0, total_height()/2 - t/2 - t]) color([192/255, 168/255, 128/255]) ext() under_deck();
  translate([0, 0, -total_height()/2 + leg_height + bottom_gutter + t/2 - t]) ext() bottom();

  for (d=[-1,1]) {
    translate([0, d * (side_dim()/2 - corner_radius - material_thickness/2), -material_thickness]) rotate([90, 0, 0]) color([128/255, 0/255, 0/255]) ext() front_back();
    translate([d * (side_dim()/2 - corner_radius - material_thickness/2), 0, -material_thickness]) rotate([90, 0, 90]) color([128/255, 128/255, 0/255]) ext() side();
  }
  
  for (i=[0:1]) {
    rotate([0, 0, i*180]) 
      translate([0, -(side_dim()/2 - corner_radius - t - 2.5), -total_height()/2 + leg_height + bottom_gutter + drawer_height() / 2]) 
        rotate([0, 0, 0]) translate([0, drawer_width()/4 - t - 2.5, 0]) drawer_assembly();
  }
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
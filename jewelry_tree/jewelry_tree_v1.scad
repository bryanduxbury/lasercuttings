t = 5;
l = 0.005 * 25.4;

h = 15 * 25;
w = 11 * 25;
d = 4.5 * 25;
skinny_d = 35;

foot_height = 15;
foot_width = 25;
tray_height = 25;
top_height = 25;
molding_height = 15;

frame_width = 15;

dowel_d = 12.5; // half inch dowel

//\             / molding_height }
// -------------                  |
// |           | top_height       |
// -------------                  |
// |           |                  |
// |           |                  |
// |           |                  |
// =============                  |
// |           |                   }
// |           |                    } h
// |           |                   }
// =============                  |
// |           |                  |
// |           |                  |
// |           |                  |
// -------------                  |
// |           | tray_height      |
// -------------                  |
// -------------                  |
// | /       \ | foot_height     }

module _xy() {
  color("blue") linear_extrude(height=t, center=true) child(0);
}

module _xz() {
  color("red") rotate([90, 0, 0]) linear_extrude(height=t, center=true) child(0);
}

module _yz() {
  color("green") rotate([90, 0, 90]) linear_extrude(height=t, center=true) child(0);
}

// todo: cut out dowel slots
module pillar() {
  union() {
    translate([0, h/2, 0]) 
      square(size=[skinny_d+l, h+l], center=true);
    translate([0, (foot_height + tray_height)/2, 0]) 
      square(size=[d+l, foot_height + tray_height + l], center=true);
  }
}

// todo: add top hanger peg holes
// todo: add cutouts for dowels
module frame() {
  difference() {
    translate([0, h/2, 0]) square(size=[w+l, h+l], center=true);
    translate([0, h/2 - tray_height/2, 0]) square(size=[w - 2 * frame_width - l, h - top_height - molding_height - foot_height - l], center=true);
  }
}

module tray_bottom() {
  assign(width = w - 2 * t)
  difference() {
    square(size=[width+l, d-2*t+l], center=true);
    for (x=[-1,1]) {
      translate([width / 2 * x, 0, 0]) square(size=[(frame_width-t) * 2, skinny_d - l], center=true);
    }
    
  }
}

module top() {
  square(size=[w+2*t+l, skinny_d+2*t+l], center=true);
}

// todo: curve out the bottom
module frontback_inner() {
  assign(height = tray_height + foot_height){
    translate([0, height/2, 0]) 
      square(size=[w+l, height + l], center=true);
  }
}

module bottom_frontback_veneer() {
  assign(height = tray_height + foot_height - molding_height){
    translate([0, height/2, 0]) 
      square(size=[w+2*t+l, height + l], center=true);
  }
}

module bottom_leftright_veneer() {
  assign(height = tray_height + foot_height - molding_height){
    translate([0, height/2, 0]) 
      square(size=[d+2*t+l, height + l], center=true);
  }
}

module top_frontback_veneer() {
  assign(height = molding_height){
    translate([0, height/2, 0]) 
      square(size=[w+2*t+l, height + l], center=true);
  }
}

module top_leftright_veneer() {
  assign(height = molding_height){
    translate([0, height/2, 0]) 
      square(size=[skinny_d+2*t+l, height + l], center=true);
  }
}

module dowel() {
  cylinder(r=dowel_d/2, h=w+2*t, center=true);
}

module assembled() {
  for (x=[-1,1]) {
    translate([(w/2 - t/2) * x, 0, 0]) _yz() pillar();
    translate([(w/2 + t/2) * x, 0, 0]) _yz() bottom_leftright_veneer();
    translate([(w/2 + t/2) * x, 0, h-molding_height]) 
      _yz() top_leftright_veneer();
  }

  for (y=[-1,1]) {
    translate([0, (skinny_d/2-t/2) * y, 0]) _xz() frame();
    translate([0, (d / 2 - t/2) * y, 0]) _xz() frontback_inner();
    translate([0, (d / 2 + t/2) * y, 0]) _xz() bottom_frontback_veneer();
    translate([0, (skinny_d / 2 + t/2) * y, h - molding_height]) 
      _xz() top_frontback_veneer();
  }

  translate([0, 0, h-t/2]) _xy() top();
  translate([0, 0, foot_height+t/2]) _xy() tray_bottom();
  
  assign(bottom = foot_height + tray_height)
  assign(hanging_h = h - foot_height - tray_height - top_height - molding_height)
  translate([0, -skinny_d/2 - dowel_d/2, 0]) {
    translate([0, 0, bottom + hanging_h / 3]) 
      rotate([0, 90, 0]) dowel();
    translate([0, 0, bottom + hanging_h / 3 * 2]) 
      rotate([0, 90, 0]) dowel();
  }
  
}

assembled();
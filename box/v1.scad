
// assign(alpha=400)
// assign(beta=150)
// assign(gamma=900)
// assign(delta=100)
// intersection() {
//   linear_extrude(height=500) {
//     intersection_for(a = [0:3]) {
//       rotate([0, 0, a * 90]) translate([0, alpha-beta, 0]) circle(r=alpha, $fn=240);
//     }
//   }
//   translate([0, 0, -(gamma-delta)]) sphere(r=gamma, $fn=240);
// }


outside_w = 50;
base_height=15;
lid_height=5;
wall_thickness=3;

alpha = 100;
beta = outside_w/2;
gamma = 150;

module base() {
  difference() {
    linear_extrude(height=base_height) {
      intersection_for(a = [0:3]) {
        rotate([0, 0, a * 90]) translate([0, alpha-beta, 0]) circle(r=alpha, $fn=240);
      }
    }
    translate([0, 0, wall_thickness]) linear_extrude(height=base_height) {
      intersection_for(a = [0:3]) {
        rotate([0, 0, a * 90]) translate([0, (alpha-wall_thickness)-(beta-wall_thickness), 0]) circle(r=alpha-wall_thickness, $fn=240);
      }
    }
  }
  
}

module lid() {
  union() {
    intersection() {
      linear_extrude(height=base_height) {
        intersection_for(a = [0:3]) {
          rotate([0, 0, a * 90]) translate([0, alpha-beta, 0]) circle(r=alpha, $fn=240);
        }
      }
      translate([0, 0, -(gamma-lid_height)]) difference() {
        sphere(r=gamma, $fn=360);
        translate([0, 0, -lid_height]) cube(size=[gamma*2+1, gamma*2+1, gamma*2-lid_height], center=true);
      }
    }
    
    // lip on the bottom of the lid to make it stay in place
    // translate([0, 0, -1]) linear_extrude(height=2) {
    //   intersection_for(a = [0:3]) {
    //     rotate([0, 0, a * 90]) translate([0, (alpha - wall_thickness - 1)-(beta - wall_thickness - 1), 0]) circle(r=(alpha - wall_thickness - 1), $fn=240);
    //   }
    // }
  }
}

translate([0, 0, base_height]) !lid();
base();

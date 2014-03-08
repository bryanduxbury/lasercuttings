
// assign(side_curve_circle_radius=400)
// assign(beta=150)
// assign(lid_curve_sphere_radius=900)
// assign(delta=100)
// intersection() {
//   linear_extrude(height=500) {
//     intersection_for(a = [0:3]) {
//       rotate([0, 0, a * 90]) translate([0, side_curve_circle_radius-beta, 0]) circle(r=side_curve_circle_radius, $fn=240);
//     }
//   }
//   translate([0, 0, -(lid_curve_sphere_radius-delta)]) sphere(r=lid_curve_sphere_radius, $fn=240);
// }


outside_w = 112;
base_height=31;
lid_height=10;
wall_thickness=5;

side_curve_circle_radius = 300;
beta = outside_w/2;
// lid_curve_sphere_radius must be bigger than side_curve_circle_radius!
lid_curve_sphere_radius = 350;

finishing_tool_r = 0.25 * 25.4;

// width, side radius, corner radius
module _profile(w, rs, rc) {
  minkowski() {
    intersection_for(a = [0:3]) {
      rotate([0, 0, a * 90]) 
        translate([0, w/2-rs, 0]) 
          circle(r=rs-rc, $fn=480);
    }
    circle(r=rc, $fn=72);
  }
}

module base() {
  difference() {
    linear_extrude(height=base_height) {
      _profile(outside_w, side_curve_circle_radius, finishing_tool_r/2);
    }
    translate([0, 0, wall_thickness]) linear_extrude(height=base_height) {
      _profile(outside_w-wall_thickness*2, side_curve_circle_radius-wall_thickness, finishing_tool_r);
    }
  }
}

module lid() {
  union() {
    intersection() {
      linear_extrude(height=base_height) {
        _profile(outside_w, side_curve_circle_radius, finishing_tool_r/2);
      }
      translate([0, 0, -(lid_curve_sphere_radius-lid_height)]) difference() {
        sphere(r=lid_curve_sphere_radius, $fn=360);
        translate([0, 0, -lid_height]) cube(size=[lid_curve_sphere_radius*2+1, lid_curve_sphere_radius*2+1, lid_curve_sphere_radius*2-lid_height], center=true);
      }
    }

    // lip on the bottom of the lid to make it stay in place
    translate([0, 0, -1]) linear_extrude(height=2) {
      _profile(outside_w-wall_thickness*2 - 0.2, side_curve_circle_radius-wall_thickness, finishing_tool_r);
    }
  }
}

translate([0, 0, base_height + 5]) !lid();
base();

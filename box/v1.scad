base_height=18;
lid_height=10;
wall_thickness=8;
floor_thickness = 3;
outside_w = 75 + 2 * wall_thickness;

foot_w = 15;
foot_h = 1;
foot_thickness = 3;

side_curve_circle_radius = 300;
// lid_curve_sphere_radius must be bigger than side_curve_circle_radius!
lid_curve_sphere_radius = 350;

finishing_tool_r = 0.25 * 25.4 / 2;

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
      _profile(outside_w, side_curve_circle_radius, finishing_tool_r);
    }

    // box cavity
    translate([0, 0, floor_thickness]) linear_extrude(height=base_height) {
      _profile(outside_w-wall_thickness*2, side_curve_circle_radius-wall_thickness, finishing_tool_r);
    }

    // feet on the bottom of the box
    linear_extrude(height=foot_h*2, center=true) {
      _profile(outside_w-2*foot_thickness, side_curve_circle_radius-foot_thickness, finishing_tool_r);
    }

    for (a=[0:1]) {
      rotate([0, 0, a*90]) 
        scale([(outside_w-2*foot_w)/2, 1, foot_h]) rotate([90, 0, 0]) 
          cylinder(r=1, h=outside_w*2, center=true, $fn=120);
    }
  }
}

module lid() {
  difference() {
    union() {
      intersection() {
        linear_extrude(height=base_height) {
          _profile(outside_w, side_curve_circle_radius, finishing_tool_r);
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
    
    // carve-out on underside of lid
    // render()
//     intersection() {
//       translate([0, 0, -base_height/2]) linear_extrude(height=base_height) {
//         _profile(outside_w - wall_thickness * 2 - 6, side_curve_circle_radius - wall_thickness - 3, finishing_tool_r/2);
//       }
//       translate([0, 0, -(lid_curve_sphere_radius-lid_height+wall_thickness)]) difference() {
//         sphere(r=lid_curve_sphere_radius, $fn=360);
//         translate([0, 0, -lid_height]) cube(size=[lid_curve_sphere_radius*2+1, lid_curve_sphere_radius*2+1, lid_curve_sphere_radius*2-lid_height], center=true);
//       }
//     }
  }
  
}

translate([0, 0, base_height + 5]) lid();
// !projection(cut=true) translate([0, 0, - base_height/2]){
//   base();
// }

// for (x=[-1,1]) {
//   translate([x * (6 * 25.4) / 2, 0, 0]) 
//     circle(r=3/8 * 25.4 / 2, $fn=72);
// }


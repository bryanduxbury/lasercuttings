material_thickness = 0.5 * 25.4;

feet_height = 25.4;
feet_width = 4 * 25.4;

bit_diameter = 1/4 * 25.4;

tab_width = 2 * 25.4;

handle_width = 3*25.4;
handle_corner_radius = 25.4;
handle_thickness = 1.5*25.4;
fridge_handle_height = 12 * 25.4;
freezer_handle_height = 6 * 25.4;
fridge_x_from_right = 2 * 25.4;
fridge_y_from_top = 0;

// fridge dimensions
fridge_total_height = 3 * 12 * 25.4;
fridge_width = 18 * 25.4;
fridge_depth = 18 * 25.4;

fridge_freezer_height = 12 * 25.4;

// open
fridge_door_angle = -135;
freezer_door_angle = -115;

// closed
// fridge_door_angle = 0;
// freezer_door_angle = 0;


// stove dimensions
stove_height = 18 * 25.4;
stove_width = 18 * 25.4;
stove_depth = 18 * 25.4;

stove_door_gutter = 2 * 25.4;
stove_door_window_corner_radius = 25.4;

// sink dimensions
sink_height = 18 * 25.4;
sink_width = 18 * 25.4;
sink_depth = 18 * 25.4;

// microwave
microwave_height = 8 * 25.4;
microwave_width = 36 * 25.4;
microwave_depth = 8 * 25.4;

microwave_window_gutter = 2*25.4;
microwave_handle_depth = 3 * 25.4;


cupboard_width = 16 * 25.4;

control_panel_width = 4 * 25.4;

microwave_proper_width = microwave_width - cupboard_width - control_panel_width;


// calculated
total_width = fridge_width+stove_width+sink_width;
total_height = fridge_total_height;
total_depth = fridge_depth;

flatten = 1;

module xy() {
  color([192/255, 64/255, 64/255]) {
    child(0);
  }
}

module xz() {
  color([64/255, 192/255, 64/255]) {
    rotate([90*flatten, 0, 0]) child(0);
  }
}

module yz() {
  color([64/255, 64/255, 192/255]) {
    rotate([90*flatten, 0, 90 * flatten]) child(0);
  }
}

module rounded_rect(h, w, d, r) {
  union() {
    cube(size=[w-r*2, d-r*2, h], center=true);
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([x * (w/2 - r), y * (d/2 - r), 0]) cylinder(r=r, h=h, center=true);
      }
    }
    cube(size=[w - r*2, d, h], center=true);
    cube(size=[w, d - r*2, h], center=true);
  }
}

module edge_slot(w) {
  union() {
    cube(size=[w, material_thickness+0.01, material_thickness+0.1], center=true);
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([x*(w/2 - bit_diameter/2), y*material_thickness/2, 0]) cylinder(r=bit_diameter/2, h=material_thickness+0.1, center=true);
      }
    }
  }
}

module tabs_at_thirds(w) {
  union() {
    edge_slot(w/3-tab_width);
    for (x=[1,-1]) {
      translate([x*w/2, 0, 0]) edge_slot(w - (w/3+tab_width));
    }
  }
}

// module tabify(w,n) {
//   #union() {
//     for (x=[-floor(n/2):floor(n/2)]) {
//       translate([x*w/n, 0, 0]) edge_slot((w-(n-1)*tab_width)/n);
//     }
//     // edge_slot(w/n-tab_width);
//     // for (x=[1,-1]) {
//     //   translate([x*w/2, 0, 0]) edge_slot(w - (w/3+tab_width));
//     // }
//   }
// }


module slots_at_thirds(w) {
  for (x=[1,-1]) {
    translate([x*w/6, 0, 0]) edge_slot(tab_width);
  }
}

module single_tab(w) {
  for (x=[1,-1]) {
    translate([x*w/2, 0, 0]) edge_slot(w-tab_width);
  }
}

module back_plate() {
  xz() render() difference() {
    cube(size=[total_width, total_height, material_thickness], center=true);
    translate([-total_width/2 + fridge_width/2, total_height/2 - material_thickness/2, 0]) {
      for (x=[-1,1]) {
        translate([x*fridge_width/6, 0, 0]) edge_slot(tab_width);
      }
    }
    translate([-total_width/2 + fridge_width/2, total_height/2 - fridge_freezer_height, 0]) {
      for (x=[-1,1]) {
        translate([x*fridge_width/6, 0, 0]) edge_slot(tab_width);
      }
    }
    translate([-total_width/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(total_height);
    translate([-total_width/2 + fridge_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(total_height);

    translate([total_width/2 - sink_width, -total_height/2 + stove_height/2, 0]) rotate([0, 0, 90]) slots_at_thirds(stove_height);
    translate([total_width/2 - material_thickness/2, -total_height/2 + stove_height/2, 0]) rotate([0, 0, 90]) slots_at_thirds(stove_height);

    translate([total_width/2 - (stove_width + sink_width + material_thickness)/2 + material_thickness/2, -total_height/2 + stove_height - material_thickness/2, 0]) slots_at_thirds(stove_width+sink_depth+material_thickness);

    translate([total_width/2 - microwave_width/2, total_height/2 - material_thickness/2, 0]) slots_at_thirds(microwave_width);
    translate([total_width/2 - microwave_width/2, total_height/2 - microwave_height + material_thickness/2, 0]) slots_at_thirds(microwave_width);

    translate([total_width/2 - material_thickness/2, total_height/2 - microwave_height/2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    translate([total_width/2 - microwave_proper_width - material_thickness/2, total_height/2 - microwave_height/2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    translate([total_width/2 - microwave_proper_width - control_panel_width - material_thickness/2, total_height/2 - microwave_height/2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);

    translate([-total_width/2 + fridge_width/2, -total_height/2, 0]) cube(size=[fridge_width - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([-total_width/2 + fridge_width + stove_width /2, -total_height/2, 0]) cube(size=[stove_width - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([-total_width/2 + fridge_width + stove_width + sink_width/2, -total_height/2, 0]) cube(size=[sink_width - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
  }
}

module combined_bottom() {
  xy() render() difference() {
    cube(size=[total_width, fridge_depth, material_thickness], center=true);

    translate([total_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(fridge_depth);
    translate([-total_width/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(fridge_depth);

    translate([total_width/2 - sink_width, 0, 0]) {
      rotate([0, 0, 90]) edge_slot(tab_width);
      for (x=[-1,1]) {
        translate([0, x*fridge_depth/2, 0]) rotate([0, 0, 90]) edge_slot(feet_width*2);
      }
    }

    translate([total_width/2 - sink_width - stove_width - material_thickness/2, 0, 0]) {
      rotate([0, 0, 90]) edge_slot(tab_width);
      for (x=[-1,1]) {
        translate([0, x*fridge_depth/2, 0]) rotate([0, 0, 90]) edge_slot(feet_width*2);
      }
    }

    translate([0, fridge_depth/2 - material_thickness/2, 0]) 
      cube(size=[total_width, material_thickness, material_thickness+0.1], center=true);
      // tabs_at_thirds(total_width);
      // tabify(total_width, 3);
  }

}

module combined_countertop() {
  xy() render() difference() {
    union() {
      translate([-(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) cube(size=[material_thickness, stove_depth, material_thickness], center=true);
      translate([-(stove_width + sink_width)/2 + stove_width / 2, 0, 0]) cube(size=[stove_width, stove_depth, material_thickness], center=true);
      translate([(stove_width + sink_width)/2 - sink_width / 2, 0, 0]) cube(size=[sink_width, sink_depth, material_thickness], center=true);
    }
    translate([-(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(stove_depth);
    translate([-(stove_width + sink_width)/2 + stove_width, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(stove_depth);
    translate([(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(stove_depth);
    translate([0, stove_depth/2-material_thickness/2, 0]) tabs_at_thirds(stove_width+sink_depth+material_thickness);
  }
}

module combined_top() {
  xy() render() 
    union() {
      translate([-total_width/2 + fridge_width/2, 0, 0]) difference() {
        cube(size=[fridge_width, fridge_depth, material_thickness], center=true);
        for (x=[-1,1]) {
          translate([x*(fridge_width/2 - material_thickness/2), 0, 0]) {
            translate([0, fridge_depth/2 - microwave_depth / 2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
            translate([0, -fridge_depth/2  + (fridge_depth - microwave_depth) / 2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
          }
        }

        translate([0, fridge_depth/2 - material_thickness/2, 0]) tabs_at_thirds(fridge_width);
      }

      translate([-total_width/2 + fridge_width + microwave_width / 2, fridge_depth / 2 - microwave_depth/2, 0]) difference() {
        cube(size=[microwave_width, microwave_depth, material_thickness], center=true);

        translate([0, microwave_depth/2 - material_thickness/2, 0]) tabs_at_thirds(microwave_width);

        translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);

        translate([microwave_width/2 - microwave_proper_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
        translate([microwave_width/2 - microwave_proper_width - control_panel_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
      }
    }
}

module center_feet_cutouts() {
  for (x=[-1,1]) {
    translate([x*((fridge_depth - 2 * feet_width - tab_width) / 4 + tab_width/2), 0, 0]) edge_slot((fridge_depth - 2 * feet_width - tab_width) / 2);
  }
}

module fridge_left() {
  yz() render() difference() {
    cube(size=[fridge_depth, fridge_total_height, material_thickness], center=true);
    translate([0, fridge_total_height/2 - material_thickness/2, 0]) {
      translate([-(-fridge_depth / 2 + microwave_depth/2 + (fridge_depth - microwave_depth/2 - (fridge_depth-microwave_depth)/2 - tab_width)/2 + tab_width/2), 0, 0]) 
        edge_slot(fridge_depth - microwave_depth/2 - (fridge_depth-microwave_depth)/2 - tab_width);
      translate([fridge_depth/2, 0, 0]) edge_slot(microwave_depth - tab_width);
      translate([-fridge_depth/2, 0, 0]) edge_slot((fridge_depth - microwave_depth) - tab_width);
    }
    translate([0, fridge_total_height / 2 - fridge_freezer_height, 0]) slots_at_thirds(fridge_depth);
    translate([fridge_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(total_height);


    translate([0, -fridge_total_height/2, 0]) cube(size=[fridge_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -fridge_total_height/2 + feet_height + material_thickness/2, 0]) edge_slot(tab_width);
  }
}

module fridge_right() {
  yz() render() !difference() {
    cube(size=[fridge_depth, fridge_total_height, material_thickness], center=true);
    translate([0, fridge_total_height/2 - material_thickness/2, 0]) {
      translate([-fridge_depth / 2 + microwave_depth/2 + (fridge_depth - microwave_depth/2 - (fridge_depth-microwave_depth)/2 - tab_width)/2 + tab_width/2, 0, 0]) 
        edge_slot(fridge_depth - microwave_depth/2 - (fridge_depth-microwave_depth)/2 - tab_width);
      translate([-fridge_depth/2, 0, 0]) edge_slot(microwave_depth - tab_width);
      translate([fridge_depth/2, 0, 0]) edge_slot((fridge_depth - microwave_depth) - tab_width);
    }
    translate([0, fridge_total_height / 2 - fridge_freezer_height, 0]) slots_at_thirds(fridge_depth);
    translate([-fridge_width/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(total_height);

    translate([0, -fridge_total_height/2 + stove_height - material_thickness/2, 0]) slots_at_thirds(fridge_depth);

    translate([0, -fridge_total_height/2, 0]) cube(size=[fridge_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -fridge_total_height/2 + feet_height + material_thickness/2, 0]) center_feet_cutouts();

    translate([-(fridge_depth/2 - microwave_depth / 2), fridge_total_height/2 - microwave_height + material_thickness/2, 0]) edge_slot(tab_width);
  }
}

module fridge_divider() {
  xy() render() difference() {
    cube(size=[fridge_width, fridge_depth, material_thickness], center=true);

    translate([0, fridge_depth/2 - material_thickness/2, 0]) tabs_at_thirds(fridge_width);

    for (x=[-1,1]) {
      translate([x * (fridge_width/2 - material_thickness/2), 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(fridge_depth);
    }
  }
}

module fridge_bottom() {
  cube(size=[fridge_width, fridge_depth, material_thickness], center=true);
}

module fridge_door_main() {
  xz() render() difference() {
    cube(size=[fridge_width, fridge_total_height - fridge_freezer_height, material_thickness], center=true);
    translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, 0, 0]) {
      translate([0, (fridge_total_height - fridge_freezer_height)/2, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness);
      translate([0, (fridge_total_height - fridge_freezer_height)/2 - fridge_handle_height + handle_thickness/4, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }
  }
}

module generic_f_door_handle(h) {
  render() difference() {
    translate([0, -handle_corner_radius/2, 0]) union() {
      cube(size=[handle_width, h - handle_corner_radius, material_thickness], center=true);
      translate([-handle_width/2 + handle_corner_radius, (h - handle_corner_radius)/2, 0]) cylinder(r=handle_corner_radius, h=material_thickness, center=true);
      translate([handle_corner_radius/2, (h - handle_corner_radius)/2, 0]) cube(size=[handle_width - handle_corner_radius, handle_corner_radius*2, material_thickness], center=true);
    }

    translate([handle_width/2, 0, 0]) {
      translate([-handle_width + handle_thickness + handle_corner_radius, (h - handle_thickness*2)/2 - handle_corner_radius, 0]) cylinder(r=handle_corner_radius, h=material_thickness+0.1, center=true);
      translate([-handle_width + handle_thickness + handle_corner_radius, -(h - handle_thickness*2)/2 + handle_corner_radius, 0]) cylinder(r=handle_corner_radius, h=material_thickness+0.1, center=true);
      cube(size=[(handle_width - handle_thickness)*2, h - handle_thickness*2 - handle_corner_radius*2, material_thickness+0.1], center=true);
      cube(size=[(handle_width - handle_thickness)*2 - handle_corner_radius*2, h - handle_thickness*2, material_thickness+0.1], center=true);
      
      for (i=[-1,1]) {
        translate([-material_thickness/2, i * (h/2 - handle_thickness), 0]) rotate([0, 0, 90]) edge_slot(handle_thickness);
      }
    }
  }
}


module fridge_door_handle() {
  yz() generic_f_door_handle(fridge_handle_height);
}

module fridge_door_assembly() {
  fridge_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, (fridge_total_height - fridge_freezer_height)/2 + fridge_y_from_top - fridge_handle_height/2, handle_width / 2 - material_thickness/2]) 
    rotate([0, 90, 180]) fridge_door_handle();
}

module freezer_door_main() {
  xz() render() difference() {
    cube(size=[fridge_width, fridge_freezer_height, material_thickness], center=true);
    translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, 0, 0]) {
      translate([0, -fridge_freezer_height/2, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness);
      translate([0, -fridge_freezer_height/2 + freezer_handle_height - handle_thickness/4, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }
  }
}

module freezer_door_handle() {
  yz() generic_f_door_handle(freezer_handle_height);
}

module freezer_door_assembly() {
  freezer_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, -fridge_freezer_height/2 - fridge_y_from_top + freezer_handle_height/2, handle_width / 2 - material_thickness/2]) 
    rotate([0, 90, 0]) freezer_door_handle();
}

module fridge_assembly() {
  translate([-fridge_width/2 + material_thickness/2, 0, 0]) fridge_left();
  translate([fridge_width/2 - material_thickness/2, 0, 0]) fridge_right();
  translate([0, 0, fridge_total_height / 2 - fridge_freezer_height]) fridge_divider();
  translate([-fridge_width/2, -fridge_depth/2 - material_thickness/2, -fridge_total_height/2 + (fridge_total_height - fridge_freezer_height) / 2]) 
    rotate([0, 0, fridge_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        rotate([90, 0, 0]) fridge_door_assembly();

  translate([-fridge_width/2, -fridge_depth/2 - material_thickness/2, fridge_total_height/2 - fridge_freezer_height / 2]) 
    rotate([0, 0, freezer_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        rotate([90, 0, 0]) freezer_door_assembly();
}

module stove_right() {
  yz() render() difference() {
    cube(size=[stove_depth, stove_height, material_thickness], center=true);
    translate([stove_depth/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(stove_height);
    translate([0, stove_height/2 - material_thickness/2, 0]) tabs_at_thirds(stove_depth);

    translate([0, -sink_height/2, 0]) cube(size=[sink_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) center_feet_cutouts();
  }
}

module stove_door_main() {
  xz() render() difference() {
    cube(size=[stove_width, stove_height - feet_height, material_thickness], center=true);
    translate([0, -stove_door_gutter/2, 0]) 
      rounded_rect(material_thickness+0.1, stove_width - stove_door_gutter*2, stove_height - feet_height - stove_door_gutter * 3, stove_door_window_corner_radius);

    translate([0, (stove_height - feet_height)/2 - stove_door_gutter, 0]) {
      for (i=[-1,1]) {
        translate([(stove_width * 0.8 / 2 - handle_thickness/4) * i, 0, 0]) edge_slot(handle_thickness/2);
      }
    }
  }
}

module stove_door_handle() {
  xy() render() difference() {
    union() {
      cube(size=[stove_width * 0.8 - handle_corner_radius * 2, handle_width, material_thickness], center=true);
      for (i=[-1,1]) {
        translate([(stove_width * 0.8 - handle_corner_radius * 2)/2*i, handle_width/-2 + handle_corner_radius, 0]) cylinder(r=handle_corner_radius, h=material_thickness, center=true);
      }
      translate([0, handle_corner_radius/2, 0]) cube(size=[stove_width * 0.8, handle_width - handle_corner_radius, material_thickness], center=true);
    }

    translate([0, handle_thickness/2, 0]) 
      cube(size=[(stove_width * 0.8 - handle_corner_radius * 2) - handle_thickness * 2, handle_width - handle_thickness, material_thickness], center=true);
    for (i=[-1,1]) {
      translate([((stove_width * 0.8 - handle_corner_radius * 2) - handle_thickness * 2)/2*i, handle_width/2 - (handle_width - handle_thickness - handle_corner_radius), 0]) 
        cylinder(r=handle_corner_radius, h=material_thickness, center=true);
    }
    translate([0, handle_width/2, 0]) 
      cube(size=[(stove_width * 0.8) - handle_thickness * 2, (handle_width - handle_thickness - handle_corner_radius)*2, material_thickness], center=true);

    for (i=[-1,1]) {
      translate([(stove_width * 0.8 / 2 - handle_thickness)*i, handle_width/2-material_thickness/2, 0]) edge_slot(handle_thickness);
    }
  }
}

module stove_door_assembly() {
  rotate([90, 0, 0]) {
    stove_door_main();
    translate([0, (stove_height - feet_height)/2 - stove_door_gutter, handle_width/2 - material_thickness/2]) rotate([-90, 0, 0]) stove_door_handle();
  }
}

module oven_assembly() {
  translate([stove_width/2, 0, 0]) rotate([90, 0, 90]) stove_right();
  translate([0, -fridge_depth / 2 - material_thickness/2, material_thickness]) stove_door_assembly();
  stove_control_panel();
}

module sink_right() {
  yz() render() difference() {
    cube(size=[sink_depth, sink_height, material_thickness], center=true);
    translate([-sink_depth/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(sink_height);
    translate([0, sink_height/2 - material_thickness/2, 0]) tabs_at_thirds(sink_depth);
    translate([0, -sink_height/2, 0]) cube(size=[sink_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) edge_slot(tab_width);
  }
}

module sink_cupboard_door() {
  xz() render() difference() {
    cube(size=[sink_width, sink_height - feet_height, material_thickness], center=true);
    translate([-.8 * sink_width /2, .8 * (sink_height - feet_height) / 2, 0]) cylinder(r=bit_diameter/2, h=material_thickness*10, center=true, $fn=36);
  }
}

module sink_assembly() {
  translate([sink_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) sink_right();
  translate([0, -sink_depth / 2 - material_thickness/2, material_thickness]) rotate([90, 0, 0]) sink_cupboard_door();
}

module microwave_cupboard_bottom() {
  xy() render() difference() {
    translate([-material_thickness/2, 0, 0]) cube(size=[microwave_width + material_thickness, microwave_depth, material_thickness], center=true);

    translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([-microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([microwave_width/2 - microwave_proper_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    translate([microwave_width/2 - microwave_proper_width - control_panel_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);

    translate([0, microwave_depth/2 - material_thickness/2, 0]) tabs_at_thirds(microwave_width);
  }
}

module microwave_cupboard_right() {
  yz() render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    }
    translate([0, microwave_depth/2 - material_thickness/2, 0]) single_tab(microwave_height);
  }
  
}

module microwave_right() {
  yz() render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    }
    translate([0, microwave_depth/2-material_thickness/2, 0]) single_tab(microwave_height);
  }
}

module cupboard_left() {
  yz() render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    }
    translate([0, microwave_depth/2-material_thickness/2, 0]) single_tab(microwave_height);
  }
}

module microwave_door_main() {
  xz() render() difference() {
    cube(size=[microwave_proper_width, microwave_height, material_thickness], center=true);
    translate([-microwave_window_gutter/2, 0, 0]) rounded_rect(material_thickness+0.1, microwave_proper_width-3*microwave_window_gutter, microwave_height - 2 * microwave_window_gutter, stove_door_window_corner_radius);

    for (i=[-1,1]) {
      translate([microwave_proper_width/2 - microwave_window_gutter, (microwave_height * 0.4 - handle_thickness/4) * i, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }
  }
}

module microwave_door_handle() {
  yz() render() difference() {
    union() {
      cube(size=[microwave_height * 0.8 - handle_corner_radius * 2, microwave_handle_depth, material_thickness], center=true);
      for (i=[-1,1]) {
        translate([(microwave_height * 0.8 - handle_corner_radius * 2)/2*i, microwave_handle_depth/-2 + handle_corner_radius, 0]) cylinder(r=handle_corner_radius, h=material_thickness, center=true);
      }
      translate([0, handle_corner_radius/2, 0]) cube(size=[microwave_height * 0.8, microwave_handle_depth - handle_corner_radius, material_thickness], center=true);
    }

    translate([0, handle_thickness/2, 0]) 
      cube(size=[(microwave_height * 0.8 - handle_corner_radius * 2) - handle_thickness * 2, microwave_handle_depth - handle_thickness, material_thickness], center=true);
    for (i=[-1,1]) {
      translate([((microwave_height * 0.8 - handle_corner_radius * 2) - handle_thickness * 2)/2*i, microwave_handle_depth/2 - (microwave_handle_depth - handle_thickness - handle_corner_radius), 0]) 
        cylinder(r=handle_corner_radius, h=material_thickness, center=true);
    }
    translate([0, microwave_handle_depth/2, 0]) 
      cube(size=[(microwave_height * 0.8) - handle_thickness * 2, (microwave_handle_depth - handle_thickness - handle_corner_radius)*2, material_thickness], center=true);

    for (i=[-1,1]) {
      translate([(microwave_height * 0.8 / 2 - handle_thickness)*i, microwave_handle_depth/2-material_thickness/2, 0]) edge_slot(handle_thickness);
    }
  }
}

module microwave_door_assembly() {
  microwave_door_main();
  translate([microwave_proper_width/2 - microwave_window_gutter, 0, microwave_handle_depth / 2 - material_thickness/2]) 
    rotate([-90, 0, 90]) microwave_door_handle();
}


module microwave_cupboard_assembly() {
  translate([0, 0, -microwave_height/2 + material_thickness/2]) microwave_cupboard_bottom();
  translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 90, 0]) microwave_cupboard_right();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width, 0, 0]) rotate([0, 90, 0]) cupboard_left();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width - control_panel_width, 0, 0]) rotate([0, 90, 0]) microwave_right();

  microwave_control_panel();

  translate([-microwave_width/2 + microwave_proper_width/2, -microwave_depth / 2 - material_thickness/2, 0]) 
    rotate([90, 0, 0]) microwave_door_assembly();
}


translate([0, fridge_depth/2 - material_thickness/2, 0]) back_plate();

translate([0, 0, -total_height/2 + feet_height + material_thickness/2]) combined_bottom();

translate([0, 0, total_height/2 - material_thickness/2]) combined_top();

translate([total_width/2 - (sink_width + stove_width) / 2, 0, -total_height/2 + stove_height - material_thickness/2]) combined_countertop();

translate([-total_width/2 + fridge_width/2, 0, 0]) {
  fridge_assembly();
}

translate([-total_width/2 + fridge_width + stove_width / 2, 0, -fridge_total_height/2 + stove_height/2]) 
{
  oven_assembly();
}

translate([-total_width/2 + fridge_width + stove_width + sink_width / 2, 0, -fridge_total_height/2 + sink_height/2]) 
{
  sink_assembly();
}
  
translate([-total_width/2 + fridge_width + microwave_width / 2, fridge_depth / 2 - microwave_depth / 2, fridge_total_height/2 - microwave_height/2]) 
{
  microwave_cupboard_assembly();
}
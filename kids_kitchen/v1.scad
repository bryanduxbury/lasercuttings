material_thickness = 0.5 * 25.4;

feet_height = 25.4;
feet_width = 4 * 25.4;

bit_diameter = 1/4 * 25.4;

tab_width = 2 * 25.4;

handle_width = 3*25.4;
fridge_handle_height = 12 * 25.4;
freezer_handle_height = 6 * 25.4;
fridge_x_from_right = 2 * 25.4;
fridge_y_from_top = 0;

// fridge dimensions
fridge_total_height = 3 * 12 * 25.4;
fridge_width = 18 * 25.4;
fridge_depth = 18 * 25.4;

fridge_freezer_height = 12 * 25.4;

fridge_door_angle = -135;
freezer_door_angle = -115;

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

cupboard_width = 16 * 25.4;

control_panel_width = 4 * 25.4;

microwave_proper_width = microwave_width - cupboard_width - control_panel_width;


// calculated
total_width = fridge_width+stove_width+sink_width;
total_height = fridge_total_height;
total_depth = fridge_depth;

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
  render() difference() {
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
  render() difference() {
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
  render() difference() {
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
  render() 
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
  render() difference() {
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
  render() difference() {
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
  render() difference() {
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
  cube(size=[fridge_width, fridge_total_height - fridge_freezer_height, material_thickness], center=true);
}

module fridge_door_handle() {
  cube(size=[handle_width, fridge_handle_height, material_thickness], center=true);
}

module fridge_door_assembly() {
  color([120/255, 120/255, 120/255]) fridge_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, (fridge_total_height - fridge_freezer_height)/2 + fridge_y_from_top - fridge_handle_height/2, handle_width / 2 - material_thickness/2]) 
    rotate([0, 90, 0]) color([12/255, 34/255, 56/255]) fridge_door_handle();
}

module freezer_door_main() {
  cube(size=[fridge_width, fridge_freezer_height, material_thickness], center=true);
}

module freezer_door_handle() {
  cube(size=[handle_width, freezer_handle_height, material_thickness], center=true);
}

module freezer_door_assembly() {
  color([120/255, 120/255, 120/255]) freezer_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, -fridge_freezer_height/2 - fridge_y_from_top + freezer_handle_height/2, handle_width / 2 - material_thickness/2]) 
    rotate([0, 90, 0]) color([12/255, 34/255, 56/255]) freezer_door_handle();
}


module fridge_assembly() {
  translate([-fridge_width/2 + material_thickness/2, 0, 0]) rotate([90, 0, 90]) fridge_left();
  translate([fridge_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) fridge_right();
  translate([0, 0, fridge_total_height / 2 - fridge_freezer_height]) color([128/255, 64/255, 0/255]) fridge_divider();
  translate([-fridge_width/2, -fridge_depth/2 - material_thickness/2, -fridge_total_height/2 + (fridge_total_height - fridge_freezer_height) / 2]) 
    rotate([0, 0, fridge_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        rotate([90, 0, 0]) fridge_door_assembly();

  translate([-fridge_width/2, -fridge_depth/2 - material_thickness/2, fridge_total_height/2 - fridge_freezer_height / 2]) 
    rotate([0, 0, freezer_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        rotate([90, 0, 0])  freezer_door_assembly();
}

module stove_top() {
  cube(size=[stove_width, stove_depth, material_thickness], center=true);
}

module stove_bottom() {
  cube(size=[stove_width, stove_depth, material_thickness], center=true);
}

module stove_right() {
  render() difference() {
    cube(size=[stove_depth, stove_height, material_thickness], center=true);
    translate([stove_depth/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(stove_height);
    translate([0, stove_height/2 - material_thickness/2, 0]) tabs_at_thirds(stove_depth);

    translate([0, -sink_height/2, 0]) cube(size=[sink_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) center_feet_cutouts();
  }
}

module stove_door_main() {
  render() difference() {
    cube(size=[stove_width, stove_height - feet_height, material_thickness], center=true);
    translate([0, -stove_door_gutter/2, 0]) 
      rounded_rect(material_thickness+0.1, stove_width - stove_door_gutter*2, stove_height - feet_height - stove_door_gutter * 3, stove_door_window_corner_radius);
  }
}

module stove_door_handle() {
  cube(size=[stove_width*.8, handle_width, material_thickness], center=true);
}

module stove_door_assembly() {
  rotate([90, 0, 0]) {
    color([128/255, 128/255, 128/255]) {
      stove_door_main();
    }
    translate([0, (stove_height - feet_height)/2 - stove_door_gutter, handle_width/2 - material_thickness/2]) rotate([90, 0, 0]) stove_door_handle();
  }
}

module oven_assembly() {
  translate([stove_width/2, 0, 0]) rotate([90, 0, 90]) stove_right();
  translate([0, -fridge_depth / 2 - material_thickness/2, material_thickness]) stove_door_assembly();
  stove_control_panel();
}

module sink_right() {
  render() difference() {
    cube(size=[sink_depth, sink_height, material_thickness], center=true);
    translate([-sink_depth/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(sink_height);
    translate([0, sink_height/2 - material_thickness/2, 0]) tabs_at_thirds(sink_depth);
    translate([0, -sink_height/2, 0]) cube(size=[sink_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) edge_slot(tab_width);
  }

}

module sink_assembly() {
  translate([sink_width/2 - material_thickness/2, 0, 0]) rotate([90, 0, -90]) sink_right();
}

module microwave_cupboard_bottom() {
  render() color([0/255, 64/255, 32/255]) difference() {
    translate([-material_thickness/2, 0, 0]) cube(size=[microwave_width + material_thickness, microwave_depth, material_thickness], center=true);

    translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([-microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([microwave_width/2 - microwave_proper_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    translate([microwave_width/2 - microwave_proper_width - control_panel_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);

    translate([0, microwave_depth/2 - material_thickness/2, 0]) tabs_at_thirds(microwave_width);
  }
  
}

module microwave_cupboard_right() {
  render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    }
    translate([0, microwave_depth/2 - material_thickness/2, 0]) single_tab(microwave_height);
  }
  
}

module microwave_right() {
  render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    }
    translate([0, microwave_depth/2-material_thickness/2, 0]) single_tab(microwave_height);
  }
}

module cupboard_left() {
  render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    }
    translate([0, microwave_depth/2-material_thickness/2, 0]) single_tab(microwave_height);
  }
}


module microwave_cupboard_assembly() {
  translate([0, 0, -microwave_height/2 + material_thickness/2]) color([0/255, 128/255, 64/255]) microwave_cupboard_bottom();
  translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 90, 0]) microwave_cupboard_right();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width, 0, 0]) rotate([0, 90, 0]) cupboard_left();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width - control_panel_width, 0, 0]) rotate([0, 90, 0]) microwave_right();

  microwave_control_panel();
}


translate([0, fridge_depth/2 - material_thickness/2, 0]) rotate([90, 0, 0]) color([120/255, 120/255, 120/255]) back_plate();

translate([0, 0, -total_height/2 + feet_height + material_thickness/2]) color([64/255, 64/255, 64/255]) combined_bottom();

translate([0, 0, total_height/2 - material_thickness/2]) color([64/255, 128/255, 64/255]) combined_top();

translate([total_width/2 - (sink_width + stove_width) / 2, 0, -total_height/2 + stove_height - material_thickness/2]) color([64/255, 64/255, 128/255]) combined_countertop();

translate([-total_width/2 + fridge_width/2, 0, 0]) {
  fridge_assembly();
}

translate([-total_width/2 + fridge_width + stove_width / 2, 0, -fridge_total_height/2 + stove_height/2]) 
{
  oven_assembly();
}

translate([-total_width/2 + fridge_width + stove_width + sink_width / 2, 0, -fridge_total_height/2 + sink_height/2]) 
  color([0/255, 128/255, 0/255]) 
{
  sink_assembly();
}
  
translate([-total_width/2 + fridge_width + microwave_width / 2, fridge_depth / 2 - microwave_depth / 2, fridge_total_height/2 - microwave_height/2]) 
{
  microwave_cupboard_assembly();
}
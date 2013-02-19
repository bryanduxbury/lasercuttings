// material_thickness = 0.75 * 25.4;
// material_thickness = 0.25 * 25.4;
material_thickness = 19.5;

feet_height = 25.4;
feet_width = 4 * 25.4;

bit_diameter = 1/4 * 25.4 + 0.1;

tab_width = 2 * 25.4;

overall_depth = 18 * 25.4;

hinge_w = 16.6;
hinge_h = 51;
hinge_d = 1.7;

handle_width = 3*25.4;
handle_corner_radius = 25.4;
handle_thickness = 1.5*25.4;
fridge_handle_height = 12 * 25.4;
freezer_handle_height = 6 * 25.4;
fridge_x_from_right = 2 * 25.4;
fridge_y_from_top = 0;

// fridge dimensions
fridge_total_height = 3 * 12 * 25.4;
fridge_width = 14 * 25.4;

fridge_freezer_height = 12 * 25.4;

// open
fridge_door_angle = -135;
freezer_door_angle = -115;

// closed
// fridge_door_angle = 0;
// freezer_door_angle = 0;


// stove dimensions
stove_height = 18 * 25.4;
stove_width = 14 * 25.4;

stove_door_gutter = 2 * 25.4;
stove_door_window_corner_radius = 25.4;

// sink dimensions
sink_height = 18 * 25.4;
sink_width = 14 * 25.4;

basin_width = ((11 + 13/16) - (9/16) * 2) * 25.4;
basin_depth = ((8 + 3/16) - (9/16) * 2) * 25.4;


// microwave
microwave_height = 8 * 25.4;
microwave_width = 28 * 25.4;
microwave_depth = 8 * 25.4;

microwave_window_gutter = 2*25.4;
microwave_handle_depth = 3 * 25.4;


cupboard_width = 8 * 25.4;

control_panel_width = 3 * 25.4;

microwave_proper_width = microwave_width - cupboard_width - control_panel_width;


// calculated
total_width = fridge_width+stove_width+sink_width;
echo("total width:", total_width);
total_height = fridge_total_height;
echo("total height:", total_height);

flatten = 0;

module _xy() {
  color([192/255, 64/255, 64/255]) {
    child(0);
  }
}

module _xz() {
  color([64/255, 192/255, 64/255]) {
    rotate([90*flatten, 0, 0]) child(0);
  }
}

module _yz() {
  color([64/255, 64/255, 192/255]) {
    rotate([90*flatten, 0, 90 * flatten]) child(0);
  }
}

module _rounded_rect(h, w, d, r) {
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

module edge_slot(w,th=material_thickness) {
  union() {
    cube(size=[w, th+0.01, material_thickness+0.1], center=true);
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([x*(w/2 - bit_diameter/2), y*th/2, 0]) cylinder(r=bit_diameter/2, h=material_thickness+0.1, center=true, $fn=36);
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
  _xz() render() difference() {
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

    translate([total_width/2 - (stove_width + sink_width + material_thickness)/2 + material_thickness/2, -total_height/2 + stove_height - material_thickness/2, 0]) slots_at_thirds(stove_width+overall_depth+material_thickness);

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
  _xy() render() difference() {
    cube(size=[total_width, overall_depth, material_thickness], center=true);

    translate([total_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(overall_depth);
    translate([-total_width/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(overall_depth);

    translate([total_width/2 - sink_width, 0, 0]) {
      rotate([0, 0, 90]) edge_slot(tab_width);
      for (x=[-1,1]) {
        translate([0, x*overall_depth/2, 0]) rotate([0, 0, 90]) edge_slot(feet_width*2);
      }
    }

    translate([total_width/2 - sink_width - stove_width - material_thickness/2, 0, 0]) {
      rotate([0, 0, 90]) edge_slot(tab_width);
      for (x=[-1,1]) {
        translate([0, x*overall_depth/2, 0]) rotate([0, 0, 90]) edge_slot(feet_width*2);
      }
    }

    translate([0, overall_depth/2 - material_thickness/2, 0]) 
      cube(size=[total_width, material_thickness, material_thickness+0.1], center=true);
      
    // oven hinges
    translate([-total_width / 2 + fridge_width + stove_width/2, -overall_depth / 2 - material_thickness/2 + hinge_d, 0]) {
      for (x=[-1,1]) {
        translate([x * stove_width / 3, 0, 0]) edge_slot(hinge_h);
      }
      
    }
  }
}

module ring(r1, r2) {
  render() difference() {
    cylinder(r=r1, h=material_thickness, center=true, $fn=72);
    cylinder(r=r2, h=material_thickness, center=true, $fn=72);
  }
}

function coil_thickness(d) = d/2/7;
function coil_portion_dia(d) = (d - bit_diameter*4);

function coil_dim() = min(overall_depth, stove_width) * 0.7 * 0.45;

module stove_coil(dia) {
  ring(dia/2, dia/2 - bit_diameter);
  ring(coil_portion_dia(dia)/2, coil_portion_dia(dia)/2 - coil_thickness(coil_portion_dia(dia)));
  ring(coil_portion_dia(dia)/2 - 2 * coil_thickness(coil_portion_dia(dia)), coil_portion_dia(dia)/2 - 3 * coil_thickness(coil_portion_dia(dia)));
  ring(coil_portion_dia(dia)/2 - 4 * coil_thickness(coil_portion_dia(dia)), coil_portion_dia(dia)/2 - 5 * coil_thickness(coil_portion_dia(dia)));
}

module combined_countertop() {
  _xy() render() difference() {
    union() {
      translate([-(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) cube(size=[material_thickness, overall_depth, material_thickness], center=true);

      // stovetop
      translate([-(stove_width + sink_width)/2 + stove_width / 2, 0, 0]) union() {
        difference() {
          cube(size=[stove_width, overall_depth, material_thickness], center=true);
          translate([0, -overall_depth*.05, material_thickness/2 - material_thickness/8 + 0.1]) _rounded_rect(material_thickness / 4, stove_width * 0.8, overall_depth * 0.7, bit_diameter);
        }
        translate([0, -overall_depth*0.05, 0]) {
          for (x=[-1,1]) {
            for (y=[-1,1]) {
              translate([x * (stove_width * 0.4 - coil_dim()/2 - bit_diameter), y * (overall_depth * 0.7 / 2 - coil_dim() / 2 - bit_diameter), 0]) stove_coil(coil_dim());
            }
          }
        }
      }

      // sink
      translate([(stove_width + sink_width)/2 - sink_width / 2, 0, 0]) difference() {
        cube(size=[sink_width, overall_depth, material_thickness], center=true);
        _rounded_rect(material_thickness *2, basin_width, basin_depth, bit_diameter);
      }
    }
    translate([-(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(overall_depth);
    translate([-(stove_width + sink_width)/2 + stove_width, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(overall_depth);
    translate([(stove_width + sink_width)/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) slots_at_thirds(overall_depth);
    translate([0, overall_depth/2-material_thickness/2, 0]) tabs_at_thirds(stove_width+overall_depth+material_thickness);
  }
}

module combined_top() {
  _xy() render() 
    union() {
      translate([-total_width/2 + fridge_width/2, 0, 0]) difference() {
        cube(size=[fridge_width, overall_depth, material_thickness], center=true);
        for (x=[-1,1]) {
          translate([x*(fridge_width/2 - material_thickness/2), 0, 0]) {
            translate([0, overall_depth/2 - microwave_depth / 2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
            translate([0, -overall_depth/2  + (overall_depth - microwave_depth) / 2, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
          }
        }

        translate([0, overall_depth/2 - material_thickness/2, 0]) tabs_at_thirds(fridge_width);
      }

      translate([-total_width/2 + fridge_width + microwave_width / 2, overall_depth / 2 - microwave_depth/2, 0]) difference() {
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
    translate([x*((overall_depth - 2 * feet_width - tab_width) / 4 + tab_width/2), 0, 0]) edge_slot((overall_depth - 2 * feet_width - tab_width) / 2);
  }
}

module fridge_left() {
  _yz() render() difference() {
    cube(size=[overall_depth, fridge_total_height, material_thickness], center=true);
    translate([0, fridge_total_height/2 - material_thickness/2, 0]) {
      translate([-(-overall_depth / 2 + microwave_depth/2 + (overall_depth - microwave_depth/2 - (overall_depth-microwave_depth)/2 - tab_width)/2 + tab_width/2), 0, 0]) 
        edge_slot(overall_depth - microwave_depth/2 - (overall_depth-microwave_depth)/2 - tab_width);
      translate([overall_depth/2, 0, 0]) edge_slot(microwave_depth - tab_width);
      translate([-overall_depth/2, 0, 0]) edge_slot((overall_depth - microwave_depth) - tab_width);
    }
    translate([0, fridge_total_height / 2 - fridge_freezer_height, 0]) slots_at_thirds(overall_depth);
    translate([overall_depth/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(total_height);


    translate([0, -fridge_total_height/2, 0]) cube(size=[overall_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -fridge_total_height/2 + feet_height + material_thickness/2, 0]) edge_slot(tab_width);
    
    // hinge placements
    
    // fridge
    translate([-overall_depth/2 - material_thickness/2 + hinge_d, -fridge_total_height/2 + (fridge_total_height - fridge_freezer_height)/2, 0]) {
      for (y=[-1,1]) {
        translate([0, (fridge_total_height - fridge_freezer_height) / 3 * y, 0]) rotate([0, 0, 90]) edge_slot(hinge_h);
      }
    }
    
    // freezer
    translate([-overall_depth/2 - material_thickness/2 + hinge_d, fridge_total_height/2 - fridge_freezer_height/2, 0]) {
      for (y=[-1,1]) {
        translate([0, fridge_freezer_height / 3 * y, 0]) rotate([0, 0, 90]) edge_slot(hinge_h);
      }
    }

  }
}

module fridge_right() {
  _yz() render() rotate([0, 180, 0]) difference() {
    cube(size=[overall_depth, fridge_total_height, material_thickness], center=true);
    translate([0, fridge_total_height/2 - material_thickness/2, 0]) {
      translate([-overall_depth / 2 + microwave_depth/2 + (overall_depth - microwave_depth/2 - (overall_depth-microwave_depth)/2 - tab_width)/2 + tab_width/2, 0, 0]) 
        edge_slot(overall_depth - microwave_depth/2 - (overall_depth-microwave_depth)/2 - tab_width);
      translate([-overall_depth/2, 0, 0]) edge_slot(microwave_depth - tab_width);
      translate([overall_depth/2, 0, 0]) edge_slot((overall_depth - microwave_depth) - tab_width);
    }
    translate([0, fridge_total_height / 2 - fridge_freezer_height, 0]) slots_at_thirds(overall_depth);
    translate([-overall_depth/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(total_height);

    translate([0, -fridge_total_height/2 + stove_height - material_thickness/2, 0]) slots_at_thirds(overall_depth);

    translate([0, -fridge_total_height/2, 0]) cube(size=[overall_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -fridge_total_height/2 + feet_height + material_thickness/2, 0]) center_feet_cutouts();

    translate([-(overall_depth/2 - microwave_depth / 2), fridge_total_height/2 - microwave_height + material_thickness/2, 0]) edge_slot(tab_width);
  }
}

module fridge_divider() {
  _xy() render() difference() {
    cube(size=[fridge_width, overall_depth, material_thickness], center=true);

    translate([0, overall_depth/2 - material_thickness/2, 0]) tabs_at_thirds(fridge_width);

    for (x=[-1,1]) {
      translate([x * (fridge_width/2 - material_thickness/2), 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(overall_depth);
    }
  }
}

module fridge_door_main() {
  _xz() render() difference() {
    cube(size=[fridge_width, fridge_total_height - fridge_freezer_height, material_thickness], center=true);
    scale([-1, 1, 1]) translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, 0, 0]) {
      translate([0, (fridge_total_height - fridge_freezer_height)/2, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness);
      translate([0, (fridge_total_height - fridge_freezer_height)/2 - fridge_handle_height + handle_thickness/4, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }

    // hinge cutouts
    translate([fridge_width/2 + material_thickness/2 - hinge_w, 0, material_thickness - hinge_d]) {
      for (y=[-1,1]) {
        translate([0, (fridge_total_height - fridge_freezer_height) / 3 * y, 0]) rotate([0, 0, 90]) edge_slot(hinge_h);
      }
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
  _yz() generic_f_door_handle(fridge_handle_height);
}

module fridge_door_assembly() {
  scale([-1, -1, 1]) fridge_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, -(handle_width / 2 - material_thickness/2), (fridge_total_height - fridge_freezer_height)/2 + fridge_y_from_top - fridge_handle_height/2]) 
    rotate([0, 180, 0]) fridge_door_handle();
}

module freezer_door_main() {
  _xz() render() difference() {
    cube(size=[fridge_width, fridge_freezer_height, material_thickness], center=true);
    scale([-1, 1, 1]) translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, 0, 0]) {
      translate([0, -fridge_freezer_height/2, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness);
      translate([0, -fridge_freezer_height/2 + freezer_handle_height - handle_thickness/4, 0]) rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }

    // hinge cutouts
    translate([fridge_width/2 - hinge_w/2, 0, material_thickness - hinge_d]) {
      for (y=[-1,1]) {
        translate([0, fridge_freezer_height / 3 * y, 0]) rotate([0, 0, 90]) edge_slot(w=hinge_h,th=hinge_w);
      }
    }
  }
}

module freezer_door_handle() {
  _yz() generic_f_door_handle(freezer_handle_height);
}

module freezer_door_assembly() {
  scale([-1, -1, 1]) freezer_door_main();
  translate([fridge_width/2 - fridge_x_from_right + material_thickness/2, -(handle_width / 2 - material_thickness/2), -fridge_freezer_height/2 - fridge_y_from_top + freezer_handle_height/2]) 
    freezer_door_handle();
}

module fridge_assembly() {
  translate([-fridge_width/2 + material_thickness/2, 0, 0]) fridge_left();
  translate([fridge_width/2 - material_thickness/2, 0, 0]) fridge_right();
  translate([0, 0, fridge_total_height / 2 - fridge_freezer_height]) fridge_divider();
  translate([-fridge_width/2, -overall_depth/2 - material_thickness/2, -fridge_total_height/2 + (fridge_total_height - fridge_freezer_height) / 2]) 
    rotate([0, 0, fridge_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        fridge_door_assembly();

  translate([-fridge_width/2, -overall_depth/2 - material_thickness/2, fridge_total_height/2 - fridge_freezer_height / 2]) 
    rotate([0, 0, freezer_door_angle]) 
      translate([fridge_width/2, 0, 0]) 
        freezer_door_assembly();
}

module stove_right() {
  _yz() render() difference() {
    cube(size=[overall_depth, stove_height, material_thickness], center=true);
    translate([overall_depth/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(stove_height);
    translate([0, stove_height/2 - material_thickness/2, 0]) tabs_at_thirds(overall_depth);

    translate([0, -sink_height/2, 0]) cube(size=[overall_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) center_feet_cutouts();
  }
}

module stove_door_main() {
  _xz() render() difference() {
    cube(size=[stove_width, stove_height - feet_height, material_thickness], center=true);
    translate([0, -stove_door_gutter/2, 0]) 
      _rounded_rect(material_thickness+0.1, stove_width - stove_door_gutter*2, stove_height - feet_height - stove_door_gutter * 3, stove_door_window_corner_radius);

    translate([0, (stove_height - feet_height)/2 - stove_door_gutter, 0]) {
      for (i=[-1,1]) {
        translate([(stove_width * 0.8 / 2 - handle_thickness/4) * i, 0, 0]) edge_slot(handle_thickness/2);
      }
    }
    
    // hinges
    translate([0, -(stove_height - feet_height) / 2 - material_thickness/2 + hinge_w, material_thickness - hinge_d]) {
      for (y=[-1,1]) {
        translate([stove_width / 3 * y, 0, 0]) edge_slot(hinge_h);
      }
    }
  }
}

module stove_door_handle() {
  _xy() render() difference() {
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
  scale([1, -1, 1]) stove_door_main();
  translate([0, -(handle_width/2 - material_thickness/2), (stove_height - feet_height)/2 - stove_door_gutter]) stove_door_handle();
}

module oven_assembly() {
  translate([stove_width/2, 0, 0]) stove_right();
  group() {
    translate([0, -overall_depth / 2 - material_thickness/2, stove_height/2 - (stove_height - feet_height)/2]) stove_door_assembly();
    translate([0, -overall_depth / 2 + material_thickness/2, stove_height/2 - (stove_height - feet_height)/2 - feet_height]) %oven_door_window();
  }
  stove_control_panel();
}

module sink_right() {
  _yz() rotate([0, 180, 0]) render() difference() {
    cube(size=[overall_depth, sink_height, material_thickness], center=true);
    translate([-overall_depth/2 + material_thickness/2, 0, 0]) rotate([0, 0, 90]) tabs_at_thirds(sink_height);
    translate([0, sink_height/2 - material_thickness/2, 0]) tabs_at_thirds(overall_depth);
    translate([0, -sink_height/2, 0]) cube(size=[overall_depth - 2 * feet_width, feet_height*2, material_thickness+0.1], center=true);
    translate([0, -sink_height/2 + feet_height + material_thickness/2, 0]) edge_slot(tab_width);
    
    for (y=[-1,1]) {
      translate([overall_depth / 2 + material_thickness / 2 - hinge_d, sink_height / 2 - (sink_height - feet_height) / 2 + (sink_height - feet_height)/3 * y, 0]) rotate([0, 0, 90]) edge_slot(hinge_h);
    }
  }
}

module sink_cupboard_door() {
  _xz() render() difference() {
    cube(size=[sink_width, sink_height - feet_height, material_thickness], center=true);
    translate([.8 * sink_width /2, .8 * (sink_height - feet_height) / 2, 0]) cylinder(r=bit_diameter/2, h=material_thickness*10, center=true, $fn=36);

    for (y=[-1,1]) {
      translate([-overall_depth / 2 - material_thickness / 2 + hinge_w, (sink_height - feet_height) / 3 * y, material_thickness - hinge_d]) rotate([0, 0, 90]) edge_slot(hinge_h);
    }
  }
}

module sink_assembly() {
  translate([sink_width/2 - material_thickness/2, 0, 0]) sink_right();
  translate([0, -overall_depth / 2 - material_thickness/2, sink_height/2 - (sink_height - feet_height)/2]) scale([-1, -1, 1]) sink_cupboard_door();
}

module microwave_cupboard_bottom() {
  _xy() render() difference() {
    translate([-material_thickness/2, 0, 0]) cube(size=[microwave_width + material_thickness, microwave_depth, material_thickness], center=true);

    translate([microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([-microwave_width/2 - material_thickness/2, 0, 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    translate([microwave_width/2 - microwave_proper_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    translate([microwave_width/2 - microwave_proper_width - control_panel_width - material_thickness/2, 0, 0]) rotate([0, 0, 90]) edge_slot(tab_width);

    translate([0, microwave_depth/2 - material_thickness/2, 0]) tabs_at_thirds(microwave_width);
  }
}

module microwave_inside_vertical_separator() {
  _yz() rotate([0, 0, -90]) render() difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) single_tab(microwave_depth);
    }
    translate([0, microwave_depth/2-material_thickness/2, 0]) single_tab(microwave_height);
  }
}

module microwave_cupboard_right() {
  _yz() render() rotate([0, 0, -90]) difference() {
    cube(size=[microwave_height, microwave_depth, material_thickness], center=true);
    for (x=[-1,1]) {
      translate([x * (microwave_height/2-material_thickness/2), 0]) rotate([0, 0, 90]) edge_slot(tab_width);
    }
    translate([0, microwave_depth/2 - material_thickness/2, 0]) single_tab(microwave_height);

    // hinge cut
    translate([0, -microwave_depth/2 - material_thickness/2 + hinge_d, 0]) edge_slot(hinge_h);
  }
}

module microwave_right() {
  microwave_inside_vertical_separator();
}

module cupboard_left() {
  microwave_inside_vertical_separator();
}

module microwave_door_main() {
  _xz() render() difference() {
    cube(size=[microwave_proper_width, microwave_height, material_thickness], center=true);
    translate([-microwave_window_gutter/2, 0, 0]) _rounded_rect(material_thickness+0.1, microwave_proper_width-3*microwave_window_gutter, microwave_height - 2 * microwave_window_gutter, stove_door_window_corner_radius);

    for (i=[-1,1]) {
      translate([microwave_proper_width/2 - microwave_window_gutter, (microwave_height * 0.4 - handle_thickness/4) * i, 0]) 
        rotate([0, 0, 90]) edge_slot(handle_thickness/2);
    }
    
    // hinge cutout
    translate([-microwave_proper_width/2 - material_thickness/2 + hinge_d, 0, 0]) rotate([0, 0, 90]) edge_slot(hinge_h);
  }
}

module microwave_door_handle() {
  _yz() render() rotate([0, 0, -90]) difference() {
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
  translate([-microwave_window_gutter/2, material_thickness/2, 0]) %microwave_window();
  translate([microwave_proper_width/2 - microwave_window_gutter, -(microwave_handle_depth / 2 - material_thickness/2), 0]) 
    microwave_door_handle();
}


module cupboard_door() {
  _xz() render() difference() {
    cube(size=[cupboard_width+material_thickness, microwave_height, material_thickness], center=true);

    // handle hole
    translate([(cupboard_width+material_thickness)/2 * 0.8, 0, 0]) cylinder(r=bit_diameter/2, h=material_thickness*2, center=true, $fn=36);

    // hinge
    translate([-(cupboard_width+material_thickness)/2 - material_thickness/2 + hinge_w, 0, material_thickness - hinge_d]) rotate([0, 0, 90]) edge_slot(hinge_h);
  }
}

module microwave_cupboard_assembly() {
  translate([0, 0, -microwave_height/2 + material_thickness/2]) microwave_cupboard_bottom();
  translate([microwave_width/2 - material_thickness/2, 0, 0]) microwave_cupboard_right();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width, 0, 0]) cupboard_left();

  translate([microwave_width/2 - material_thickness/2 - cupboard_width - control_panel_width, 0, 0]) microwave_right();

  microwave_control_panel();

  translate([-microwave_width/2 + microwave_proper_width/2, -microwave_depth / 2 - material_thickness/2, 0]) 
    microwave_door_assembly();
  
  translate([microwave_width/2, -microwave_depth/2 - material_thickness/2, 0]) translate([-cupboard_width/2 - material_thickness/2, 0, 0]) scale([-1, -1, 1]) cupboard_door();
}

module sink_blank() {
  scale(25.4) union() {
    translate([0, 0, 1/4]) cube(size=[11 + 13/16, 8 + 3/16, 1/2], center=true);
    translate([0, 0, - (3 + 3/8) / 2]) cube(size=[(11 + 13/16) - (9/16 * 2), (8 + 3/16) - (9/16 * 2), 3 + 3/8], center=true);
  }
}

module oven_door_window() {
  _xz()
  render()
  assign(corner_radius = 10)
  assign(w = stove_width - stove_door_gutter*2 + corner_radius*2)
  assign(h = stove_height - feet_height - stove_door_gutter * 3 + corner_radius*2)
  difference() {
    _rounded_rect(3, w, h, corner_radius);
    for (x = [-1:1], y = [-1:1]) {
      translate([x * (w / 2 - corner_radius / 2), y * (h / 2 - corner_radius / 2), 0]) cylinder(r=1.6, h=3+0.1, center=true, $fn=36);
    }

    for (y=[-3:3]) {
      translate([0, y * (h * 0.8 / 8), 0]) cube(size=[w * 0.8, 5, 3+0.1], center=true);
    }
  }
}

module microwave_window() {
  _xz()
  // render()
  assign(corner_radius = 10)
  assign(w = microwave_proper_width-3*microwave_window_gutter + corner_radius*2)
  assign(h = microwave_height - 2 * microwave_window_gutter + corner_radius*2)
  difference() {
    square(size=[w, h], center=true);
    // _rounded_rect(3, w, h, corner_radius);
    for (x = [-1:1], y = [-1:1]) {
      translate([x * (w / 2 - corner_radius / 2), y * (h / 2 - corner_radius / 2), 0]) circle(r=1.6, h=3+0.1, center=true, $fn=36);
    }

    assign(circle_r = 3.2)
    assign(num_circles_w = w / circle_r / 2 / 2)
    assign(w_b = floor(num_circles_w / 2) - 1)
    assign(num_circles_h = h / circle_r / 2 / 2)
    assign(h_b = floor(num_circles_h / 2) - 1)
    // render() 
    union() for (x=[-w_b:w_b], y=[-h_b:h_b]) {
      translate([x * 4 * circle_r, y * 4 * circle_r + abs(x) % 2 * 2 * circle_r, 0]) 
        // render() 
          circle(r=circle_r, h=3.01, center=true);
    }
  }
}

module assembled() {
  translate([0, overall_depth/2 - material_thickness/2, 0]) back_plate();

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

  translate([-total_width/2 + fridge_width + microwave_width / 2, overall_depth / 2 - microwave_depth / 2, fridge_total_height/2 - microwave_height/2]) 
  {
    microwave_cupboard_assembly();
  }
  
  
  translate([-total_width/2 + fridge_width + stove_width + sink_width/2, 0, 0]) %sink_blank();
}

module panelized() {
  // translate([0, 0, material_thickness / -2 + hinge_d / 2]) {
  //   freezer_door_main();
  //   translate([fridge_width / 2 + bit_diameter + handle_width / 2, 0, 0]) freezer_door_handle();
  // }
  // translate([0, 0, material_thickness / -2 + hinge_d / 2]) {
  //   fridge_door_main();
  //   // translate([fridge_width / 2 + bit_diameter + handle_width / 2, 0, 0])fridge_door_handle();
  // }
  // microwave_door_main();
  // microwave_door_handle();
  // back_plate();
  // translate([-overall_depth/2 - bit_diameter/2, 0, 0]) {
  //   fridge_right();
  //   translate([overall_depth+bit_diameter, 0, 0]) fridge_left();
  // }
  // translate([0, (microwave_height + bit_diameter) / -2, material_thickness / -2 + hinge_d / 2]) {
  //   cupboard_left();
  //   translate([microwave_depth + bit_diameter, 0, 0]) microwave_cupboard_right();
  //   translate([-(microwave_depth + bit_diameter), 0, 0]) microwave_right();
  //   translate([0, microwave_height + bit_diameter, 0]) cupboard_door();
  // }
  // microwave_right();
  // translate([-total_width/2 + material_thickness + (sink_width + stove_width) + bit_diameter + sink_width/2, overall_depth + bit_diameter, 0])cupboard_door();
  // microwave_inside_vertical_separator();
  
  // panel 1
  stove_door_main();
  translate([5, -25, 0]) rotate([0, 0, 45]) stove_door_handle();
  translate([stove_width + bit_diameter, 0, 0]) sink_cupboard_door();
  translate([stove_width * 1.5 + bit_diameter * 2 + overall_depth / 2, 0, 0]) sink_right();
  translate([stove_width * 1.5 + bit_diameter * 2 + overall_depth / 2, stove_height - feet_height/2 + bit_diameter, 0]) stove_right();
  translate([0, overall_depth + bit_diameter - feet_height/2, 0]) fridge_divider();

  // panel 2
  // translate([-total_width/2 + material_thickness + fridge_width + (sink_width + stove_width) / 2 + bit_diameter - material_thickness, overall_depth/2 - microwave_depth - bit_diameter - overall_depth / 2, 0]) 
  //   rotate([0, 0, 180]) combined_countertop();
  // combined_top();
  // translate([-total_width/2 + microwave_width / 2 + material_thickness, overall_depth / 2 - microwave_depth - bit_diameter - overall_depth - bit_diameter - microwave_depth / 2 + material_thickness, 0]) microwave_cupboard_bottom();  
  // translate([-total_width/2 + microwave_depth / 2, -overall_depth / 2 - bit_diameter - microwave_height / 2, 0]) microwave_inside_vertical_separator();

  // panel 3
  // combined_bottom();
}

// assembled();
projection(cut=true) 
//   translate([0, 0, -material_thickness/2 + 0.1]) 
//   panelized();
oven_door_window();

// oven_door_window();
// microwave_window();
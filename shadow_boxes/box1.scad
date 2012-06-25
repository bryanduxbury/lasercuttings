include <params.scad>

design_w = box_w - 2 * face_border;
design_h = box_h - 2 * face_border;

square_spacing = 10;

num_squares = 7;
square_spacing_w = design_w / num_squares;
square_spacing_h = design_h / num_squares;
square_w = square_spacing_w - square_spacing;
square_h = square_spacing_h - square_spacing;
square_corner_radius = 3;

module rounded_square(w, h, r) {
  union() {
    cube(size=[w, h - r*2, material_thickness*2], center=true);
    cube(size=[w - r * 2, h, material_thickness*2], center=true);
    for(a=[0, 90, 180, 270]) {
      rotate([0, 0, a]) translate([w / 2 - r, h / 2 - r, 0]) cylinder(r=r, h=material_thickness*2, center=true, $fn=50);
    }
  }
}

module face() {
  difference() {
    cube(size=[box_w, box_h, material_thickness], center=true);
    intersection() {
      cube(size=[design_w, design_h, material_thickness*2], center=true);
      rotate([0, 0, 45]) {
        for(x=[-floor(num_squares/2)*2 : floor(num_squares/2)*2]) {
          for(y=[-floor(num_squares/2)*2 : floor(num_squares/2)*2]) {
            translate([x * square_spacing_w, y * square_spacing_h, 0]) 
              // cube(size=[square_w, square_h, material_thickness*2], center=true);
              rounded_square(square_w, square_h, square_corner_radius);
          }
        }
      }
      
    }
  }
  
}

module side() {
  
}

module back() {
  
}

face();
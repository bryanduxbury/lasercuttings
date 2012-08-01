difference() {
  cube(size=[18*25, 14*25, 8*25], center=true);
  translate([0, 0, 3.5]) cube(size=[18*25 - 18, 14*25 - 6, 8*25 - 6], center=true);
}

translate([0, 0, 7*25]) rotate([-22.5, 0, 0]) cube(size=[18*25, 14*25, 2*25], center=true);
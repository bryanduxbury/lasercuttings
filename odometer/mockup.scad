use <../publicDomainGearV1.1.scad>

module sun() {
  // render()
  // gear(mm_per_tooth=1, thickness=3, number_of_teeth=48);
  cylinder(r=outer_radius(mm_per_tooth=1, thickness=3, number_of_teeth=48), h=3, center=true);
}

module annulus() {
  difference() {
    cylinder(r=outer_radius(mm_per_tooth=1, thickness=3, number_of_teeth=48*11) + 10, h=3, center=true);
    gear(mm_per_tooth=1, thickness=3.1, number_of_teeth=48*11);
  }
}

module planet() {
  // render() 
  gear(mm_per_tooth=1, thickness=3, number_of_teeth=48*5);
}

sun();
for (i=[0:2]) rotate([0, 0, i*360/3]) 
translate([pitch_radius(mm_per_tooth=1, thickness=3, number_of_teeth=48) + pitch_radius(mm_per_tooth=1, thickness=3, number_of_teeth=48*5), 0, 0]) {
  planet();
}

annulus();
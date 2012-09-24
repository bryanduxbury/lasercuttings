use <../publicDomainGearV1.1.scad>

function center_distance(t1, t2, mm_per_tooth) = (t1+t2)/(3.1415926 / mm_per_tooth * 2);

render() gear(mm_per_tooth=1, number_of_teeth = 256, thickness=3);

for (i=[0:12]) {
  rotate([0, 0, i*360/13]) translate([0, center_distance(256, 32, 1), 0]) render() gear(mm_per_tooth=1, number_of_teeth=32, thickness=3);
}

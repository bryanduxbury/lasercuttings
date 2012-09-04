
use <publicDomainGearV1.1.scad>

function center_distance(t1, t2, mm_per_tooth) = (t1+t2)/(3.1415926 / mm_per_tooth * 2);

render() gear(mm_per_tooth=6, number_of_teeth = 12, thickness=3);

echo("time", $t);
for (a=[0:2]) {
  rotate([0, 0, a*120 + -360 * $t]) translate([center_distance(12, 6, 6), 0, 0]) rotate([0, 0, $t * -2 * 360]) render() gear(mm_per_tooth=6, number_of_teeth = 6, thickness=3);
}

rotate([0, 0, 360 / 24 / 2 + $t * -360 * 4]) difference() {
  render() gear(mm_per_tooth=6, number_of_teeth=36, thickness=3);
  render() gear(mm_per_tooth=6, number_of_teeth=24, thickness=3.1);
}

translate([center_distance(36,28,6), 0, 0]) {
  rotate([0, 0, 360/28/2 + 360/24/4 + -($t * -360 * 4) * 36/28]) render() gear(mm_per_tooth=6, number_of_teeth = 28, thickness=3);
  rotate([0, 0, 30]) translate([center_distance(28,16,6), 0, 0]) render() gear(mm_per_tooth=6, number_of_teeth = 16, thickness=3);
  rotate([0, 0, -30]) translate([center_distance(28,16,6), 0, 0]) render() gear(mm_per_tooth=6, number_of_teeth = 16, thickness=3);
}
translate([-center_distance(36,28,6), 0, 0]) rotate([0, 0, 360/28/2 + 360/24/4 + -($t * -360 * 4) * 36/28]) render() gear(mm_per_tooth=6, number_of_teeth = 28, thickness=3);
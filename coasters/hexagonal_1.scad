total_r = 75;
gutter_w = 4;
fillet_r = 1.5;

section_r = total_r / 3.5;

gutter_adjusted_r = section_r - gutter_w / 2;

fillet_prime = fillet_r / cos(30);
fillet_double_prime = sqrt(fillet_r*fillet_r + fillet_prime * fillet_prime);
z = tan(30) * section_r;
// hypot = sqrt(hex_r*hex_r + z * z);
// 

// gutter_vertical = gutter_w / 2 / sin(30);

module wedge() {
  // render() translate([0, -fillet_r / sin(30) / 2, 0]) intersection() {
  //   render() union() {
  //     translate([0, fillet_r / sin(30), 0]) circle(r=fillet_r, $fn=36);
  //     for (a=[-30:30]) translate([0, fillet_r / sin(30), 0]) rotate([0, 0, a]) {
  //        translate([0, hex_r*2, 0]) square(size=[fillet_r*2, hex_r*4], center=true);
  //     }
  //   }
  // render() 
    union() {
      // rotate([0, 0, 30]) {
        translate([fillet_r+gutter_w/2, section_r - fillet_r - gutter_w/2, 0]) circle(r=fillet_r, $fn=36);
        translate([fillet_r+gutter_w/2, (section_r - fillet_r - gutter_w/2)/2, 0]) square(size=[fillet_r*2, section_r - fillet_r - gutter_w/2], center=true);
        // translate([tan(30) * section_r, section_r/2, 0]) square(size=[tan(30) * section_r - fillet_double_prime, section_r], center=true);
      // }
      // rotate([0, 0, -30]) {
      //   translate([-fillet_r, hex_r - fillet_r, 0]) circle(r=fillet_r, $fn=36);
      //   translate([-fillet_r, hex_r/2 - fillet_r, 0]) square(size=[fillet_r*2, hex_r], center=true);
      //   translate([-(z - fillet_double_prime)/2 - fillet_r, hex_r/2, 0]) square(size=[z - fillet_double_prime, hex_r], center=true);
      // }
      // translate([0, hypot - fillet_prime, 0]) circle(r=fillet_r, $fn=36);
    }
  // }
}

wedge();

// module hex() {
//   for (a = [0:5]) rotate([0, 0, 60 * a]) {
//     rotate([0, 0, 30]) translate([0, gutter_vertical, 0])  wedge();
//   }
// }
// 
// 
// difference() {
//   circle(r=75, $fn=1000);
//   
//   for (x=[0:3]) rotate([0, 0, x*60])  {
//     for (i=[-3:3]) {
//       translate([0, i * (hex_r * 2 + gutter_vertical + gutter_w/2), 0]) hex();
//     }
//   }
//   
//   
//   // hex();
//   // for (i=[0:6]) rotate([0, 0, i*60]) translate([0, hex_r*2 + gutter_vertical * 1.5, 0]) {
//   //   hex();
//   // }
//   // 
//   // #for (i=[0:6]) rotate([0, 0, i*60]) translate([0, (hex_r*3 + gutter_vertical * 2) / cos(30), 0]) {
//   //   rotate([0, 0, 30]) hex();
//   // }
//   // 
//   // for (i=[0:6]) rotate([0, 0, i*60]) translate([0, hex_r*4 + gutter_vertical * 3, 0]) {
//   //   hex();
//   // }
// 
// }

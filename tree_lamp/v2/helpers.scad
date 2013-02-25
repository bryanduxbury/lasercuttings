__xy_color = [200, 32, 32];
__xz_color = [32, 200, 32];
__yz_color = [32, 32, 200];

// module _xy(t, lay_flat=false) {
//   color(__xy_color) ext(t) child(0);
// }
// 
// module _xz(t, lay_flat=false) {
//   color(__xy_color) {
//     if (! lay_flat) {
//       rotate([90, 0, 0])
//       ext(t) child(0);
//     }
// 
//     if (lay_flat) {
//       child(0);
//     }
//   }
// }
// 
// module _yz(t, lay_flat=false) {
//   color(__yz_color) {
//     if (! lay_flat) {
//       rotate([0, 0, 90])
//       rotate([90, 0, 0])
//       ext(t) child(0);
//     }
// 
//     if (lay_flat) {
//       child(0);
//     }
//   }
// }

module ext(t) {
  linear_extrude(height=t, center=true) child(0);
}
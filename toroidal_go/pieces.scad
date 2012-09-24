module piece() {
  difference() {
    circle(r=4.5, $fn=36);
    circle(r=1.6, $fn=36);
    square(size=[3, 5], center=true);
  }
  
}

for (x=[0:5]) {
  for (y=[0:11]) {
    translate([11*x, 11*y, 0]) piece();
  }
}

function polar(radius, theta) = [radius * cos(theta), radius * sin(theta)];

w=1;
od=40;
$fn=72;
n=16;

assign(ra = (od/2-w) / (1 / (2 * sin(360/n/2))+1))
union() {
  echo ("ra:", ra);
  difference() {
    circle(r=od/2);
    circle(r=od/2-w);
  }
  difference() {
    circle(r=(od-4*ra+2*w)/2);
    circle(r=(od-4*ra+2*w)/2-w);
  }
  for (i=[0:n-1]) {
    rotate([0, 0, 360/n * i]) 
    translate([od/2-ra, 0, 0]) 
    #difference() {
      circle(r=ra);
      // circle(r=ra/2-w);
    }
  }
  // difference() {
  //   polygon(points=[
  //     polar((od-20+2*w)/2, 90),
  //     polar((od-20+2*w)/2, 210),
  //     polar((od-20+2*w)/2, 330)
  //   ]);
  //   polygon(points=[
  //     polar((od-20+2*w)/2 - 2 * w, 90),
  //     polar((od-20+2*w)/2 - 2 * w, 210),
  //     polar((od-20+2*w)/2 - 2 * w, 330)
  //   ]);
  // }
  // difference() {
  //   polygon(points=[
  //     polar((od-20+2*w)/2 / 2, 270),
  //     polar((od-20+2*w)/2 / 2, 390),
  //     polar((od-20+2*w)/2 / 2, 510)
  //   ]);
  //   polygon(points=[
  //     polar((od-20+2*w)/2 / 2 - 2*w, 270),
  //     polar((od-20+2*w)/2 / 2 - 2*w, 390),
  //     polar((od-20+2*w)/2 / 2 - 2*w, 510)
  //   ]);
  // }
  
}

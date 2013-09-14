w = 4;

side = 27;
r = (side/2) / sin(360/5/2);
echo("r", r);
x = (side/2) / tan(360/5/2);
echo ("x", x);
rr = (x - w) /cos(360/5/2);
echo("rr", rr);

hole_d = 1.5;

function polar(radius, theta) = [radius * cos(theta), radius * sin(theta)];

difference() {
  union() {
    polygon(points=[
      polar(r, 0),
      polar(r, 360/5),
      polar(r, 360/5*2),
      polar(r, 360/5*3),
      polar(r, 360/5*4)
    ]);
  
    for (a=[0:4]) {
      translate(polar(x - w, 360 / 5 * (a + 0.5))) circle(r=side/2 - w); 
    }
  }

  polygon(points=[
    polar(rr, 0),
    polar(rr, 360/5),
    polar(rr, 360/5*2),
    polar(rr, 360/5*3),
    polar(rr, 360/5*4)
  ]);

  for (a=[0:4]) {
    translate(polar(x - w, 360 / 5 * (a + 0.5))) circle(r=(side - 2*w)/2 - w, $fn=36); 
  }
}
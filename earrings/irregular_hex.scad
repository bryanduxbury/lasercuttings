r = 15;

function polar(radius, theta) = [radius * cos(theta), radius * sin(theta)];

// srand(1);

for (a=[0:5]) {
  polygon(points=[
    polar(r, 0),
    polar(r, 49),
    polar(r, 162),
    polar(r, 180),
    polar(r, 299),
    polar(r, 311)
  ]);
  
}

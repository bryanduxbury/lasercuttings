w = 20;
h = 10;
d = 10;

translate([0, 0, h/2+1]) cube(size=[w*.8, d*.8, 1], center=true);
translate([0, 0, h/2]) cube(size=[w, d, 1], center=true);
translate([0, 0, -h/2]) cube(size=[w, d, 1], center=true);
translate([0, 0, -h/2-1]) cube(size=[w*.8, d*.8, 1], center=true);

translate([0, -3, h/2+4]) cube(size=[6, 1, 6], center=true);

color([240/255, 240/255, 240/255, 0.5]) cube(size=[w-1, d-1, h -1], center=true);
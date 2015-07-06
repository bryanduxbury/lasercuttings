w = 20;
h = 8;

bearing_h = 1/2;
bearing_w = 1.5;

bar_spacing = 3.5;

blx1 = 3;
bly1 = 1;

blx2 = 12;
bly2 = 1;

bbx1 = 8;
// bby1 = h - 3/4 - bearing_h;
bby1 = 6.5;

bbx2 = 17;
// bby2 = h - 3/4 - bearing_h;
bby2 = 6.5;

function bar_len() = sqrt(pow(bbx1 - blx1, 2) + pow(bby1 - bly1, 2));
function min_angle() = acos((bbx1 - blx1) / bar_len()) + 90;
function dx(angle) = 0;
function dy(angle) = 0;

function max_angle() = -45;

module bearing_pivot() {
  color("red")
  cylinder(r=1/2/2, h=1, center=true);
}

module bar() {
  color("green")
  translate([0, bar_len()/2, 0]) 
  cube(size=[1.5, bar_len(), 1/8], center=true);
}

module lid_assembly() {
  bearing_pivot();

  translate([blx2 - blx1, 0, 0]) bearing_pivot();

  color("blue")
  translate([-blx1 + 3/4 / 2, h / 2 - bly1, 0])
    cube(size=[3/4, h, 1], center=true);
  
  color("blue")
  translate([w/2 - blx1, h - 3/4 / 2 - bly1, 0]) 
    cube(size=[w, 3/4, 1], center=true);
}

angle = min_angle() - abs(max_angle() - min_angle()) * $t;

// side plate (reference rectangle)
translate([w/2, h/2, 0]) 
  cube(size=[w, h, 1/8], center=true);

translate([bbx2, bby2, 0]) {
  bearing_pivot();
  rotate([0, 0, angle]) 
  bar();
}

translate([bbx1, bby1, 0]) {
  bearing_pivot();

  rotate([0, 0, angle]) {
    bar();
    translate([0, bar_len(), 0])
      rotate([0, 0, -angle]) 
        lid_assembly();
  }
}

echo("angle", angle);
echo("bar len", bar_len());
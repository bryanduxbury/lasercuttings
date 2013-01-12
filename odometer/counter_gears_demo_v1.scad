use <../publicDomainGearV1.1.scad>

function center_distance(t1, t2) = pitch_radius(number_of_teeth=t1, mm_per_tooth = mm_per_tooth) 
  + pitch_radius(number_of_teeth=t2, mm_per_tooth = mm_per_tooth);

t = 5.2;

d = 1/8 * 25.4;

mm_per_tooth = 5;

module full_connecting_gear() {
  color([64/255, 64/255, 64/255]) 
  render()
  gear(mm_per_tooth = mm_per_tooth, hole_diameter = d, number_of_teeth = 8, thickness = t);
}

module partial_connecting_gear() {
  color([96/255, 96/255, 96/255])
  render()
  difference() {
    union() {
      for (a=[0:3]) {
        rotate([0, 0, 45 + 90*a]) gear(mm_per_tooth = mm_per_tooth, hole_diameter = d, number_of_teeth = 8, thickness = t, teeth_to_hide=7);
      }
      cylinder(r=root_radius(mm_per_tooth=mm_per_tooth, number_of_teeth=8), h=t, center=true, $fn=36);
    }
    cylinder(r=d/2, h=t*2, center=true, $fn=36);
  }
}

module connecting_gear_assembly() {
  full_connecting_gear();
  translate([0, 0, -t]) partial_connecting_gear();
}

module two_tooth_gear() {
  color([192/255, 32/255, 32/255])
  render()
  difference() {
    union() {
      rotate([0, 0, 360/20*4.5]) gear(mm_per_tooth = mm_per_tooth, hole_diameter = d, number_of_teeth = 20, teeth_to_hide=18, thickness = t);
      cylinder(r=root_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20), h=t, center=true, $fn=72);
    }
    cylinder(r=d/2, h=t*2, center=true, $fn=36);
    translate([0, root_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20)/2, 0]) cylinder(r=d/2-0.5, h=t*2, center=true, $fn=36);
  }
}

module retaining_disc() {
  render()
  difference() {
    cylinder(r=outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20), h=t, center=true, $fn=72);
    cylinder(r=d/2, h=t*2, center=true, $fn=36);
    translate([-outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20), 0, 0]) {
      assign(base_block_size = outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20) - root_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20))
      difference() {
        translate([base_block_size/2, 0, 0]) cube(size=[base_block_size, mm_per_tooth, t*2], center=true);
        translate([outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20), 0, 0]) rotate([0, 0, 360/20*4.5]) gear(mm_per_tooth = mm_per_tooth, hole_diameter = d, number_of_teeth = 20, teeth_to_hide=18, thickness = t*2+0.1);
      }
    }
  }
}

module drive_gear_assembly() {
  two_tooth_gear();
  translate([0, 0, -t]) retaining_disc();
}

module complete_gear() {
  rotate([0, 0, 360/20*0.5]) render() gear(mm_per_tooth = mm_per_tooth, hole_diameter = d, number_of_teeth = 20, thickness = t);
}

module carrier_plate() {
  color([32/255, 192/255, 32/255])
  difference() {
    cube(size=[2 * outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20) + 2 * center_distance(mm_per_tooth = mm_per_tooth, t1=20,t2=8), 
      2 * outer_radius(mm_per_tooth = mm_per_tooth, number_of_teeth = 20),
      t], center=true);
    for (i=[-1:1]) {
      translate([i * center_distance(mm_per_tooth = mm_per_tooth, t1=20,t2=8), 0, 0])
      cylinder(r=d/2 - 0.5, h=t*2, center=true, $fn=36);
    }
  }
}

projection(cut=true) {
  // retaining_disc();
  // two_tooth_gear();
  // partial_connecting_gear();
  // full_connecting_gear();
  carrier_plate();
}

// translate([-center_distance(20,8), 0, 0]) rotate([0, 0, min($t, 0.1) / 0.1 * 360/20*2]) 
  // complete_gear();
// translate([center_distance(20,8), 0, 0]) rotate([0, 0, -360/20 + $t * 360]) 
  // drive_gear_assembly();
// assign(x = $t % 0.1 / 0.1)
// assign()
// rotate([0, 0, min($t, 0.1) / 0.1 * -90]) connecting_gear_assembly();

// translate([0, 0, -2*t]) carrier_plate();
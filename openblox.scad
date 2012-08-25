central_dimension = 60;
tab_dimension = 10;

module hook_tab() {
  
}

module long_tab() {
  square(size=[central_dimension/2*sqrt(2), tab_dimension], center=true);
  translate([central_dimension/2*sqrt(2)/2 - 10, tab_dimension/2 + 3.5, 0]) {
    square(size=[10, 7], center=true);
    translate([-5, 3, 0]) scale([2, 1]) circle(r=5);
  }
}


module short_tab() {
  square(size=[central_dimension/2, tab_dimension], center=true);
  rotate([180, 0, 0]) translate([central_dimension/2/2 - 10, tab_dimension/2 + 3.5, 0]) {
    square(size=[10, 7], center=true);
    translate([-5, 3, 0]) scale([2, 1]) circle(r=5);
  }
}

module flap_body() {
  polygon(points=[
    [0,0],
    [central_dimension/2,0],
    [central_dimension/2,central_dimension/2]
  ]);
}

module flap_connector(folds) {
  square(size=[central_dimension/2, tab_dimension], center=true);
}

module flap_assembly(folds) {
  translate([central_dimension/4, tab_dimension/2, 0]) union() {
    if (folds == 1) {
      #translate([0, tab_dimension/2, 0]) square(size=[central_dimension/2, 0.001], center=true);
      #translate([central_dimension/4, tab_dimension/2 + central_dimension/4, 0]) square(size=[0.001, central_dimension/2], center=true);
      #translate([0, tab_dimension/2 + central_dimension/4, 0]) rotate([0, 0, -45]) square(size=[0.01, sqrt(2)*central_dimension/2], center=true);
      #translate([0, -tab_dimension/2, 0]) square(size=[central_dimension/2, 0.001], center=true);
    } else {
      translate([0, tab_dimension/2 + central_dimension/4, 0]) rotate([0, 0, 45]) translate([0, tab_dimension/2, 0]) long_tab();
      translate([central_dimension/4 + tab_dimension/2, tab_dimension/2 + central_dimension/4, 0]) rotate([0, 0, 90]) short_tab();
      translate([-central_dimension/4, tab_dimension/2, 0]) flap_body();
      flap_connector();
    }
  }
}

module hook_cutout() {

}

module central_body() {
  difference() {
    square(size=[central_dimension, central_dimension], center=true);
    for (a=[0:3]) rotate([0, 0, a*90-30]) {
      translate([20, 0, 0]) scale([2, 1, 1]) circle(r=5);
      // translate([20, 1, 0]) square(size=[20, 2], center=true);
      //       rotate([0, 0, 45]) translate([20, -1, 0]) square(size=[20, 2], center=true);
    }
  }
}

module panel_assembly(folds) {
  for (a=[0:3]) {
    rotate([0, 0, a*90]) translate([-central_dimension/2, central_dimension/2, 0]) flap_assembly(folds);
  }
  if (folds!=1) {
    central_body();
  }
}

panel_assembly(0);
translate([central_dimension*3, 0, 0]) panel_assembly(1);
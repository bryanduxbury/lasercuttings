module felt_tab(w, tab_thickness) {
  polygon(points=[
    [-w/2, -tab_thickness/2],
    [w/2, -tab_thickness/2],
    [w/2 - tab_thickness, tab_thickness/2],
    [-w/2 + tab_thickness, tab_thickness/2],
  ]);
}

module felt(h, w, felt_thickness, tab_thickness, card_thickness) {
  union() {
    square(size=[w+0.2, h+0.2], center=true);
    for (i=[0,1]) {
      rotate([0, 0, i*180]) {
        translate([-w / 2 - tab_thickness/2 - 0.1, 0, 0]) rotate([0, 0, 90]) felt_tab(h, tab_thickness);
        translate([0, h / 2 + tab_thickness/2 + 0.1, 0]) felt_tab(w, tab_thickness);
      }
    }
  }
}

module card(h, w, felt_thickness) {
  square(size=[w - felt_thickness*2, h-felt_thickness*2], center=true);
}

// felt(45.4, 71.4, 1.5, 10, 1);
card(45.4, 71.4, 1.5);

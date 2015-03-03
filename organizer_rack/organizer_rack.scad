t = 19; // 3/4" mdf (approx)

organizer_w = 9 * 25.4;
organizer_d = 14 * 25.4;
organizer_h = 2 * 25.4;

module organizer() {
  color("white")
  cube(size=[organizer_w, organizer_d, organizer_h], center=true);
}

z = t * 6 + organizer_h * 5;

translate([(organizer_w + t * 2) / 2, 0, 0]) {
  translate([0, 0, t/2]) 
  cube(size=[organizer_w, organizer_d, t], center=true);

  translate([0, 0, z - t/2]) 
  cube(size=[organizer_w, organizer_d, t], center=true);

  
  color("pink")
  translate([-(organizer_w) / 2 - t / 2, 0, z/2]) 
  cube(size=[t, organizer_d, z], center=true);

  translate([0, 0, organizer_h / 2 + t]) 
  for (i=[0:4]) {
    translate([0, 0, (organizer_h + t) * i]) 
    organizer();
  }
  
  
  
  color("blue")
  translate([organizer_w / - 2 + 12 / 2, 0, t + organizer_h + t/2]) 
  cube(size=[12, organizer_d, t], center=true);
}



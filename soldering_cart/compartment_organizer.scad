function compartment_organizer_w() = 14;
function compartment_organizer_d() = 9;
function compartment_organizer_h() = 2;

module compartment_organizer() {
  color("orange", 0.5)
  cube(size=[
      compartment_organizer_w(),
      compartment_organizer_d(),
      compartment_organizer_h()],
    center=true);
}

compartment_organizer();
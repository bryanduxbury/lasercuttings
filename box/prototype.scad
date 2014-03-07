
assign(alpha=400)
assign(beta=150)
assign(gamma=900)
assign(delta=100)
intersection() {
  linear_extrude(height=500) {
    intersection_for(a = [0:3]) {
      rotate([0, 0, a * 90]) translate([0, alpha-beta, 0]) circle(r=alpha, $fn=240);
    }
  }
  translate([0, 0, -(gamma-delta)]) sphere(r=gamma, $fn=240);
}

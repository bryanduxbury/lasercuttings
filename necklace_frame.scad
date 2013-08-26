
t = 3;
k = 0.005 * 25.4;

nail_d = 1;
nail_separation = 25.4;

frame_width = 25.4;

frame_height = 8 * 25.4;

difference() {
  square(size=[nail_separation * 6, frame_height], center=true);
  square(size=[nail_separation * 6 - 2 * frame_width, frame_height - 2 * frame_width], center=true);

  translate([-nail_separation * 6 / 2 + nail_separation/2, frame_height/2 - frame_width/2, 0]) for (x=[0:5]) {
    translate([x * nail_separation, 0, 0]) circle(r=nail_d/2 - k/2, center=true, $fn=36);
  }
}

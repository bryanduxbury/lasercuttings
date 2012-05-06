// arguments
laser_beam_width=.005*25.4;
// material_thickness=3;
material_thickness=0.322 * 25.4;
h = 200;
w = 400;
d = 300;

lid_h = 60;

// calculated
bottom_h = h-lid_h;

strut_width=10;
strut_pivot_r=5;
strut_pivot_hole_r=5.5;

rear_strut_sagitta_ratio=3.5;
rear_strut_bottom_dx = 120;
rear_strut_bottom_dy = 50;
rear_strut_top_dx = 50;
rear_strut_top_dy = 0;
rear_strut_max_angle = 175;
// rear_strut_max_angle = 152.5;


rear_strut_delta_x = abs(rear_strut_bottom_dx - rear_strut_top_dx);
rear_strut_delta_y = abs((bottom_h / 2 - rear_strut_bottom_dy) + (lid_h / 2 - rear_strut_top_dy));
rear_strut_length = sqrt(pow(rear_strut_delta_x, 2) + pow(rear_strut_delta_y, 2));
rear_strut_init_angle = asin(rear_strut_delta_y / rear_strut_length);
// rear_strut_max_angle = rear_strut_init_angle;


front_strut_bottom_dx = 50;
front_strut_bottom_dy = 50;
front_strut_top_dx = -130;
front_strut_top_dy = 0;

front_strut_delta_x = abs(front_strut_bottom_dx - front_strut_top_dx);
front_strut_delta_y = abs((bottom_h / 2 - front_strut_bottom_dy) + (lid_h / 2 - front_strut_top_dy));
front_strut_length = sqrt(pow(front_strut_delta_x, 2) + pow(front_strut_delta_y, 2));
front_strut_init_angle = asin(front_strut_delta_y / front_strut_length);
echo("expected front strut init angle:", front_strut_init_angle);

bottom_bar = abs(front_strut_bottom_dx - rear_strut_bottom_dx);
diagonal_len = sqrt(pow(rear_strut_length, 2) + pow(bottom_bar, 2) - 2*rear_strut_length*bottom_bar*cos(rear_strut_max_angle));

echo("Diagonal len:", diagonal_len);

top_bar = abs(front_strut_top_dx - rear_strut_top_dx);
theta_upper = acos(
  (pow(front_strut_length, 2) + pow(diagonal_len, 2) - pow(top_bar, 2))
  /(2*front_strut_length*diagonal_len)
);
x = 
  (pow(diagonal_len, 2) + pow(bottom_bar, 2) - pow(rear_strut_length, 2))
  /(2*diagonal_len*bottom_bar);
theta_lower = acos(min(max(x, -1), 1));
echo("theta_lower:", theta_lower);

front_strut_max_angle = theta_lower + theta_upper;
echo ("front_strut_max_angle", front_strut_max_angle);

lid_angle_top = acos((pow(top_bar, 2) + pow(diagonal_len, 2) - pow(front_strut_length, 2))/(2*top_bar*diagonal_len));
lid_angle_bottom = (180 - rear_strut_max_angle - theta_lower);
lid_angle = lid_angle_top + lid_angle_bottom;
echo("lid_angle:", lid_angle);
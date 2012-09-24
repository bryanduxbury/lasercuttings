y_sweep, step, a, asym_angle = ARGV[0..3].map {|x| x.to_f}

b = a * Math.tan(asym_angle * Math::PI / 180) / 2
$stderr.puts b

def x(y, a, b)
  # x**2 / a**2 - y**2 / b**2 = 1
  #   x**2 / a**2 = 1 + y**2 / b**2
  #   x**2 = (1 + y**2 / b**2) * a**2
  Math.sqrt((1 + y**2 / b**2) * a**2)
end

points = []

# points << [ (y_sweep / 2) / Math.tan(asym_angle/2 * Math::PI / 180), y_sweep / 2]
# 
# points << [0, 5]
# points << [0, -5]
# 
# points << [ (y_sweep / 2) / Math.tan(asym_angle/2 * Math::PI / 180), -y_sweep / 2]

points << [0, y_sweep / 2]
points << [0, -y_sweep / 2]

((-y_sweep/2)..(y_sweep/2)).step(step) do |y|
  $stderr.puts y
  points << [x(y, a, b), y]
end

puts points.inspect
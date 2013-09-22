def rotate(x,y,theta)
  [Math.cos(theta/180 * Math::PI) * (x) - Math.sin(theta/180 * Math::PI) * (y), Math.sin(theta/180 * Math::PI) * (x) + Math.cos(theta/180 * Math::PI) * (y)]
end


angle_incr = 300 / 15.0
offset = -90 + 30 - angle_incr/2
(1..4).each_with_index do |led, idx|
  xy = rotate(-12.5 + 2, 0, offset + angle_incr * idx * 2)
  puts "move LED#{led} (#{12.5 + xy.first} #{12.5 + xy.last});"
  puts "rotate =R#{-180 + offset + angle_incr * idx * 2} LED#{led};"

  xy = rotate(-12.5 + 2, 0, offset + angle_incr * (idx * 2 + 1))
  puts "move R#{led} (#{12.5 + xy.first} #{12.5 + xy.last});"
  puts "rotate =R#{-90 + offset + angle_incr * (idx * 2 + 1)} 'R#{led}';"
end

# offset = -(-90 + 30)
(5..8).each_with_index do |led, idx|
  xy = rotate(12.5 - 2, 0, offset + angle_incr * idx * 2)
  puts "move LED#{led} (#{12.5 + xy.first} #{12.5 + xy.last});"
  puts "rotate =R#{0 + offset + angle_incr * idx * 2} LED#{led};"

  xy = rotate(12.5 - 2, 0, offset + angle_incr * (idx * 2 + 1))
  puts "move R#{led} (#{12.5 + xy.first} #{12.5 + xy.last});"
  puts "rotate =R#{90 + offset + angle_incr * (idx * 2 + 1)} 'R#{led}';"
end
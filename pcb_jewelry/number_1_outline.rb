puts "change layer dimension;"

print "wire 'outline' 0.1 "
(1..(177/3)).each do |step|
  print "(P 12.5 #{step*3})"
end
puts ";"

print "wire 'outline' 0.1 "
(1..(177/3)).each do |step|
  print "(P 12.5 -#{step*3})"
end
puts ";"

puts "wire 0.1 (P 12.5 3) (R 12 0.5) (R 12 -0.5) (P 12.5 -3);"
puts "wire 0.1 (P 12.5 177) (R -12 0.5) (R -12 -0.5) (P 12.5 183);"
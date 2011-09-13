def rand_sign
  case rand(2)
  when 1
    1
  when 0
    -1
  end
end

canvas_w, canvas_h = ARGV.shift.to_i, ARGV.shift.to_i
num_rects = ARGV.shift.to_i

puts "<svg>"

rects = []

for i in (0..num_rects)
  # if rects.empty?
    # just make any rect to start with
    x = rand(canvas_w)
    y = rand(canvas_h)
    w = rand(canvas_w-x)
    h = rand(canvas_h-y)
    rects << {:x => x, :y => y, :w => w, :h => h}
  # else
  #   # pick a rect at random to intersect
  #   ref_rect = rects[rand(rects.size)]
  # 
  #   # pick the direction in which we'll be intersecting
  #   intersect_direction = rand(3) + 1
  # 
  #   if intersect_direction & 1 == 1 
  #     # x
  #     x = ref_rect[:x] + rand(w) / 2 * rand_sign
  #   else
  #     x = rand(w)
  #   end
  # 
  #   if intersect_direction & 2 == 2
  #     # y
  #     y = ref_rect[:y] + rand(h) / 2 * rand_sign
  #   else
  #     y = rand(h)
  #   end
  # 
  #   # x = rand(canvas_w)
  #   # y = rand(canvas_h)
  #   w = rand(canvas_w-x)
  #   h = rand(canvas_h-y)
  #   
  #   rects << {:x => x, :y => y, :w => w, :h => h}
  # end
  puts "<rect x='#{x}mm' y='#{y}mm' width='#{w}mm' height='#{h}mm' stroke-width='.1mm' stroke='black' fill='none'/>"
  puts "<rect x='#{x+2.5}mm' y='#{y+2.5}mm' width='#{w-5}mm' height='#{h-5}mm' stroke-width='.1mm' stroke='black' fill='none'/>"
end

puts "</svg>"
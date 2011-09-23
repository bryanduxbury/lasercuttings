def rand_sign
  case rand(2)
  when 1
    1
  when 0
    -1
  end
end

def rand_range(min, max)
  rng = max - min
  min + rand(rng)
end

def bi_between?(t1, h1, t2, h2)
  between?(t1, t2, h2) || between?(t2, t1, h1)
end

def between?(x, top, height)
  x >= top && x <= top + height
end

canvas_w, canvas_h = ARGV.shift.to_i, ARGV.shift.to_i
num_rects = ARGV.shift.to_i

puts "<svg>"

rects = []

until rects.size == num_rects
  # if rects.empty?
    # just make any rect to start with
    x = rand_range(0, (canvas_w - 10) / 10) * 10
    y = rand_range(0, (canvas_h - 10) / 10) * 10
    w = rand_range(3, (canvas_w - x - 10) / 10) * 10
    h = rand_range(3, (canvas_h - y - 10) / 10) * 10
    
    next if rects.select{|other_rect| bi_between?(y, h, other_rect[:y], other_rect[:h]) && other_rect[:x] == x}.any?
    next if rects.select{|other_rect| bi_between?(y, h, other_rect[:y], other_rect[:h]) && other_rect[:x] + other_rect[:w] == x + w}.any?

    next if rects.select{|other_rect| bi_between?(x, w, other_rect[:x], other_rect[:w]) && other_rect[:y] == y}.any?
    next if rects.select{|other_rect| bi_between?(x, w, other_rect[:x], other_rect[:w]) && other_rect[:y] + other_rect[:h] == y + h}.any?
    
    
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
  puts "<rect x='#{x+5}mm' y='#{y+5}mm' width='#{w-10}mm' height='#{h-10}mm' stroke-width='.1mm' stroke='black' fill='none'/>"
end

puts "</svg>"
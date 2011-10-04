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

puts "<svg width='#{canvas_w}mm' height='#{canvas_h}mm' viewBox='0 0 #{canvas_w} #{canvas_h}'>"

rects = []

until rects.size == num_rects
  # if rects.empty?
    # just make any rect to start with
    x = rand_range(0, (canvas_w - 20) / 10) * 10
    y = rand_range(0, (canvas_h - 20) / 10) * 10
    w = rand_range(3, (canvas_w - x - 20) / 5) * 5
    h = rand_range(3, (canvas_h - y - 20) / 5) * 5
    
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

  puts "<path style='fill:none; stroke:black; stroke-width:.1' d='M#{x - 0.1} #{y - 0.1} h#{w + 0.2} v#{h+0.2} h-#{w + 0.2} v-#{h+0.2} M#{x+5.1} #{y+5.1} v#{h-10.2} h#{w-10.2} v-#{h-10.2} h-#{w-10.2} Z' />"
  
  # puts "<rect x='#{x - 0.1}' y='#{y - 0.1}' width='#{w + 0.2}' height='#{h + 0.2}' stroke-width='.1' stroke='black' fill='none'/>"
  # puts "<rect x='#{x+5.1}' y='#{y+5.1}' width='#{w-10.2}' height='#{h-10.2}' stroke-width='.1' stroke='black' fill='none'/>"
end

puts "</svg>"
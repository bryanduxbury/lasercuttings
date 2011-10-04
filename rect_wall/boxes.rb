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
  x = rand_range(0, (canvas_w - 20) / 10) * 10
  y = rand_range(0, (canvas_h - 20) / 10) * 10
  w = rand_range(3, (canvas_w - x - 20) / 5) * 5
  h = rand_range(3, (canvas_h - y - 20) / 5) * 5
  
  next if rects.select{|other_rect| bi_between?(y, h, other_rect[:y], other_rect[:h]) && other_rect[:x] == x}.any?
  next if rects.select{|other_rect| bi_between?(y, h, other_rect[:y], other_rect[:h]) && other_rect[:x] + other_rect[:w] == x + w}.any?

  next if rects.select{|other_rect| bi_between?(x, w, other_rect[:x], other_rect[:w]) && other_rect[:y] == y}.any?
  next if rects.select{|other_rect| bi_between?(x, w, other_rect[:x], other_rect[:w]) && other_rect[:y] + other_rect[:h] == y + h}.any?

  rects << {:x => x, :y => y, :w => w, :h => h}
  puts "<path style='fill:none; stroke:black; stroke-width:.1' d='M#{x - 0.1} #{y - 0.1} h#{w + 0.2} v#{h+0.2} h-#{w + 0.2} v-#{h+0.2} M#{x+5.1} #{y+5.1} v#{h-10.2} h#{w-10.2} v-#{h-10.2} h-#{w-10.2} Z' />"
end

puts "</svg>"
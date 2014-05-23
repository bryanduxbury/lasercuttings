def round_up_to_quarter(x)
  whole = x.to_i
  fract = x - whole
  if fract > 0.75 
    fract = 1
  elsif fract > 0.5
    fract = 0.75
  elsif fract > 0.25
    fract = 0.5
  elsif fract > 0
    fract = 0.25
  end
  return whole.to_f + fract
end

def method_name
  
end


computed_lenghts = %w[68.7933 68.7933 32.6555 32.6555 17.7244 17.7244 74.937 77.2756 22.9567 22.9567 74.937 77.2756 77.2756 4.07087 4.07087 32.1909 32.1909]

computed_lenghts = computed_lenghts.map(&:to_f).map {|x| round_up_to_quarter(x)}

puts "Rounded lengths: "
puts computed_lenghts

total_len = computed_lenghts.inject(0) {|x, acc| x + acc}

puts "total length: #{total_len}"
puts "ideal 120\" segments: #{(total_len / 120.0).ceil}"

sorted_lengths = computed_lenghts.sort.reverse

max_size = 114
groupings = []

until sorted_lengths.empty?
  curr = sorted_lengths.shift
  
  selected = nil
  for g in groupings
    if g.inject(0) {|x, acc| x + acc} + curr <= max_size
      selected = g;
      break
    end
  end
  
  unless selected
    selected = []
    groupings << selected
  end
  
  selected << curr
  
end

puts "First fit groupings:"
puts groupings.inspect
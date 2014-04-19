require './names'

hash = {}
lengths = []

# Parse the array of names and create hash of type {char1: {following_char1: occurances, following_char2: occurances, ...}, char2: ... }
NAMES.each do |name|
  name.downcase!
  lengths << name.length
  name.each_char.inject do |last, curr|
    if hash.has_key? last
      if hash[last].has_key? curr
        hash[last][curr] += 1
      else
        hash[last][curr] = 1
      end
    else
      hash[last] = {curr => 1}
    end
    curr
  end
end

# craete hash with char keys and values that are arrays of oN times fcN (oN and fcN are respetively occurances of fcN and following character N)
# example: {ch1: [fc1, fc1, fc2, fc3, fc3, fc3], ch2: [fc1,fc2, fc2, fc3]}
# taking random element from the value arrays will be more likely to return a following char with more occurances
chance_hash = {}
hash.each_pair do |k, v|
  chance_hash[k] = v.flat_map { |v, c| Array.new(c).map {v} }
end

# we create words that are in the range min_length..max_length
max_len = lengths.max
min_len = lengths.min
len = rand(max_len - min_len) + min_len

# actual word generation
word = ''
last = hash.keys.sample
word << last
(len - 1).times do
  curr = chance_hash[last].sample
  word << curr
  last = curr
end

puts word

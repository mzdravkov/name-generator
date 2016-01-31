require './names'

CONSONANTS = "bcdefghjklmnpqrstvwxz"

def split_syllables word
  syllables = []
  return [word] if word.length <= 3
  until word.empty?
    match = word.match /ough|oor|air|our|ear|ere|aw|oo|es|ed|ea|oy|a\'s|es|ee|ar|er|ay|ir|o|y|i|e|a|u|û|ô|á|ë|ó|î|â/
    if match.nil?
      syllables[-1] = syllables[-1] + word
      return syllables
    end
    word = match.post_match

    correction = ""
    if inner_match = match.post_match.match(/^[#{CONSONANTS}]{2}/)
      correction = inner_match[0][0]
      word = word[1, word.length]
    end

    syllables.push match.pre_match + match[0] + correction
  end

  syllables
end

def new_name data_set
  syllables = {}
  min_length = Float::INFINITY
  max_length = 0



  data_set.each do |name|
    name.downcase!

    sylls = split_syllables name

    min_length = sylls.length if min_length > sylls.length
    max_length = sylls.length if max_length < sylls.length

    sylls.each.inject do |last, curr|
      if syllables.has_key? last
        if syllables[last].has_key? curr
          syllables[last][curr] += 1
        else
          syllables[last][curr] = 1
        end
      else
        syllables[last] = {curr => 1}
      end
      curr
    end
  end

  # create something like histogram with key syllable and list of following syllables (with
  # number of duplicate ones respective to the chance of occurrence after the key syllable)
  # example: {syllable1: [fs1, fs1, fs2, fs3, fs3, fs3], syllable2: [fs1,fs2, fs2, fs3]}
  #    where fs is following syllable
  # taking random element from the value arrays will be more likely to return
  # a following syllable with more occurances
  chance_hash = {}
  syllables.each_pair do |k, v|
    chance_hash[k] = v.flat_map { |e, c| Array.new(c).map {e} }
  end

  len = rand(max_length - min_length) + min_length
  name = ''
  last = syllables.keys.sample
  name << last
  (len - 1).times do
    if chance_hash[last].nil?
      if name.length < 4
        last = syllables.keys.sample
      else
        break
      end
    end
    curr = chance_hash[last].sample
    name << curr
    last = curr
  end

  name
end

puts new_name(NAMES)

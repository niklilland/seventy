# frozen_string_literal: true
# rubocop:disable all
require 'json'


rahlf_path = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-root-document.txt'
unbound_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-transformed/unbound-comparison.txt'

@rahlf = File.open(rahlf_path, 'r')
@unbound = File.open(unbound_path, 'r')

rahlf_start = 429831 - 1
rahlf_end = 3333 # line of first word of next chapter
rahlf_duration = rahlf_end - (rahlf_start - 1)

unbound_start = 19938 # starting line for chapter
unbound_end = 19977 # ending line for chapter
unbound_duration = unbound_end - (unbound_start - 1)


@rahlf_words = []
@unbound_words = []

rahlf_start.times { |n| @rahlf.gets }
rahlf_duration.times do |_|
  @rahlf_words.push(@rahlf.gets.match(/>.+</).to_s[1..-2])
end

unbound_start.times { |n| @unbound.gets }
unbound_duration.times do |_|
  ref = @unbound.gets.split("\t")
  unbound_text = ref[8]
  unbound_text.split(' ').each do |unbound_word|
    @unbound_words.push(unbound_word)
  end
end


@rahlf_words.each_with_index do |rahlf_word, index|
  # unbound = JudgB
  # rahlf = JudgA
  puts "#{index}: #{rahlf_word} == #{@unbound_words[index]} => #{rahlf_word.length == @unbound_words[index].length ? ' ' : 'DIFFERENT LENGTH'}"
end


# @rahlf_15 = []
# @unbound_15 = []

# 132746.times { |n| @rahlf.gets }
# 940.times do |_|
#   @rahlf_15.push(@rahlf.gets.match(/>.+</).to_s[1..-2])
# end

# 6170.times { |n| @unbound.gets }
# 64.times do |_|
#   ref = @unbound.gets.split("\t")
#   unbound_text = ref[8]

#   unbound_text.split(' ').each do |unbound_word|
#     @unbound_15.push(unbound_word)
#   end
# end


# @rahlf_15.each_with_index do |rahlf_word, index|
#   if index > 590
#     puts "#{index}: #{rahlf_word} == #{@unbound_15[index]} => #{rahlf_word.length == @unbound_15[index].length ? ' ' : 'DIFFERENT LENGTH'}"
#   end
# end


@rahlf.close()
@unbound.close()

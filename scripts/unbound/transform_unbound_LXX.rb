# frozen_string_literal: true
# rubocop:disable all
require 'json'

# This script transforms the Unbound LXX sources into a more workable format.
# This is done by re-ordering some verses that are out of order and removing
# the gramatical codes.

actual_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-source/_actual-source.txt'
lemma_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-source/_lemma-source-parsed.txt'
book_code_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-source/_book-map.txt'

trans_actual_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-transformed/transformed-actual-source.txt'
trans_lemma_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-transformed/transformed-lemma-source.txt'

@actual_file = File.open(actual_path, 'r')
@trans_actual = File.new(trans_actual_path, 'w+')
@book_file = File.open(book_code_path, 'r')

# Create a hash of the book codes with their names
@book_map = {}
@book_file.each do |line|
  parse = line.split("\t")
  @book_map[parse[0]] = parse[1].chomp
end

# skip intro lines
9.times { @trans_actual.write(@actual_file.gets) }

# Local variables
@verse_tracker = {}
@sept_index = 0
@prev_book = nil
@prev_chapter = nil
@prev_verse = nil
@prev_subverse = nil
file_length = 30044

def insert_verses(book, chapter, next_verse, subverse, prev_verse)
  # If the previous verse is greater than the next verse (e.g. 25, then 5), fill in starting from 1
  # else fill in starting at prev_verse
  in_verse = prev_verse > next_verse ? 1 : prev_verse + 1
  puts "INSERT #{@book_map[book]} #{chapter}:#{in_verse}"
  @trans_actual.write("#{book}\t#{chapter}\t#{in_verse}\t#{book}\t#{chapter}\t\t\t0\t\n")
  @verse_tracker[book][chapter].push("#{in_verse}")
  insert_verses(book, chapter, next_verse, subverse, in_verse) if in_verse + 1 < next_verse
end

# Writes verse to output file, records verse as tracked in the @verse_tracker variable
def process_verse(book, chapter, verse, subverse, input)
  @trans_actual.write(input)
  @verse_tracker[book][chapter].push("#{verse}#{subverse}")
end


while @actual_file.lineno <= file_length
  input = @actual_file.gets

  # Parse the reference values from line
  references = input.split("\t")
  book = references[0]
  chapter = references[1]
  verse = references[2]
  sept_book = references[3]
  sept_chapter = references[4]
  sept_verse = references[5]
  sept_subverse = references[6]
  sept_index = references[7]
  sept_text = references[8]

  # Skip the verses that are duplicated
  if sept_index == @sept_index
    next
  end
  @sept_index = sept_index

  # If the sept_book changes, add the sept_book to the tracker with the current sept_chapter set with an empty array
  if @verse_tracker[sept_book].nil?
    @verse_tracker[sept_book] = { sept_chapter => [] }
  # If the chapter changes, add the chapter to the tracker with an empty array
  elsif @verse_tracker[sept_book][sept_chapter].nil?
    @verse_tracker[sept_book][sept_chapter] = []
  end


  # If verse has book/chapter/verse/book/chapter/no verse, it's a filler verse, skip it
  if input.match(/\d+[ONA]{1}\t\d+\t\d+\t\d+[ONA]{1}\t\d+\t\t\t/)
    next
  else
    # If missing verses at start of chapter, insert verses
    if @verse_tracker[sept_book][sept_chapter].empty? && sept_verse.to_i != 1
      # First n verses are missing in chapter, insert them
      insert_verses(sept_book, sept_chapter, sept_verse.to_i, sept_subverse, @prev_verse)
      process_verse(sept_book, sept_chapter, sept_verse, sept_subverse, input)
    # If the verse is the same as the previous, and the subverse value of current or last isn't empty, it's a subverse!
    elsif (@verse_tracker[sept_book][sept_chapter][-1].to_i == sept_verse.to_i) && (sept_subverse != '' || @prev_subverse != '')
      process_verse(sept_book, sept_chapter, sept_verse, sept_subverse, input)
    # If the current verse is not the last verse processed + 1, we're missing n verses, grab them from @buffer
    elsif @verse_tracker[sept_book][sept_chapter][-1].to_i + 1 != sept_verse.to_i
      # Get n values from @buffer, then process current verse
      insert_verses(sept_book, sept_chapter, sept_verse.to_i, sept_subverse, @prev_verse)
      process_verse(sept_book, sept_chapter, sept_verse, sept_subverse, input)
    else
      process_verse(sept_book, sept_chapter, sept_verse, sept_subverse, input)
    end
  end

  puts "#{@book_map[sept_book]} #{sept_chapter}:#{sept_verse}#{sept_subverse}"

  @prev_book = sept_book
  @prev_chapter = sept_chapter.to_i
  @prev_verse = sept_verse.to_i
  @prev_subverse = sept_subverse
end

@actual_file.close()
@trans_actual.close()
@book_file.close()

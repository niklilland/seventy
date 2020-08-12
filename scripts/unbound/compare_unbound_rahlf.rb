# frozen_string_literal: true
# rubocop:disable all
require 'json'

# This script transforms the Unbound LXX sources into a more workable format.
# This is done by re-ordering some verses that are out of order and removing
# the gramatical codes.

# This script compares the transformed unbound LXX with the eliranwong repo data to see if they can be used together

comparison_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-transformed/unbound-comparison.txt'
rahlf_path = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-root-document.txt'
book_code_path = '/Users/niklaslilland/dev/king-json-bible/LXX/unbound-source/_book-map.txt'
@unbound = File.open(comparison_path, 'r')
@rahlf = File.open(rahlf_path, 'r')
@book_file = File.open(book_code_path, 'r')

# Create a hash of the book codes with their names
@book_map = {}
@book_file.each do |line|
  parse = line.split("\t")
  @book_map[parse[0]] = parse[1].chomp
end

break_loop = false
@mismatched = {}

def skip_lines(lines)
  lines.times { |n| @rahlf.gets }
end

@unbound.each do |line|
  ref = line.split("\t")
  unbound_book = ref[3]
  unbound_chapter = ref[4]
  unbound_verse = ref[5]
  unbound_subverse = ref[6]
  unbound_text = ref[8]

  puts "#{@book_map[unbound_book]} #{unbound_chapter}:#{unbound_verse}#{unbound_subverse}"

  # If the unbound_book changes, add the unbound_book to the tracker with the current unbound_chapter set with an empty array
  if @mismatched[@book_map[unbound_book]].nil?
    @mismatched[@book_map[unbound_book]] = { unbound_chapter => 0 }
  # If the chapter changes, add the chapter to the tracker with an empty array
  elsif @mismatched[@book_map[unbound_book]][unbound_chapter].nil?
    @mismatched[@book_map[unbound_book]][unbound_chapter] = 0
  end

  # Skip works not found in Unbound bible
  skip_lines(1064) if @rahlf.lineno == (139410 - 1) # to 140474, skip JoshA
  skip_lines(15947) if @rahlf.lineno == (156054 - 1) # to 156054, skip JudgA
  skip_lines(7233) if @rahlf.lineno == (332160 - 1) # to 339393, skip Tobit (Sinaiticus)
  skip_lines(871) if @rahlf.lineno == (599663 - 1) # to 600534, skip Bel and the Dragon (Theodotian)
  skip_lines(10453) if @rahlf.lineno == (611315 - 1) # to 621768, skip Daniel (Theodotian)
  skip_lines(1121) if @rahlf.lineno == (622560 - 1) # to 623681, skip Susanna (Theodotian)

  # TODO: I left off here:
  # The unbound Bible gives us mappings from the LXX to the modern KJV. The Rahlf text gives us everything else.
  # Using the two, the goal is to generate json files for each chapter of the LXX that have the strongs, glossary definition,
  # and lemmas for each greek word.
  # I converted the unbound LXX text to a more workable format (unbound-transformed folder) that inserted blank verses for the missing
  # verses. Using that, I copied and pasted the books into the order found in the Rahlf text (unbound-comparison.txt). That is the
  # file used in the compare_unbound_rahlf.rb script. foo.rb is another script that I used to examine differences found in the
  # compare script, it specifies a subsection of each file and spits out the differences. 
  # I specifically left off working through Proverbs, as the LXX cuts it up and moves it around in odd ways. How I'm going to store
  # it in json files/folders, I have no idea. But basically I need to go through the unbound-comparison.txt and move sections of
  # proverbs around to match what's found in the rahlf file.
  # https://en.katabiblon.com/us/index.php?text=LXX&book=Prv&ch=29 has been very helpful in this regard. Note: The rahlf text doesn't
  # switch back to Proverbs 25 after jumping to 30, it just rolls on into the high 30s. 

  unbound_text.split(' ').each do |unbound_word|
    rahlf_word = @rahlf.gets.match(/>.+</).to_s[1..-2]

    if unbound_word.length != rahlf_word.length
      if (unbound_word.index('|') || unbound_word.index('\\')) && (unbound_word.length - rahlf_word.length == 1)
        # It's an encoding issue, ignore it.
      elsif unbound_book == '06O' && unbound_chapter == '15'
        # Joshua 15 has words split into two
        @rahlf.gets
      elsif unbound_book == '19O' && unbound_chapter == '118'
        # Psalm 118 has words split into two
        @rahlf.gets
      elsif unbound_book == '20O' && unbound_chapter == '1'
        # Proverbs
        puts @rahlf.lineno
        puts @unbound.lineno
        puts ' '
        @mismatched[@book_map[unbound_book]][unbound_chapter] += 1
      else
        @mismatched[@book_map[unbound_book]][unbound_chapter] += 1
      end
    end
  end

  break if break_loop
end

@final_mismatched = {}

@mismatched.each do |book_name, book_value|
  if @final_mismatched[book_name].nil?
    @final_mismatched[book_name] = { }
  end

  book_value.each do |chapter, differences|
    if differences > 0
      @final_mismatched[book_name][chapter] = differences
    end
  end
end

puts @final_mismatched


@unbound.close()
@rahlf.close()
@book_file.close()

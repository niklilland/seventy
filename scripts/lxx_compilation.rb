# frozen_string_literal: true

# rubocop:disable all

require 'json'

# Sources for the LXX that need to be compiled into one source:
# lemma
# glossary
# strongs
# verse reference
# root document

verse_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-word-to-verse.txt'.freeze
lemma_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-word-to-lemma.txt'.freeze
glossary_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-word-to-glossary.txt'.freeze
strongs_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-word-to-strongs.txt'.freeze
actual_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-root-document.txt'.freeze
formatted_directory = '/Users/niklaslilland/dev/king-json-bible/LXX/formatted'.freeze
@ref = { 'Gen' => 'Genesis', 'Exod' => 'Exodus', 'Lev' => 'Leviticus', 'Num' => 'Numbers', 'Deut' => 'Deuteronomy', 'JoshB' => 'Joshua_Codex_Vaticanus', 'JoshA' => 'Joshua_Codex_Alexandrinus', 'JudgB' => 'Judges_Codex_Vaticanus', 'JudgA' => 'Judges_Codex_Alexandrinus', 'Ruth' => 'Ruth', '1Sam' => '1Samuel', '2Sam' => '2Samuel', '1Kgs' => '1Kings', '2Kgs' => '2Kings', '1Chr' => '1Chronicles', '2Chr' => '2Chronicles', '1Esdr' => nil, '2Esdr' => ['Ezra', 'Nehemiah'], 'Esth' => 'Esther', 'Jdt' => nil, 'TobBA' => nil, 'TobS' => nil, '1Macc' => nil, '2Macc' => nil, '3Macc' => nil, '4Macc' => nil, 'Ps' => 'Psalms', 'Odes' => nil, 'Prov' => 'Proverbs', 'Eccl' => 'Ecclesiastes', 'Song' => 'SongOfSongs', 'Job' => 'Job', 'Wis' => nil, 'Sir' => nil, 'PsSol' => nil, 'Hos' => 'Hosea', 'Mic' => 'Micah', 'Amos' => 'Amos', 'Joel' => 'Joel', 'Jonah' => 'Jonah', 'Obad' => 'Obadiah', 'Nah' => 'Nahum', 'Hab' => 'Habakkuk', 'Zeph' => 'Zephaniah', 'Hag' => 'Haggai', 'Zech' => 'Zechariah', 'Mal' => 'Malachi', 'Isa' => 'Isaiah', 'Jer' => 'Jeremiah', 'Bar' => nil, 'EpJer' => nil, 'Lam' => 'Lamentations', 'Ezek' => 'Ezekiel', 'BelOG' => nil, 'BelTh' => nil, 'DanOG' => 'Daniel_Old_Greek', 'DanTh' => 'Daniel_Theodotion', 'SusOG' => nil, 'SusTh' => nil }
special_handling = ['JoshA', 'JoshB', 'JudgA', 'JudgB', '2Esdr', 'Ps', 'Prov', 'DanOG', 'DanTh']

dest_io = {}

# # Create a file for each of the books
# @ref.each do |key, value|
#   dest_io[key] = File.new("/Users/niklaslilland/dev/king-json-bible/LXX/formatted/#{value}.json", 'w+') unless value.nil?
# end
# dest_io['Ezra'] = File.new('/Users/niklaslilland/dev/king-json-bible/LXX/formatted/Ezra.json', 'w+')
# dest_io['Nehemiah'] = File.new('/Users/niklaslilland/dev/king-json-bible/LXX/formatted/Nehemiah.json', 'w+')
# dest_io['Esther_With_Additions'] = File.new('/Users/niklaslilland/dev/king-json-bible/LXX/formatted/Esther_With_Additions.json', 'w+')


# Open reference files
@lemma_file = File.open(lemma_filepath, 'r')
@glossary_file = File.open(glossary_filepath, 'r')
@strongs_file = File.open(strongs_filepath, 'r')
@actual_file = File.open(actual_filepath, 'r')
@lemma_file.lineno = 1
@glossary_file.lineno = 1
@strongs_file.lineno = 1
@actual_file.lineno = 1

# Initialize variables for use in script
@processed = { :verses => [], :additional => [] }
@current_book = 'Gen' # init with first book value
@current_chapter = 1
@current_verse = 1
apocryphal_skip = 0
special_skip = 0
test = 0

# Open verse file to iterate over
verse_file = File.open(verse_filepath, 'r')
current_line = verse_file.gets

# TODO: update!
# TODO: Add verse counter to the overall script, so that it inserts blank verses when necessary! Note the insert_before cases are special for this new functionality
def process_verse(book, chapter, verse, words, kjv_chapter, kjv_verse, insert_before = false)

  # Parse additional_verse variable if present
  letter_verse = verse.match(/[a-z]+/) ? verse.match(/[a-z]+/).to_s : nil

  letter_verse = nil

  if verse.match(/[a-z]+/)
    letter_verse = verse.match(/[a-z]+/).to_s

    # If letter_verse is present, kjv_chapter and kjv_verse are nil because it's not in the KJV bible
    kjv_chapter = nil
    kjv_verse = nil
  end

  actual_text = []
  verse_container = {
    :book => book,
    :chapter => chapter.to_i,
    :verse => verse.to_i,
    :kjv_chapter => kjv_chapter.nil? ? chapter : kjv_chapter.to_i,
    :kjv_verse => kjv_verse.nil? ? chapter.to_i : kjv_verse.to_i,
    :text => '',
    :reference => []
  }
  verse_container[:verse_letter] = letter_verse unless letter_verse.nil?

  # Iterate over each word in the verse
  words.times do |i|
    greek_text = @actual_file.gets.match(/>.+</).to_s[1..-2]
    glossary_text = @glossary_file.gets.gsub(/\d+ /, '').split(';<br>').join(', ').gsub("\n", '')
    lemma_text = @lemma_file.gets.gsub(/\d+ /, '').gsub("\n", '')
    strongs_text = @strongs_file.gets.gsub(/\d+ /, '').gsub("\n", '')
    
    actual_text.push(greek_text)
    verse_container[:reference].push({
      'index': verse_container[:reference].length,
      'gr': greek_text,
      'en': glossary_text,
      'lemma': lemma_text,
      'strongs': strongs_text
    })
  end
  verse_container[:text] = actual_text.join(' ')

  if insert_before
    @processed[:verses].insert(-2, verse_container)
  else
    @processed[:verses].push(verse_container)
  end

  log_value(write, verse_container, copy)
end

# TODO: Remove if block later, done for debugging
def log_value(write, verse_container, copy)
  if @actual_file.lineno > 604294
    case write
    when 0
      puts verse_container
    when 1
      puts copy
    when 2
      puts verse_container
      puts ' '
      puts copy
    end
    puts ' '
  end
end

def transition_book(book)
  # New book, write @processed to file then clear it
  # TODO: Undo this
  # TODO: Special handling for Ezra and Nehemiah
  # TODO: Special handling for Esther and Esther_With_Additions
  # dest_io[@current_book].write(@processed.to_json)
  # TODO: Close the io?
  puts "Wrote #{@ref[@current_book]} to file!\n"
  # TODO: Change these to match the KVJ values
  @processed = { :verses => [], :additional => [], :id => @ref[book], :title => @ref[book] }
  @current_book = book
end


while verse_file.lineno <= 30637
  test += 1


  next_line = verse_file.gets
  split = current_line.split('.')
  # Parse book shorthand from line
  book = split[0]
  chapter = split[1]
  verse = split[2].split('-')[0]
  line = split[2].split('-')[1].to_i

  # If we've reached the end of the file
  if next_line.nil?
    puts 'END OF THE VERSE FILE'
    # hard-code length of the last file
    words_in_verse = 13
  else
    # calculate how many lines the reference files need to move forward to match the next verse
    next_verse_start = next_line.split('-')[1].to_i
    if next_line == "DanOG.5.26-28-606213\n"
      next_verse_start = next_line.split('-')[2].to_i
    end
    words_in_verse = next_verse_start - line
  end

  # TODO: Come back to this at a later time and process the apocryphal books as well
  # Skip if the ref is nil, e.g. skip if it's an Apocryphal book, but still increase the line numbers
  if @ref[book].nil?
    apocryphal_skip += 1
  elsif special_handling.include?(book)

    if apocryphal_skip > 0
      skip = line - @actual_file.lineno
      puts "Skipping #{skip} lines in reference files (apocryphal)"
      # 'line' is the line number that the reference files need to be iterated to
      skip.times do |i|
        @actual_file.gets
        @glossary_file.gets
        @lemma_file.gets
        @strongs_file.gets
      end
      apocryphal_skip = 0
    end

    if special_skip > 0
      skip = line - @actual_file.lineno
      puts "Skipping #{skip} lines in reference files (special handling)"
      # 'line' is the line number that the reference files need to be iterated to
      skip.times do |i|
        @actual_file.gets
        @glossary_file.gets
        @lemma_file.gets
        @strongs_file.gets
      end
      special_skip = 0
    end

    # If book is the same
    # if chapter is the same
    # but verse is not current_verse + 1
    # insert verses until it is
    # 

    if book == @current_book
      if chapter.to_i == @current_chapter
        if verse.to_i == @current_verse
          # TODO: letter verse, don't insert anything
        elsif verse.to_i == @current_verse + 1
          # verse matches what it SHOULD be, don't insert anything
        else
          # verse is not the same, is not next value, so we need to insert n verses

          # How do we determine what n is?

          (verse.to_i - @current_verse).times do |i|
            process_verse(@ref[book], chapter, verse, 0, chapter, verse)
          end

        end


      end


    end



    # If the book changes, write the book object to file and wipe the @processed variable, then close the io!
    if book != @current_book
      # New book, write @processed to file then clear it
      transition_book(book)
    end

    case book
    when 'JoshA'
      process_verse('Joshua (Codex Alexandrinus)', chapter, verse, words_in_verse, chapter, verse)
    when 'JoshB'
      process_verse('Joshua (Codex Vaticanus)', chapter, verse, words_in_verse, chapter, verse)
    when 'JudgA'
      process_verse('Judges (Codex Alexandrinus)', chapter, verse, words_in_verse, chapter, verse)
    when 'JudgB'
      process_verse('Joshua (Codex Vaticanus)', chapter, verse, words_in_verse, chapter, verse)
    when '2Esdr'
      # 1:1-10:44 = ezra
      # 11:1-23:31 (1:1-13:31) = nehemiah
      if chapter.to_i < 11
        process_verse('Ezra', chapter, verse, words_in_verse, chapter, verse)
      else
        process_verse('Nehemiah', chapter.to_i - 10, verse, words_in_verse, chapter.to_i - 10, verse)
      end
    when 'Ps'
      # TODO: Map out verse reassignment
      special_skip += 1
    when 'Prov'
      # TODO: Look into what needs to change
      special_skip += 1
    when 'DanOG'
      if chapter.to_i == 3
        # if verse is 24-90, not kjv
        # before, it is
        # after, 91-97 correlates to 24-30
        if verse.to_i <= 23
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        elsif verse.to_i > 23 && verse.to_i < 91
          process_verse(@ref[book], chapter, verse, words_in_verse, nil, nil)
        else # verse.to_i > 90, shift to be verses 24-30
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse.to_i - 67)
        end

      elsif chapter.to_i == 4
        # Handle blank verses
        case verse.to_i
        when 4
          # TODO: n.times should be removed when other update is applied
          3.times { |i| process_verse(@ref[book], chapter, i + 1, 0, chapter, i + 1) }
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        when 10
          4.times { |i| process_verse(@ref[book], chapter, i + 6, 0, chapter, i + 1) }
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        when 11
          # Insert BEFORE previous verse
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse, true)
        when 36
          process_verse(@ref[book], chapter, 35, 0, chapter, verse)
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        else
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        end

      elsif chapter.to_i == 5
        if verse.to_i == 16
          # Insert 14 and 15, then process 16
          process_verse(@ref[book], chapter, 14, 0, chapter, 14)
          process_verse(@ref[book], chapter, 15, 0, chapter, 15)
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        elsif verse.to_i == 23
          # 18, 19, 20, 21, 22
          5.times { |i| process_verse(@ref[book], chapter, i + 18, 0, chapter, i + 18) }
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        elsif verse.to_i == 26
          # Insert 24, 25
          process_verse(@ref[book], chapter, 24, 0, chapter, 24)
          process_verse(@ref[book], chapter, 25, 0, chapter, 25)

          # Set the line number to the actual value, process the verse, then add two empty verses after it
          line = split[2].split('-')[2].to_i
          words_in_verse = next_verse_start - line
          # process as 26, then add 27 and 28 as blank verses
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
          process_verse(@ref[book], chapter, 27, 0, chapter, 27)
          process_verse(@ref[book], chapter, 28, 0, chapter, 28)
        else
          process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
        end
      else
        process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
      end

    when 'DanTh'
      # Daniel 3:1-3:23 are normal, omit 3:24-3:90. 3:91-3:97 should be 3:24-3:30
      if chapter.to_i == 3
        if verse.to_i < 24
          process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse)
        elsif verse.to_i > 23 && verse.to_i < 91
          process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, nil, nil)
        else # verse.to_i > 90, shift to be verses 24-30
          process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse.to_i - 67)
        end
      else
        process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse)
      end
    end
  else
    if apocryphal_skip > 0
      skip = line - @actual_file.lineno
      puts "Skipping #{skip} lines in reference files (apocryphal)"
      # 'line' is the line number that the reference files need to be iterated to
      skip.times do |i|
        @actual_file.gets
        @glossary_file.gets
        @lemma_file.gets
        @strongs_file.gets
      end
      apocryphal_skip = 0
    end

    if special_skip > 0
      skip = line - @actual_file.lineno
      puts "Skipping #{skip} lines in reference files (special handling)"
      # 'line' is the line number that the reference files need to be iterated to
      skip.times do |i|
        @actual_file.gets
        @glossary_file.gets
        @lemma_file.gets
        @strongs_file.gets
      end
      special_skip = 0
    end

    # If the book changes, write the book object to file and wipe the @processed variable, then close the io!
    if book != @current_book
      # New book, write @processed to file then clear it
      transition_book(book)
    end

    process_verse(book, chapter, verse, words_in_verse, chapter, verse)
  end
  # break if test > 5
  current_line = next_line
end


# # Goal format
# {
#   "book": "1 John"
#   "chapter": 1,
#   "verse": 1,
#   "kjv_chapter": 1,
#   "kjv_verse": 1,
#   "verse_letter": 'a', # For additional apocryphal verses
#   "text": "That which was from the beginning, which we have heard, which we have seen with our eyes, which we have looked upon, and our hands have handled, of the Word of life;",
#   "reference": [
#     {
#       "index": 0,
#       "strongs": "G2455",
#       "text": "Jude,"
#     },
#     {
#       "index": 1,
#       "strongs": 0,
#       "text": "the"
#     },
#     {
#       "index": 2,
#       "strongs": "G1401",
#       "text": "servant"
#     }
#   ]
# }
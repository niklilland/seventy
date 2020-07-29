# rubocop:disable all
# frozen_string_literal: true

require 'json'

# Transform the source 'verse' file to add blank values for the verses that are not in the KJV

ref = { '1Chr' => '1Chronicles', '1Kgs' => '1Kings', '1Sam' => '1Samuel', '2Chr' => '2Chronicles', '2Esdr' => nil, '2Kgs' => '2Kings', '2Sam' => '2Samuel', 'Amos' => 'Amos', 'DanOG' => 'Daniel', 'DanTh' => 'Daniel', 'Deut' => 'Deuteronomy', 'Eccl' => 'Ecclesiastes', 'Esth' => 'Esther', 'Exod' => 'Exodus', 'Ezek' => 'Ezekiel', 'Gen' => 'Genesis', 'Hab' => 'Habakkuk', 'Hag' => 'Haggai', 'Hos' => 'Hosea', 'Isa' => 'Isaiah', 'Jer' => 'Jeremiah', 'Job' => 'Job', 'Joel' => 'Joel', 'Jonah' => 'Jonah', 'JoshA' => 'Joshua', 'JoshB' => 'Joshua', 'JudgA' => 'Judges', 'JudgB' => 'Judges', 'Lam' => 'Lamentations', 'Lev' => 'Leviticus', 'Mal' => 'Malachi', 'Mic' => 'Micah', 'Nah' => 'Nahum', 'Num' => 'Numbers', 'Obad' => 'Obadiah', 'Prov' => 'Proverbs', 'Ps' => 'Psalms', 'Ruth' => 'Ruth', 'Song' => 'SongOfSongs', 'Zech' => 'Zechariah', 'Zeph' => 'Zephaniah' }.freeze
verse_filepath = '/Users/niklaslilland/dev/king-json-bible/LXX/LXX-word-to-verse.txt'.freeze

# Initialize variables for use in script
@iter_book = 'Gen' # init with first book value
@iter_chapter = 1
@iter_verse = 1

# Open verse file to iterate over
verse_file = File.open(verse_filepath, 'r')


statistics_file_path = '/Users/niklaslilland/dev/king-json-bible/ot_chapter_statistics.json'.freeze
ot_stats = JSON.parse(File.read(statistics_file_path))


# The goal here is to take the verse file and normalize it a bit. There are verses missing
# from the Septuagint that are in the KJV, and vice verses. Basically if the verse_file goes
# from v11 to v15, we want to inject v12-14 with a standard value for the line number.
# We also want to fix the weird situation of DanOG 1:1s.

# We do this by iterating over the verse_file and looking at the book/chapter/verse

# We need to loop through each structure, the stat file and the verse file.


# Special handling:
# DanOG 1:1s
# Lam 0:1 (convert to 1:0)

verse_file.each_line do |line|
  split = line.split('.')
  line_book = split[0]
  line_chapter = split[1]
  line_verse = split[2].split('-')[0].to_i

  # Gen 50:25
  # Gen 50:26
  # Exod 1:1
  # Exod 1:2

  if line_book == @iter_book
    # book is same
    # check if chapter has changed
    if line_chapter == @iter_chapter
      # chapter is same

      # TODO:
      # 1. Have we reached the end of the chapter (ot_stats)? If so, don't insert anything, else go to #2
      # 2. Does line_verse == @iter_verse + 1 ? If so, don't insert anything. Otherwise, insert n verses until it does.

      if ot_stats[line_book]

    else
      # chapter has changed
      if line_verse > 1
        # TODO: insert n verses until we match line_verse
      end
    end
  else
    # book has changed
    # TODO: Special case of chapter being zero!
    # TODO: Throw an error if chapter is NOT one
    # TODO: If verse > 1, insert n verses
  end


  @iter_book = line_book
  @iter_chapter = line_chapter
  @iter_verse = line_verse
end







# while verse_file.lineno <= 30637
#   test += 1


#   next_line = verse_file.gets
#   split = current_line.split('.')
#   # Parse book shorthand from line
#   book = split[0]
#   chapter = split[1]
#   verse = split[2].split('-')[0]
#   line = split[2].split('-')[1].to_i

#   # If we've reached the end of the file
#   if next_line.nil?
#     puts 'END OF THE VERSE FILE'
#     # hard-code length of the last file
#     words_in_verse = 13
#   else
#     # calculate how many lines the reference files need to move forward to match the next verse
#     next_verse_start = next_line.split('-')[1].to_i
#     if next_line == "DanOG.5.26-28-606213\n"
#       next_verse_start = next_line.split('-')[2].to_i
#     end
#     words_in_verse = next_verse_start - line
#   end

#   # TODO: Come back to this at a later time and process the apocryphal books as well
#   # Skip if the ref is nil, e.g. skip if it's an Apocryphal book, but still increase the line numbers
#   if @ref[book].nil?
#     apocryphal_skip += 1
#   elsif special_handling.include?(book)

#     if apocryphal_skip > 0
#       skip = line - @actual_file.lineno
#       puts "Skipping #{skip} lines in reference files (apocryphal)"
#       # 'line' is the line number that the reference files need to be iterated to
#       skip.times do |i|
#         @actual_file.gets
#         @glossary_file.gets
#         @lemma_file.gets
#         @strongs_file.gets
#       end
#       apocryphal_skip = 0
#     end

#     if special_skip > 0
#       skip = line - @actual_file.lineno
#       puts "Skipping #{skip} lines in reference files (special handling)"
#       # 'line' is the line number that the reference files need to be iterated to
#       skip.times do |i|
#         @actual_file.gets
#         @glossary_file.gets
#         @lemma_file.gets
#         @strongs_file.gets
#       end
#       special_skip = 0
#     end

#     # If book is the same
#     # if chapter is the same
#     # but verse is not current_verse + 1
#     # insert verses until it is
#     # 

#     if book == @current_book
#       if chapter.to_i == @current_chapter
#         if verse.to_i == @current_verse
#           # TODO: letter verse, don't insert anything
#         elsif verse.to_i == @current_verse + 1
#           # verse matches what it SHOULD be, don't insert anything
#         else
#           # verse is not the same, is not next value, so we need to insert n verses

#           # How do we determine what n is?

#           (verse.to_i - @current_verse).times do |i|
#             process_verse(@ref[book], chapter, verse, 0, chapter, verse)
#           end

#         end


#       end


#     end



#     # If the book changes, write the book object to file and wipe the @processed variable, then close the io!
#     if book != @current_book
#       # New book, write @processed to file then clear it
#       transition_book(book)
#     end

#     case book
#     when 'JoshA'
#       process_verse('Joshua (Codex Alexandrinus)', chapter, verse, words_in_verse, chapter, verse)
#     when 'JoshB'
#       process_verse('Joshua (Codex Vaticanus)', chapter, verse, words_in_verse, chapter, verse)
#     when 'JudgA'
#       process_verse('Judges (Codex Alexandrinus)', chapter, verse, words_in_verse, chapter, verse)
#     when 'JudgB'
#       process_verse('Joshua (Codex Vaticanus)', chapter, verse, words_in_verse, chapter, verse)
#     when '2Esdr'
#       # 1:1-10:44 = ezra
#       # 11:1-23:31 (1:1-13:31) = nehemiah
#       if chapter.to_i < 11
#         process_verse('Ezra', chapter, verse, words_in_verse, chapter, verse)
#       else
#         process_verse('Nehemiah', chapter.to_i - 10, verse, words_in_verse, chapter.to_i - 10, verse)
#       end
#     when 'Ps'
#       # TODO: Map out verse reassignment
#       special_skip += 1
#     when 'Prov'
#       # TODO: Look into what needs to change
#       special_skip += 1
#     when 'DanOG'
#       if chapter.to_i == 3
#         # if verse is 24-90, not kjv
#         # before, it is
#         # after, 91-97 correlates to 24-30
#         if verse.to_i <= 23
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         elsif verse.to_i > 23 && verse.to_i < 91
#           process_verse(@ref[book], chapter, verse, words_in_verse, nil, nil)
#         else # verse.to_i > 90, shift to be verses 24-30
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse.to_i - 67)
#         end

#       elsif chapter.to_i == 4
#         # Handle blank verses
#         case verse.to_i
#         when 4
#           # TODO: n.times should be removed when other update is applied
#           3.times { |i| process_verse(@ref[book], chapter, i + 1, 0, chapter, i + 1) }
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         when 10
#           4.times { |i| process_verse(@ref[book], chapter, i + 6, 0, chapter, i + 1) }
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         when 11
#           # Insert BEFORE previous verse
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse, true)
#         when 36
#           process_verse(@ref[book], chapter, 35, 0, chapter, verse)
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         else
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         end

#       elsif chapter.to_i == 5
#         if verse.to_i == 16
#           # Insert 14 and 15, then process 16
#           process_verse(@ref[book], chapter, 14, 0, chapter, 14)
#           process_verse(@ref[book], chapter, 15, 0, chapter, 15)
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         elsif verse.to_i == 23
#           # 18, 19, 20, 21, 22
#           5.times { |i| process_verse(@ref[book], chapter, i + 18, 0, chapter, i + 18) }
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         elsif verse.to_i == 26
#           # Insert 24, 25
#           process_verse(@ref[book], chapter, 24, 0, chapter, 24)
#           process_verse(@ref[book], chapter, 25, 0, chapter, 25)

#           # Set the line number to the actual value, process the verse, then add two empty verses after it
#           line = split[2].split('-')[2].to_i
#           words_in_verse = next_verse_start - line
#           # process as 26, then add 27 and 28 as blank verses
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#           process_verse(@ref[book], chapter, 27, 0, chapter, 27)
#           process_verse(@ref[book], chapter, 28, 0, chapter, 28)
#         else
#           process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#         end
#       else
#         process_verse(@ref[book], chapter, verse, words_in_verse, chapter, verse)
#       end

#     when 'DanTh'
#       # Daniel 3:1-3:23 are normal, omit 3:24-3:90. 3:91-3:97 should be 3:24-3:30
#       if chapter.to_i == 3
#         if verse.to_i < 24
#           process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse)
#         elsif verse.to_i > 23 && verse.to_i < 91
#           process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, nil, nil)
#         else # verse.to_i > 90, shift to be verses 24-30
#           process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse.to_i - 67)
#         end
#       else
#         process_verse('Daniel (Theodotion)', chapter, verse, words_in_verse, chapter, verse)
#       end
#     end
#   else
#     if apocryphal_skip > 0
#       skip = line - @actual_file.lineno
#       puts "Skipping #{skip} lines in reference files (apocryphal)"
#       # 'line' is the line number that the reference files need to be iterated to
#       skip.times do |i|
#         @actual_file.gets
#         @glossary_file.gets
#         @lemma_file.gets
#         @strongs_file.gets
#       end
#       apocryphal_skip = 0
#     end

#     if special_skip > 0
#       skip = line - @actual_file.lineno
#       puts "Skipping #{skip} lines in reference files (special handling)"
#       # 'line' is the line number that the reference files need to be iterated to
#       skip.times do |i|
#         @actual_file.gets
#         @glossary_file.gets
#         @lemma_file.gets
#         @strongs_file.gets
#       end
#       special_skip = 0
#     end

#     # If the book changes, write the book object to file and wipe the @processed variable, then close the io!
#     if book != @current_book
#       # New book, write @processed to file then clear it
#       transition_book(book)
#     end

#     process_verse(book, chapter, verse, words_in_verse, chapter, verse)
#   end
#   # break if test > 5
#   current_line = next_line
# end

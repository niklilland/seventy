# frozen_string_literal: true

# rubocop:disable all

require 'json'
require 'httparty'

old_testament = ['1Chronicles', '1Kings', '1Samuel', '2Chronicles', '2Kings', '2Samuel', 'Amos', 'Daniel', 'Deuteronomy', 'Ecclesiastes', 'Esther', 'Exodus', 'Ezekiel', 'Ezra', 'Genesis', 'Habakkuk', 'Haggai', 'Hosea', 'Isaiah', 'Jeremiah', 'Job', 'Joel', 'Jonah', 'Joshua', 'Judges', 'Lamentations', 'Leviticus', 'Malachi', 'Micah', 'Nahum', 'Nehemiah', 'Numbers', 'Obadiah', 'Proverbs', 'Psalms', 'Ruth', 'SongOfSongs', 'Zechariah', 'Zephaniah']
new_testament = ['1Corinthians', '1John', '1Peter', '1Thessalonians', '1Timothy', '2Corinthians', '2John', '2Peter', '2Thessalonians', '2Timothy', '3John', 'Acts', 'Colossians', 'Ephesians', 'Galatians', 'Hebrews', 'James', 'John', 'Jude', 'Luke', 'Mark', 'Matthew', 'Philemon', 'Philippians', 'Revelation', 'Romans', 'Titus']

url = 'https://jsonbible.com/search/strongs.php'


# Iterate over each book of the bible
Dir.glob('/Users/niklaslilland/dev/king-json-bible/*.json') do |file_name|
  original_file_name_book = file_name.split('/').last.split('.')[0]

  # # Only parse NT books
  # next if old_testament.include?(original_file_name_book)

  # # Only parse OT books
  # next if new_testament.include?(original_file_name_book)

  file_name_book = "#{original_file_name_book}"
  # Insert a space for the name if book name has a digit in it
  file_name_book = file_name_book.insert(1, ' ') if /\d/.match(file_name_book)
  # Special handling for song of songs
  file_name_book = 'Song of Songs' if file_name_book == 'SongOfSongs'

  # parse contents of book file
  parsed_hash = JSON.parse(File.read(file_name))

  # Group verses in book by chapter
  book_chapters = parsed_hash['verses'].group_by { |verse| verse['chapter'] }

  # Iterate over chapters
  book_chapters.each do |chapter|
    puts "#{file_name_book} #{chapter[1][0]['chapter']}"

    # Iterate over verses in the chapter
    chapter[1].each do |verse|
      # Write the book name to each verse
      verse['book'] = file_name_book
      verse['reference'] = []

      # 2. Load the verse with the strong's information from jsonbible.com!!!
      payload = { book: file_name_book, chapter: verse['chapter'].to_s, verse: verse['verse'].to_s }
      payload[:book] = 'Song of Solomon' if verse['book'] === 'Song of Songs'

      # response = HTTParty.get("#{url}?_='1588196380965'&json=#{payload.to_json.gsub('"', '%22')}")
      response = HTTParty.get("#{url}?_='1588196380965'&json=#{payload.to_json}")

      if response.code === 200
        parsed = response.parsed_response
        # Remove all extraneous backslashes
        sub_parsed = parsed.gsub("\\\\\\", '').gsub('\\', '')
        # Remove everything except the verse text
        text = sub_parsed.slice((sub_parsed.index('text":"') + 7)..(sub_parsed.index('","version') - 1))
        # Split verse on delimiter
        split = text.split('[data strongs=')

        # If first entry was a strong's word, remove the first empty array
        if split[0].length === 0
          split = split[1..-1]
        end

        # Iterate over split array
        split.each do |com|
          # If first word doesn't have a strongs number
          if com[0] != "\""
            verse['reference'].push({ index: verse['reference'].length, strongs: 0, text: com })
          else
            strongs = com.match(/\d+/).to_s
            english = com.to_s.match(/\].+?\[/).to_s[1..-2]
            prefix = 'G'
            prefix = 'H' if old_testament.include?(original_file_name_book)
            formatted_strongs = prefix + strongs.rjust(4, '0')
            verse['reference'].push({ index: verse['reference'].length, strongs: formatted_strongs, text: english })

            # Detect any trailing non-strong's words
            trailing = com.match(/\/data\].*/).to_s.strip
            if trailing[-1] != ']'
              verse['reference'].push({ index: verse['reference'].length, strongs: 0, text: trailing[7..-1] })
            end
          end
        end
      else
        # TODO: Exit the script and log an error
        puts "ERROR, FAILED REQUEST"
      end
    end
  end

  File.open("/Users/niklaslilland/dev/king-json-bible/formatted/OT/#{original_file_name_book}.json", 'w+') do |file|
    file.write(parsed_hash.to_json)
    puts "Wrote #{file_name_book} to file!"
  end
end



# # verse format
# {
#   "book": "1 John"
#   "chapter": 1,
#   "verse": 1,
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
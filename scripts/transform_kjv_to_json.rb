# frozen_string_literal: true
# rubocop:disable all

require 'json'

def open_and_transform(testament)
  # Open each file, and re-format it
  Dir.glob("/Users/niklaslilland/dev/king-json-bible/formatted/#{testament}/*.json") do |file_name|
    original_file_name_book = file_name.split('/').last.split('.')[0]
    grouped = JSON.parse(File.read(file_name))['verses'].group_by { |verse| verse['chapter'] }


    book_folder = "/Users/niklaslilland/dev/king-json-bible/KJV/json/#{original_file_name_book}"
    Dir.mkdir(book_folder) unless File.directory?(book_folder)

    grouped.each do |chapter, contents|
      File.open("/Users/niklaslilland/dev/king-json-bible/KJV/json/#{original_file_name_book}/#{chapter}.json", 'w+') do |file|
        file.write("#{contents.to_json}")
        puts "Wrote #{original_file_name_book} #{chapter} to file!"
      end
    end
  end
end

['OT', 'NT'].each { |tstmt| open_and_transform(tstmt) }
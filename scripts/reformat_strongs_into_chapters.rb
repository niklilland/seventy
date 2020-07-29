# frozen_string_literal: true
# rubocop:disable all

require 'json'

def open_and_transform(testament)
  # Open each file, and re-format it
  Dir.glob("/Users/niklaslilland/dev/king-json-bible/formatted/#{testament}/*.json") do |file_name|
    original_file_name_book = file_name.split('/').last.split('.')[0]
    grouped = JSON.parse(File.read(file_name))['verses'].group_by { |verse| verse['chapter'] }
    File.open("/Users/niklaslilland/dev/king-json-bible/KJV/#{testament}/#{original_file_name_book}.json", 'w+') do |file|
      file.write(grouped.to_json)
      puts "Wrote #{original_file_name_book} to file!"
    end
  end
end

['OT', 'NT'].each { |tstmt| open_and_transform(tstmt) }
#!/usr/bin/env ruby

require 'csv'

def usage
  "Usage: ruby #{File.basename __FILE__} INPUT_CSV"
end
in_csv = ARGV.shift

puts RUBY_VERSION

abort usage unless in_csv


last_call_number = nil
begin
  CSV.foreach in_csv do |row|
    last_call_number = row[0]
  end
rescue
  puts "====== #{last_call_number} ===="
  raise
end


puts "Success!"

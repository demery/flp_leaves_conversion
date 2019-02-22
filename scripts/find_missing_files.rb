#!/usr/bin/env ruby

require 'csv'
require 'set'

fs_list = 'flp_leaves_files.txt'

spreadsheet_csv = 'expected_files.csv'

files_on_disk = open(fs_list).readlines.map &:strip

used_files = Set.new

CSV do |csv|
  csv << ['Call no.', 'Full list', 'Found', 'Missing', 'Reused']

  CSV.foreach spreadsheet_csv, headers: true do |row|
    call_no   = row['call_number']
    files     = row['files'].split '|'
    not_found = files.reject {|f| files_on_disk.include? f}
    reused    = files.uniq.select { |f| files.count(f) > 1 }
    files.each { |f| used_files << f }
    # unless (not_found.empty? && reused.empty?)
    # binding.pry if files.include? 'mcai280131.tif'
    unless reused.empty? && not_found.empty?
      # binding.pry
      found = files - not_found
      csv << [call_no, files.join('; '), found.join('; '), not_found.join('; '), reused.join('; ')]
    end
  end
end

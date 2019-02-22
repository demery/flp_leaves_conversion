#!/usr/bin/env ruby

require 'csv'
require 'set'

fs_list = 'flp_leaves_files.txt'
FILES_ON_DISK = open(fs_list).readlines.map &:strip

used_files = Set.new

def add_file? f, file_array = []
  return unless FILES_ON_DISK.include? f
  return if file_array.include? f
  true
end

csv_in = ARGV.shift

CSV do |csv|
  csv << %w{ call_number folder files }
  CSV.foreach csv_in, headers: true, encoding: 'ISO8859-1:utf-8' do |row|
    
    call_no = (row['Call Number/ID'] || '').strip
    files = row['image files'].split '|'
    
    files_to_use = []
    files.each { |f| files_to_use << f if add_file? f, files_to_use }
    
    files.each do |f|
      $stderr.puts "WARN: already used: #{f}" if used_files.include? f
    end
    
    files.each { |f| used_files << f }

    folder = call_no.gsub /\W+/, '_'
    csv << [ call_no, folder, files_to_use.join('|')] # unless files.empty?
    
  end
end


#!/usr/bin/ruby

require 'rubygems'
require 'optparse'
require 'nokogiri'
require 'fastercsv'
require 'iconv'
require 'pp'

# Read command line options
options = {
  :data_dir => 'data',
  :output => 'out.csv',
  :xpath_file => 'Xpaths',
}
OptionParser.new do |opts|
  opts.banner = "Usage: parse.rb [options]"
  opts.on("-d", "--data DIR", "Directory containing HTML files") do |v|
    options[:data_dir] = v
  end
  opts.on("-o", "--output DIR", "Output CSV file name") do |v|
    options[:output] = v
  end
  opts.on("-x", "--xpaths FILE", "File containing XPaths to match") do |v|
    options[:xpath_file] = v
  end
end.parse!

# Run parser
class Parser
  @options = {}
  def initialize(opts)
    @options = opts

    # Get xpaths
    @xpaths = {}
    File.readlines(opts[:xpath_file]).each do |line|
      name, xpath = line.match(/^(\w+):\s+(.*)$/i).captures
      @xpaths[name] = xpath
    end
  end

  def parse
    pp @options
    pp @xpaths
    rows = []
    Dir.foreach(@options[:data_dir]) do |f|
      unless f.start_with? "."
        rows.push(process_file(f))
      end
    end

    FasterCSV.open(@options[:output], "w", {:col_sep => ";"}) do |csv|
      csv << @xpaths.keys
      rows.each { |row|
        csv << row
      }
    end
  end

  def process_file(f)
    pp "Processing: #{f}"

    path = File.join(@options[:data_dir], f)
    doc = Nokogiri::HTML(open(path))

    # Find encoding
    enc = doc.encoding

    # Extract tags
    out = []
    @xpaths.each { |k, v|
      m = []
      doc.xpath(v).each { |t|
        m.push Iconv.conv('US-ASCII//IGNORE', enc, t.to_s)
      }
      out.push m.join(', ')
    }

    return out
  end
end

Parser.new(options).parse

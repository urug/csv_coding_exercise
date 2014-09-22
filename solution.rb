require 'minitest/autorun'

class AaMaxCSV
  attr_accessor :header, :error_msg, :row, :last_raw_line, :row

  def initialize
    @file_handle = @options = @header = @error_msg = @row = nil
    @row_count = @column_count = 0
    @last_raw_line = nil
  end

  def open(fname, delimiter = ',', is_quoted = true, header_flag = true)
    if !File.exists?(fname)
      @error_msg = "file doesn't exist"
      return false
    end

    @options = {delimiter: delimiter, is_quoted: is_quoted, header_flag: header_flag, filename: fname}

    # open and read first line...
    @file_handle = File.open(fname, 'r')
    if header_flag == true
      @header = {}
      @file_handle.each_line("\n") {|line|
        process_line(line.strip)
        @row_count += 1
        @column_count = @header.length
        break
      }
    end
    return true
  end

  def read_line
    row = ''
    @file_handle.each_line("\n") {|line|
      @last_raw_line = line
      process_line(line)
      break
    }
  end

  def get_quoted_row(line)
    idx = 0
    new_array = []
    while idx < line.length do
      # find first char of word
      word = line[idx, line.length]
      word_end = word.index(',')
      if word_end.nil?
        new_word = word.length
        word_end = word.length
      else
        new_word = word_end + 1
      end

      char = word[0]
      if char == '"'
        word_end = word.index('",') - 1
        new_word = word_end + 3
        word = line[idx + 1, line.length]
      end
      new_array << word[0, word_end]
      break if new_word == word_end
      idx += new_word
    end
    new_array
  end

  def process_line(line)
    if @options[:is_quoted] == false
      if (@options[:header_flag] == true) && (@row_count == 0)
        @header_array = line.split(@options[:delimiter])
        @header_array.each_with_index do |str, idx|
          @header[str] = idx
        end
      elsif @row_count > 0
        # read regular line
        row = line.split(@options[:delimiter])
        @row = {}
        row.each_with_index do |r, idx|
          @row[@header_array[idx].to_sym] = r
          @row[@header_array[idx]] = r
        end
      end
    else
      # read  quoted fields
      if (@options[:header_flag] == true) && (@row_count == 0)
        @header_array = get_quoted_row(line)
        @header_array.each_with_index do |str, idx|
          @header[str] = idx
        end
      elsif @row_count > 0
        @row_array = get_quoted_row(line)
        @row = {}
        @row_array.each_with_index do |r, idx|
          @row[@header_array[idx].to_sym] = r
          @row[@header_array[idx]] = r
        end
      end
    end
  end
end

# use csv parser to solve problem...



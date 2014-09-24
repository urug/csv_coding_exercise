class Parser
  def initialize filename, delimiter=","
    @fhandle = File.open(filename, 'r')
    @delim = delimiter
    @header = []
    @arr_val = []
    line_str = @fhandle.readline
    @header = parse_row(line_str)
  end
  
  def header
    @header
  end
  
  def eof?
    @fhandle.eof?
  end
  
  def read
    line_str = @fhandle.readline
    parse_row(line_str)
  end
  
  def parse_row(line)
    ret_val = []
    while !line.nil? && line.length > 0
      result = parse_field(line)
      line = result[1]
      ret_val << result[0]
    end
    ret_val
  end
  
  def parse_field(str)
    str.chomp!
    ret_val = []
    if str[0] != '"'
      field = str.split(@delim)[0]
      ret_val << field
      ret_val << str[field.length + 1, str.length]
    else
      idx = 1
      
puts " idx: #{idx} quoted field: #{str}"      if str[0] == '"'


      while true
        if str[idx] == '"'
          # read to quote followed by delim or eol
          if (idx == str.length - 1) || (str[idx + 1] == @delim)
            fld = str[1..idx]
            str = str[idx + 2, str.length]
            ret_val = [fld, str]
            break
          end
          idx += 1
        else
          # read to next delim or eol
          if (idx == str.length - 1) || (str[idx] == @delim)
            fld = str[0..idx - 1]
            str = str[idx + 1, str.length]
            ret_val = [fld, str]
            break
          end
          idx += 1
        end       
        break if str.empty?
      end      
    
    end
    ret_val
  end
  
  def close
    @fhandle.close if @fhandle
  end
  
end

p = Parser.new('./import_files/prodfile.csv')
puts "Header: #{p.header}"
until p.eof?
  puts p.read.map {|v| v}.join(',')
end
p.close


require_relative "solution"

class TestAaMaxCSV < MiniTest::Unit::TestCase
  def test_fail_if_file_missing
    csv = AaMaxCSV.new
    assert_equal csv.open("./nofile.csv"), false, "open should be false if file is not present #{csv.error_msg}"
    assert_equal csv.error_msg, "file doesn't exist", "file doesn't exist message not correct. is: #{csv.error_msg}"
  end

  def test_return_non_nil_if_file_present
    csv = AaMaxCSV.new
    assert_equal csv.open("./data.csv"), true, "open should be successful.  isn't #{csv.error_msg}"
  end

  def test_read_header_row_non_quoted
    csv = AaMaxCSV.new
    csv.open("./data.csv", ',', false, true)
    hdr = csv.header
    assert_equal hdr.nil?, false, "header should not be nil"
    assert_equal hdr.length, 3, "number of fields should be 3"
    assert_equal hdr['NAME'], 0, 'position of name field wrong'
    assert_equal hdr['PHONE'], 1, 'position of phone field wrong'
    assert_equal hdr['EMAIL'], 2, 'position of email field wrong'
  end

  def test_raw_line_value_correct
    csv = AaMaxCSV.new
    csv.open("./data.csv", ',', false, true)
    csv.read_line
    assert_equal csv.last_raw_line, "allen,8015024745,aamax@xmission.com", "line value wrong #{csv.last_raw_line}"
  end

  def test_non_quoted_file_read_line
    csv = AaMaxCSV.new
    csv.open("./data.csv", ',', false, true)
    csv.read_line
    assert_equal 'allen', csv.row[:NAME], "name value wrong: #{csv.row.inspect} ---> #{ csv.row[:NAME]}"
    assert_equal 'allen', csv.row['NAME'], "name value wrong: #{csv.row.inspect} ---> #{ csv.row['NAME']}"
  end

  def test_quoted_file_read_line
    csv = AaMaxCSV.new
    csv.open("./quoted_data.csv", ',', true, true)
    csv.read_line

    assert_equal '8015024745', csv.row[:PHONE], "phone value wrong: #{csv.row.inspect} ---> #{ csv.row[:PHONE]}"
    assert_equal '8015024745', csv.row['PHONE'], "phone value wrong: #{csv.row.inspect} ---> #{ csv.row['PHONE']}"
    assert_equal 'allen', csv.row[:NAME], "name value wrong: #{csv.row.inspect} ---> #{ csv.row[:NAME]}"
    assert_equal 'allen', csv.row['NAME'], "name value wrong: #{csv.row.inspect} ---> #{ csv.row['NAME']}"
    assert_equal 'aamax@xmission.com', csv.row[:EMAIL], "email value wrong: #{csv.row.inspect} ---> #{ csv.row[:EMAIL]}"
    assert_equal 'aamax@xmission.com', csv.row['EMAIL'], "email value wrong: #{csv.row.inspect} ---> #{ csv.row['EMAIL']}"
  end

  def test_quoted_header_value
    csv = AaMaxCSV.new
    csv.open("./quoted_data.csv", ',', true, true)
    hdr = csv.header
    assert_equal hdr.nil?, false, "header should not be nil"
    assert_equal hdr.length, 3, "number of fields should be 3"
    assert_equal hdr['NAME'], 0, 'position of name field wrong'
    assert_equal hdr['PHONE'], 1, 'position of phone field wrong'
    assert_equal hdr['EMAIL'], 2, 'position of email field wrong'
  end

  # def test_quoted_line_without_embedded_commas
  #   # csv = AaMaxCSV.new
  #   # csv.open("./quoted_data.csv", ',', true, true)
  #   # row = csv.read_line
  #
  # end
  #
  # def test_fails_when_column_count_is_wrong
  #
  # end
  #
  # def test_non_comma_delimiter
  #
  # end
  #
  # def test_quoted_line_with_embedded_commas
  #
  # end
  #
  # def test_read_file_without_header
  #
  # end
end

csv_coding_exercise
===================

Basic files for SL URUG meeting on 9/23/2014 and a quick discussion on csv files in general and fastercsv and it's usage in ruby

in ruby version 1.9.2 the CSV standard library was replaced with a library called fastercsv.  this library is authored by James Edward Gray II.  

traditionally, csv stood for 'comma seperated value' file but it has come to be more accurate to call them 'character seperated value' files because many applications want to use alternate seperators (often the pipe '|' or other characters).

Most csv files utilize the first row to label the columns included below but that isn't necessarily required.  It's a nice convenience though and, with fastercsv, allows you to reference the columns as they are read by name rather than by position.  This also allows files to be consumed if the columns are not in a set order from delivery to delivery without any problems.

Ruby has built in string processing methods that are great.  If the csv file is not mal-formed in any way and doesn't have any quoted fields, then parsing an entry is simply
 
	data.split(',')
	
the problem arrises when we want to quote fields to allow for embedded commas in a comma separated file, or other embedded delimiter characters.  That's where it gets a little dicey and the library makes life dramatically easier.

The basic pattern I've used for reading CSV files is below

	require 'csv'
	
	CSV.foreach('myfilename', {:headers => :first_row}) do |row|
		# skip blank and commented rows
		next if row.nil? || row.empty? || row[0][0] == '#'
		
		# convert to hash to be able to read by column name
		hash = row.to_hash
		
		# process row or hash contents from file
		... do stuff here ...
		
	end
	
Basic things to discuss and watch out for:
* quoted fields - use quotation marks or other characters to quote fields so you can embed the delimiter character in the data being read
* non utf8 file coding.  I've run into this and haven't found a great solution so am interested in discussing it.  Sometimes wide-chars can cause problems too but fastercsv can choke on different file encoding
*	field order different from file to file - can make reading using an array index approach problematic   
*	csv file size - not sure on limits or issues with this - would like to hear peoples experience on issues using fastercsv with large csv files
*	uploading csv files to server in rails apps - timeout issues.   I've had to deal with this using the delayed_jobs gem because rails will time out if the csv file is too large.  

# Coding Exercise - let's build a csv parser! (oh boy!!!)

###### the code can be published for other users by adding it to this gist: https://gist.github.com/aamax/3fdf85c50407bad9c630

The challenge this month is to build a parser to read csv files.  The parameters are as follows:
*	You may NOT use any external libraries for reading csv files (like faster csv) to solve the challenge.
*	You must account for quoted strings (quotes will always be double quote chars: "") and allow the file delimiter to be embedded within the quotes
*	You must allow for a user specified delimiter (comma, pipe, tilde...?)

we will not use a non UTF8 file encoding or non-ascii chars so no worries there.

There are some sample files in the import_files directory.  

the challenge will read some files that represent sales transactions for some kinds of products.  the sample files are selling computer/office supplies.  there are 2 files: a products file and a transactions file.  read the files using your csv parser and report the following in your output:

*	for each product show: highest price, lowest price, average price, total quantity sold, total revenue for each item
*	show the total revenue for all items

### The other requirement is to have fun!

require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'

puts "EventManager initialized!\n\n"

# Methods
def read_columns_per_line
  lines = File.readlines 'event_attendees.csv'
  lines.each do |line|
    columns = line.split(',')
    p columns
  end
end

def read_first_names_homegrown
  lines = File.readlines 'event_attendees.csv'
  lines.each_with_index do |line, index|
    next if index.zero?

    columns = line.split(',')
    name = columns[2]
    puts name
  end
end

# Using the csv gem, we can specify that the file has
#  headers when we read from it
# Using the csv gem, we can grab our columns with symbols if we use
#  header_converters
def read_first_names
  contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents.each do |row|
    name = row[:first_name]
    puts name
  end
end

# Method to clean up bad zipcodes
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def read_first_names_and_zipcodes
  contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents.each do |row|
    name = row[:first_name]
    zipcode = row[:zipcode]

    # Clean up bad zipcodes
    zipcode = clean_zipcode(zipcode)

    puts "#{name} #{zipcode}"
  end
end

def legislators_by_zipcode(zip)
  # Assign API info for the following methods
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
        address: zip,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody'])
 
    legislators = legislators.officials

    legislator_names = legislators.map(&:name)

    legislator_names.join(', ')
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def read_first_names_and_zipcodes_then_use_api
  contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    legislators = legislators_by_zipcode(zipcode)

    template_letter = File.read 'form_letter.erb'
    erb_template = ERB.new template_letter
    form_letter = erb_template.result(binding)
    
    # output to a file
    Dir.mkdir('output') unless Dir.exists? 'output'

    filename = "output/thanks_#{name}-#{zipcode}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end
end

read_first_names_and_zipcodes_then_use_api

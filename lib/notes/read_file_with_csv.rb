# frozen_string_literal: true

require 'csv'

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

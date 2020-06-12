# frozen_string_literal: true

require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'

puts "EventManager initialized!\n\n"

# Methods

# Method to clean up bad zipcodes
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

# Gets legistlators with the Google Civic Info API
def legislators_by_zipcode(zip)
  # Assign API info for the following methods
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )

    legislators = legislators.officials

    legislator_names = legislators.map(&:name)

    legislator_names.join(', ')
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

# Reads from the CSV file, pulls out the names and zipcodes, and then pulls
#  the legislators for that zipcode to spin up a thank you HTML letter per person
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
    Dir.mkdir('output') unless Dir.exist? 'output'

    filename = "output/thanks_#{name}-#{zipcode}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end
end

read_first_names_and_zipcodes_then_use_api

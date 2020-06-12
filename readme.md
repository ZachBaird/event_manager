# Event Manager

This repository is a Ruby project that includes the following functionality:

* File IO serialization with `File` and Ruby's CSV parser
* Cleaning up data like bad zipcodes
* Binding data to an erb file
* Leveraging an API and parsing out the required data
* Some error handling

## Getting Started

To run this project, all you need is Ruby installed on your system. I wrote this in Ruby 2.6.5.

## Files

Code files sit inside the `lib` directory. The `event_manager.rb` file is the entrypoint of the application. Some legacy code I wrote while building this sits in the `lib/notes` directory. This includes some code reading the csv file without the `csv` gem and some code reading it out with the `csv` gem.
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
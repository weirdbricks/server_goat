require "yaml"
require "./plugins/yum.cr"



module ServerGoat
  VERSION = "0.1.0"

  if ARGV.size != 1
    puts "Usage: You need to provide a filename"
    puts "#{PROGRAM_NAME} /path/to/file"
    exit 0
  end

  filename=ARGV[0]
  check_if_file_exists(filename)

  yaml = File.open(filename) do |file|
    YAML.parse(file)
  end

  if yaml.as_a?
    puts "OK, I can parse as an array"
  else
    abort "Sorry, I cannot parse this YAML"
  end
  
  yaml_array = yaml.as_a

  puts "The array I parsed from the YAML has: #{yaml_array.size} elements"

  yaml_array.each do |item|
    item.as_h.each do |k,v|
      puts "#{k} => #{v}"
      if k == "name"
        puts "PLAY [#{v}] ***************************************************"
      end
      if k == "tasks"
        puts "yoo tasks:"
        tasks_array=v.as_a
	puts "Number of tasks: #{tasks_array.size}"
        tasks_array.each do |task|
	  puts task
	end
      end
    end
  end














end

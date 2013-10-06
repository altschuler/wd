# define 
@alias_file = "#{ENV['HOME']}/.warps"

def add_target(name, target)
  File.open(@alias_file, 'a') do |file|
    file.puts "#{name}:#{target}"
  end
end

def rem_target
  
end

def warp(dest)
  found = false
  File.readlines(@alias_file).each do |line|
    ali = line.split(':')
    name = ali[0].strip!
    dir = ali[1].strip!
    if ali[0] == dest then
      puts dir
      found = true
    end
  end

  if not found then
    puts "no warps named '#{dest}'"
    exit 1
  end
end

def list_targets
  File.readlines(@alias_file).each do |line|
    puts line.sub!(':', ' -> ').strip! + '\n\r'
  end
end

# execute
case ARGV[0]
when 'add'
  if ARGV.length < 2 then 
    exit 1
  else
    dir = Dir.pwd
    add_target ARGV[1], dir
    puts "added '#{ARGV[1]}' pointing to #{dir}"
  end

when 'rm'
  rem_target

when 'ls'
  list_targets

else
  warp ARGV[0]
end

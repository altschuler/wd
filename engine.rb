# yay hooray lulz from http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end
end

def wrn!(msg)
  puts 'warning: '.yellow + msg
  exit 1
end

def err!(msg)
  puts 'err: '.red + msg
  exit 1
end

def yay(msg)
  puts 'yay! '.green + msg
end

# define 
@alias_file = "#{ENV['HOME']}/.warps"

def add_target(name, target)
  File.open(@alias_file, 'a') do |file|
    file.puts "#{name}:#{target}"
  end
end

def rem_target(dest)
  all = ''
  found = false
  File.readlines(@alias_file).each do |line|
    if not line.strip().empty? then
      ali = line.split(':')
      name = ali[0]
      dir = ali[1]
      if name == dest then
        found = true
      else
        all += line
      end
    end
  end

  if not found then
    wrn! "warp does not exist '#{dest}'"
  else
    File.open(@alias_file, 'w') { |file| file.write(all) }
    yay "removed warp '#{dest}'"
  end
end

def warp(dest)
  found = false
  File.readlines(@alias_file).each do |line|
    if not line.strip().empty? then
      ali = line.split(':')
      name = ali[0].strip!
      dir = ali[1].strip!
      if name == dest then
        puts dir
        found = true
      end
    end
  end

  if not found then
    err! "warp does not exist '#{dest}'"
  end
end

def list_targets
  File.readlines(@alias_file).each do |line|
    if not line.strip().empty? then
      puts "%-6s %s" % line.split(':')
    end
  end
end

# execute
case ARGV[0]
when 'add'
  if ARGV.length < 2 then 
    err! 'no name given'
  else
    dir = Dir.pwd
    add_target ARGV[1], dir
    yay "added '#{ARGV[1]}' warping to #{dir}"
  end

when 'rm'
  if ARGV.length < 2 then 
    err! 'don\'t know what to remove'
  else
    rem_target ARGV[1]
  end

when 'ls'
  list_targets

else
  warp ARGV[0]
end

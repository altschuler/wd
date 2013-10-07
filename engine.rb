# ok hooray lulz from http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  def colorize(color_code) "\e[#{color_code}m#{self}\e[0m" end
  def red() colorize(31) end
  def green() colorize(32) end
  def yellow() colorize(33) end
end

class Messenger
  def wrn(msg)
    puts 'warning: '.yellow + msg
  end

  def err!(msg)
    puts 'error: '.red + msg
    exit 1
  end

  def ok(msg)
    puts 'ok! '.green + msg
  end

  def put(msg)
    puts msg
  end

  def banner 
    puts "warp directory"
    puts "usage: wd [add[!] <name> | rm <name> | ls]"
    puts "  add   Add cwd as a warp target, use add! to overwrite existing"
    puts "  rm    Remove warp target"
    puts "  ls    List registered targets"
  end
end

class Warper
  attr_accessor :alias_file
  attr_accessor :msg
  
  def initialize(file, messenger)
    @alias_file = file
    @msg = messenger
  end
  
  def add(name, overwrite)
    if ['add', 'add!', 'rm', 'ls'].include? name then
      @msg.err! "reserved name: '#{name}'"
    elsif name.nil? then 
      @msg.err! 'no name given'
    else
      add_inner name, Dir.pwd, overwrite
    end
  end

  def rem(dest)
    all = ''
    found = iter_lines(dest) do |line, name, dir| 
      unless name == dest then
        all += line
      end
    end

    unless found then
      @msg.wrn "warp does not exist '#{dest}'"
      exit 1
    else
      File.open(@alias_file, 'w') { |file| file.write(all) }
    end
  end

  def warp(dest)
    found = iter_lines(dest) do |line, name, dir|
      if name == dest then
        msg.put dir
      end
    end
    unless found then
      @msg.err! "warp does not exist '#{dest}'"
    end
  end

  def list_targets
    iter_lines do |line, name, dir|
      @msg.put "%-6s %s" % [name, dir]
    end
  end
  
  private 
  def iter_lines(query='')
    found = false
    File.readlines(@alias_file).each do |line| 
      unless line.strip().empty? then
        ali = line.split(':')
        name = ali[0]
        dir = ali[1]
        if name == query then found = true end
        yield line, name, dir
      end
    end
    return found
  end

  def add_inner(name, dir, overwrite)
    found = iter_lines(name) do || end
    if found and not overwrite then
      @msg.wrn "'#{name}' already exists, use 'add!' to overwrite"
    else
      if found and overwrite then
        rem name
      end
      File.open(@alias_file, 'a') do |file|
        file.puts "#{name}:#{dir}"
      end
      @msg.ok "added '#{name}' warping to #{dir}"
    end
  end
end

# warp drive
msg = Messenger.new
engine = Warper.new "#{ENV['HOME']}/.warps", msg
cmd, arg = ARGV

if cmd.nil? then
  msg.banner
  exit 1
end

case cmd
when 'add'
  engine.add arg, false

when 'add!'
  engine.add arg, true

when 'rm'
  if @arg.nil? then 
    msg.err! 'don\'t know what to remove'
  else
    engine.rem arg
    msg.ok "removed warp '#{dest}'"
  end

when 'ls'
  engine.list_targets

else
  engine.warp cmd
end

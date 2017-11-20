puts "Enter ROM Name with extension"
rom = gets.chomp

def read_rom(rom)
  contents = []
  File.open(rom, "rb") do |file|
    until file.eof?
      buffer = file.read(2)
      contents << buffer.unpack('H*')
    end
  end
  contents.flatten
end

def translate(op)
  case
  when op == '00e0'
    puts "#{op} - Clear Screen"
    "#{op} - Clear Screen"
  else
    puts "Unknown/Bad OP"
    "Unknown/Bad OP"
  end
end

def letter?(lookAhead)
  lookAhead =~ /[[:alpha:]]/
end

def numeric?(lookAhead)
  lookAhead =~ /[[:digit:]]/
end

ops = read_rom(rom)
ops.each { |op| translate(op) }

ops.each do |op|
  File.open("#{rom}.txt", 'a+') { |file| file.write( "\n#{translate(op)}") }
end

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
    puts "#{op} - clear screen"
    "#{op} - clear screen"
  when op == '00ee'
    puts "#{op} - return from subroutine"
    "#{op} - return from subroutine"
  when op == '0000'
    puts "unknown/bad OP"
    "unknown/bad OP"
  when op[0] == '0' && check_last_byte(op, 0) # Check the last byte to make sure it isn't 0
    puts "#{op} - jump to routine at #{op[1..-1]}"
    "#{op} - jump to routine at #{op[1..-1]}"
  when op[0] == 1
    puts "#{op} - jump to address #{op[1..-1]}"
    "#{op} - jump to address #{op[1..-1]}"
  when op[0] == 2
    puts "#{op} - call subroutine at #{op[1..-1]}"
    "#{op} - call subroutine at #{op[1..-1]}"
  else
    puts "unknown/bad OP"
    "unknown/bad OP"
  end
end

# Used when checking the 0x0nnn opcode to make sure the opcode isn't actually 0x000
def check_last_byte(op, value)
  return true if op[2..-1].to_i > value
end

def letter?(lookAhead)
  lookAhead =~ /[[:alpha:]]/
end

def numeric?(lookAhead)
  lookAhead =~ /[[:digit:]]/
end

ops = read_rom(rom)

ops.each do |op|
  File.open("#{rom}.txt", 'a+') { |file| file.write( "\n#{translate(op)}") }
end

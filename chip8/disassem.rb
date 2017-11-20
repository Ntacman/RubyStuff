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
    "#{op} - clear screen"
  when op == '00ee'
    "#{op} - return from subroutine"
  when op == '0000'
    "unknown/bad OP #{op}"
  when op[0] == '0' && check_last_byte(op, 0) # Check the last byte to make sure it isn't 0
    "#{op} - jump to routine at #{op[1..-1]}"
  when op[0] == '1'
    "#{op} - jump to address #{op[1..-1]}"
  when op[0] == '2'
    "#{op} - call subroutine at #{op[1..-1]}"
  when op[0] == '3'
    "#{op} - skip next instruction if register V#{op[1]} == #{op[2..-1]}"
  when op[0] == '4'
    "#{op} - skip next instruction if register V#{op[1]} != #{op[2..-1]}"
  when op[0] == '5'
    "#{op} - skip next instruction if register V#{op[1]} == Register V#{op[2]}"
  when op[0] == '6'
    "#{op} - set V#{op[1]} to #{op[2..-1]}"
  when op[0] == '7'
    "#{op} - set register V#{op[1]} to V#{op[1]} + #{op[2..-1]}"
  when op[0] == '8' && op[3] == '0'
    "#{op} - Set the value of V#{op[1]} to value of V#{op[2]}(V#{op[1]} == V#{op[2]})"
  else
    "unknown/bad OP #{op}"
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
  if op == ops.first
    File.open("#{rom}.txt", 'a+') { |file| file.write( "#{translate(op)}") }
  else
    File.open("#{rom}.txt", 'a+') { |file| file.write( "\n#{translate(op)}") }
  end
end

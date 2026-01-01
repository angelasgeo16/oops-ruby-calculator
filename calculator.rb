
# Helper function to perform arithmetic operations
def perform_operation(o1, operator, o2)
  case operator
  when "+"
    o1 + o2
  when "-"
    o1 - o2
  when "*"
    o1 * o2
  when "/"
    return "Division by zero is not possible" if o2 == 0
    o1 / o2
  when "//"
    return "Division by zero is not possible" if o2 == 0
    o1.to_f / o2.to_f
  end
end

# Helper to detect extra operators inside operands (like multi-operations)
def contains_operator_beyond_sign?(s)
  return false if s.nil? || s.empty?
  rest = s.start_with?("+", "-") ? s[1..-1] : s
  !!(rest =~ /[+\*\/%^-]/)
end

def calculate(operation)
  s = operation.to_s.strip

  # 1) Strict match: two integers and one of the supported operators
  strict = s.match(/^(-?\d+)\s*(\+|\-|\*|\/{1,2})\s*(-?\d+)$/)
  if strict
    o1 = strict[1].to_i
    operator = strict[2]
    o2 = strict[3].to_i
    return perform_operation(o1, operator, o2)
  else
    # 2) Fallback: try to extract three tokens (operand, operator, operand)
    fallback = s.match(/^\s*(\S+?)\s*([^\d\s]+)\s*(\S+)\s*$/)
    return "Invalid Expression" if fallback.nil?

    o1_str, operator, o2_str = fallback.captures

    # Multi-operation check
    if contains_operator_beyond_sign?(o1_str) || contains_operator_beyond_sign?(o2_str)
      return "Invalid Expression"
    end

    # Validate operands
    begin
      Integer(o1_str)
      Integer(o2_str)
    rescue ArgumentError, TypeError
      return "Operands must be integers"
    end

    # Validate operator
    supported = ["+", "-", "*", "/", "//"]
    return "Unknown operator. Please enter a valid operator!" unless supported.include?(operator)

    # Perform calculation
    o1 = Integer(o1_str)
    o2 = Integer(o2_str)
    return perform_operation(o1, operator, o2)
  end
end


puts "Welcome to Ruby Calculator. Type 'exit', 'quit', or 'q' to quit."
puts "Supported operations: +, -, *, /, //"

loop do
  print "> "
  input = gets&.chomp
  break if input.nil? || ["exit", "quit", "q"].include?(input.downcase)

  puts calculate(input)
end

puts "Goodbye!"

require 'mocha/parameter_matchers/equals'

class Object
  
  def to_matcher # :nodoc:
    Mocha::ParameterMatchers::Equals.new(self)
  end
  
end


module LogicalLambdaMixin
  
  # AND
  def &(other)
    LogicalLambda.new {|*args| call(*args) && other.call(*args) }
  end
  
  # OR
  def |(other)
    LogicalLambda.new {|*args| call(*args) || other.call(*args) }
  end

  # Override the negative and bang as in -is_true !is_true
  def !@; LogicalLambda.new {|*args| !call(*args)}; end

  ############# Comparables #############
  
  def self.define_comparable(method_name, compare_method=nil)
    compare_method = method_name if compare_method.nil? # Default to same name
    define_method compare_method do |other|
      if other.respond_to?(:call)
        LogicalLambda.new {|*args| call(*args).send(compare_method, other.call(*args)) }
      else
        # Must not be a block
        LogicalLambda.new {|*args| call(*args).send(compare_method, other) }
      end
    end
  end
  
  define_comparable :==
  define_comparable :!=
  define_comparable :<
  define_comparable :>
  define_comparable :<=
  define_comparable :>=
  
end

class LogicalLambda < Proc
  include LogicalLambdaMixin
end


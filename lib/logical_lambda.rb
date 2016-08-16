
module LogicalLambdaMixin
  
  # AND
  def &(other)
    LogicalLambda.new {|*args| call(*args) && other.call(*args) }
  end
  
  # Override the negative and bang as in -is_true !is_true
  def !@; LogicalLambda.new {|*args| !call(*args)}; end
  #def -@; LogicalLambda.new {|*args| !call(*args)}; end
  #def ~@; LogicalLambda.new {|*args| !call(*args)}; end
  
  # OR
  def |(other)
    LogicalLambda.new {|*args| call(*args) || other.call(*args) }
  end

  ############# Comparables #############
  
  def self.define_comparable(compare_method)
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
  
  # def ==(other)
  #   LogicalLambda.new {|*args| call(*args) == other.call(*args) }
  # end

  # def !=(other)
  #   LogicalLambda.new {|*args| call(*args) != other.call(*args) }
  # end

  # def >(other)
  #   LogicalLambda.new {|*args| call(*args) > other.call(*args) }
  # end
  
  # def <(other)
  #   LogicalLambda.new {|*args| call(*args) < other.call(*args) }
  # end
  
  # def >=(other)
  #   LogicalLambda.new {|*args| call(*args) >= other.call(*args) }
  # end
  
  # def <=(other)
  #   LogicalLambda.new {|*args| call(*args) <= other.call(*args) }
  # end  

end

class LogicalLambda < Proc
  include LogicalLambdaMixin
end


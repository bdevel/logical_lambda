require_relative '../lib/logical_lambda'
require "minitest/autorun"

class TestLogicalLambda < Minitest::Test
  def setup
    @count_foos = LogicalLambda.new {|f| f.count(:foo) }
    @count_bars = LogicalLambda.new {|f| f.count(:bar) }
    @t          = LogicalLambda.new {true}
    @f          = LogicalLambda.new {false}
  end

  ##### Basic operators #########
  
  def test_and
    assert_equal false, (@t & @f).call
    assert_equal false, (@f & @t).call
    assert_equal true, (@t & @t).call
  end
  
  def test_or
    assert_equal true, (@t | @f).call
    assert_equal true, (@f | @t).call
  end

  def test_not
    assert_equal false, (!@t ).call
    assert_equal true, (@t & !@f ).call
  end

  ######### Chains #######

  def test_chaining_ands
    did_run_last = false
    last = LogicalLambda.new do
      did_run_last = true
      true
    end
    assert_equal true, (!@f & @t & last).call
    assert_equal true, did_run_last
  end
  
  def test_chaining_ors
    did_run_last = false
    last = LogicalLambda.new do
      did_run_last = true
      true
    end
    assert_equal true, (@f | !@t | last).call
    assert_equal true, did_run_last
  end

  ########## Comparables ###########

  def test_gt
    has_more_bars = @count_bars > @count_foos
    assert_equal true, has_more_bars.call([:foo, :bar, :bar])
    assert_equal false, has_more_bars.call([:foo, :foo, :bar])
  end

  def test_lt
    has_less_bars = @count_bars < @count_foos
    assert_equal false, has_less_bars.call([:foo, :bar, :bar])
    assert_equal true, has_less_bars.call([:foo, :foo, :bar])
  end

  def test_gte
    has_gte_bars = @count_bars >= @count_foos
    assert_equal true, has_gte_bars.call([:foo, :bar, :bar])
    assert_equal false, has_gte_bars.call([:foo, :foo, :bar])
    assert_equal true, has_gte_bars.call([:foo, :foo, :bar, :bar])
  end

  def test_lte
    has_lte_bars = @count_bars <= @count_foos
    assert_equal false, has_lte_bars.call([:foo, :bar, :bar])
    assert_equal true, has_lte_bars.call([:foo, :foo, :bar]) 
    assert_equal true, has_lte_bars.call([:foo, :foo, :bar, :bar])
  end

  
  def test_equal
    has_eq_bars = @count_bars == @count_foos
    assert_equal true,  has_eq_bars.call([:foo, :foo, :bar, :bar])
    assert_equal false, has_eq_bars.call([:foo, :foo, :bar])
  end
  
  def test_not_equal
    has_eq_bars = @count_bars != @count_foos
    assert_equal false,  has_eq_bars.call([:foo, :foo, :bar, :bar])
    assert_equal true, has_eq_bars.call([:foo, :foo, :bar])
  end
  

  def test_comparable_with_numbers
    eq   = @count_bars == 3
    neq  = @count_bars != 3
    gt   = @count_bars >  3
    gte  = @count_bars >= 3
    lt   = @count_bars <  3
    lte  = @count_bars <= 3

    assert_equal true,   eq.call([:bar, :bar, :bar])
    assert_equal true,   neq.call([:foo, :foo, :bar])
    assert_equal true,   gt.call([:bar, :bar, :bar, :bar])
    assert_equal false,  gt.call([:bar, :bar, :bar])
    assert_equal true,   gte.call([:bar, :bar, :bar])
    assert_equal true,   lt.call([:foo, :foo, :bar])
    assert_equal false,  lt.call([:bar, :bar, :bar])
    assert_equal true,   lte.call([:bar, :bar, :bar])
  end  

end

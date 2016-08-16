require_relative '../lib/logical_lambda'
require "minitest/autorun"

class Proc
  include LogicalLambdaMixin
end

class LogicalLambdaMixinTest < Minitest::Test
  def setup
    @proc = Proc.new(){}
    @lambda = lambda {}
  end
  
  def test_procs_have_logic
    assert @proc.respond_to?(:&)
    assert @proc.respond_to?(:|)
    assert @proc.respond_to?(:>=)
    assert @proc.respond_to?(:==)
    assert @proc.respond_to?(:<)
  end

  def test_lambdas_have_logic
    assert @lambda.respond_to?(:&)
    assert @lambda.respond_to?(:|)
    assert @lambda.respond_to?(:>=)
    assert @lambda.respond_to?(:==)
    assert @lambda.respond_to?(:<)
  end
  
  def test_lambdas_validate_params
    begin
      x = lambda {|a,b|true}
      x.call(1)
      assert false, "Did not validate params"
    rescue Exception => e
      assert_equal ArgumentError, e.class
    end
  end

  def test_proc_doesnt_validate_params
    begin
      x = Proc.new {|a,b|true}
      x.call(1)
      assert true
    rescue Exception => e
      assert false, "Proc validated params when shouldn't"
    end
  end

end

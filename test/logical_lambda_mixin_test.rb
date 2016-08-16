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


end

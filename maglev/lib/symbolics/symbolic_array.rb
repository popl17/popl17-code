class SymbolicArray < SymbolicEmptinessValue
  attr_reader :sym_value
  def initialize(name, sym_val, is_empty=nil)
    super(name,is_empty)
    # TODO: Fixme
    #fail "SymbolicArray#sym_val needs to be symbolic" unless
    #    sym_val.is_a? SymbolicValue
    @sym_value = sym_val
  end

  def map
    # We make a new bound var for every instantiation of map.
    bound_var = SymbolicValue.dup(self.sym_value, tracer.new_var)
    map_ast = TraceAST::Map.new(self.ast,bound_var.ast)
    res_ast = tracer.new_var_for(map_ast)
    res_val = yield bound_var
    tracer.trace(res_val)
    tracer.trace(TraceAST::End.new)
    # TODO: Fixme
    # The correct solution is to make a new_bv of same type as
    # res_val. Below is an incorrect solution.
    # new_bv = SymbolicValue.dup(self.sym_value, tracer.new_var)
    SymbolicArray.new(res_ast, res_val, self.is_empty)
  end

  # TODO: Fixme
  def each
=begin
    # We make a new bound var for every instantiation of each.
    bound_var = SymbolicValue.dup(self.sym_value, tracer.new_var)
    tracer.trace(TraceAST::Each.new(self.ast,bound_var.ast))
    yield bound_var
=end
    tracer.info "**** Before yeilding in each ****"
    yield self.sym_value
    tracer.info "**** After yeilding in each ****"
    #tracer.trace(TraceAST::End.new)
    self
  end

  def first
    meth_ast = TraceAST::Var.new("first")
    var = tracer.new_var_for(TraceAST::Dot.new(self.ast,meth_ast))
    amb.choose(var, nil, sym_value)
  end

  def to_s
    meth_ast = TraceAST::Var.new("to_s")
    var = tracer.new_var_for(TraceAST::Dot.new(self.ast,meth_ast))
    SymbolicNonEmptyString.new var
  end

end
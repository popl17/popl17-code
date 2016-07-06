class SymbolicInteger < SymbolicValue
  def initialize(ast)
    super
  end
  def to_i
    self
  end
  def <(other_ast)
    bool_op = TraceAST::BoolOp.new(self.ast,'<',other_ast)
    var = tracer.new_var_for(bool_op)
    amb.choose(var, true,false)
  end
  def >(other_ast)
    bool_op = TraceAST::BoolOp.new(self.ast,'>',other_ast)
    var = tracer.new_var_for(bool_op)
    amb.choose(var,true,false)
  end
  def <=(other_ast)
    bool_op = TraceAST::BoolOp.new(self.ast,'<=',other_ast)
    var = tracer.new_var_for(bool_op)
    amb.choose(var,true,false)
  end
  def >=(other_ast)
    bool_op = TraceAST::BoolOp.new(self.ast,'>=',other_ast)
    var = tracer.new_var_for(bool_op)
    v=amb.choose(var,true,false)
    v
  end
  def ==(other_ast)
    return super if other_ast.is_a? Numeric or other_ast.is_a? SymbolicInteger
    # Comparision between integers and non-numeric values
    # always returns false
    false
  end
  def +(other)
    SymbolicInteger.new ("#{self}+#{other}")
  end

  def to_int(*args)
    self
  end
=begin
  # SymbolicValue already provides this method
  def ==(other)
    var = tracer.var_for "#{name}==#{other}"
    amb.choose(true,false)
  end
=end
end
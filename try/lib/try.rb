
module Try
  #
  # Evaluates the given block and returns its value.
  # If an exception is raised, that exception is returned instead.
  #
  def try &bk
    yield
  rescue Exception => ex
    ex
  end

  #
  # Evaluates the given block and returns its value.
  #
  # Specific exception types can be trapped by passing them as
  # parameters.
  #
  # Additionally, specific exception types can default to a fallback
  # value if passed as (({Type => value})) pairs.
  #
  # Any un-trapped exception is raised normally.
  #
  # @param errs a list of exception types to trap.
  #
  def trap *errs, &bk
    hash = {}
    hash = errs.pop if errs.last.is_a? Hash
    errs.each {|ec| hash[ec] = ec }
    yield
  rescue Exception => ex
    errs.each do |klass|
      return ex if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
    end
    hash.each_pair do |klass,value|
      return value if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
    end
    raise
  end

  extend self
end


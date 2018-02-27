
class WeightedPRNG

  def initialize n, s=nil
    s ||= Random.new_seed
    @prng = Random.new(s)
    @n = n
    srand s
  end

  def inspect
    "\#<#{self.class} seed=0x#{@s.to_s 16} domain=#{@n}>"
  end

  def seed() @s; end
  def domain() @n; end

  def rand max=nil
    if max && !max.zero?
      if max < @n && max > 0
        rand1 max
      elsif max == @n
        rand_n
      else
        raise ArgumentError "out of range (#{max} for 1..#{@n})"
      end
    else
      rand0
    end
  end
  def rand_n
    @distribution[ @prng.rand(@distribution.length) ]
  end
  def rand1 n
    (rand_n.to_f / @n * n).to_i
  end
  def rand0
    rand_n.to_f / @n
  end

  def srand s=nil
    old = @s
    # update the underlying PRNG
    if s
      @prng = Random.new(s)
    else
      s = @prng.rand @n
    end
    # update my state
    @s = s
    @distribution = (0...@n).to_a
    while s > 0
      s,i = s.divmod @n
      @distribution << i
    end
    # return the old seed
    old
  end

  def diagnostic
    @distribution.group_by{|x|x}.map{|a,b|[a,b.length]}.sort_by{|a,b|-b}.map{|a,b|' %2d:%-2d'%[a,b]}.join + "  #{@distribution.length}"
  end
end


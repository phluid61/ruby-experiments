
#
# Christian Huitema
#
class PolyPRNG
  def initialize seed=nil
    srand seed
  end

  def inspect
    "\#<#{self.class} seed=0x#{@seed.to_s 16}>"
  end

  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed
      end
      @state = @seed & 0xFFFFFFFF
    end
  end

  def next_bit
    overflow = @state >> 31
    @state = (@state << 1) & 0xFFFFFFFF
    @state ^= (overflow * 0x1EDC6F41) & 0xFFFFFFFF
    @state & 1
  end

  def next_bits n
    # first bit = most significant
    value = 0
    n.times { value = value << 1 | next_bit }
    value
  end

  def rand max=nil
    if max && !max.to_i.zero?
      next_bits(Math.log2(max.to_i).ceil) % max.to_i
    else
      Float('0x%xp-53' % next_bits(53))
    end
  end
end


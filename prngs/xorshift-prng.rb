
class AbstractXorshiftPRNG
  def initialize seed=nil
    srand seed
  end

  def inspect
    "\#<#{self.class} seed=0x#{@seed.to_s 16}>"
  end

  def srand seed=nil
    raise NotImplementedError
  end

  def rand max=nil
    if max && !max.zero?
      (rand_n * max) / 0xFFFFFFFF
    else
      rand_n.to_f / 0xFFFFFFFF
    end
  end

  def rand_n
    raise NotImplementedError
  end
end

class AbstractXorshift64PRNG < AbstractXorshiftPRNG
  def rand max=nil
    if max && !max.zero?
      (rand_n * max) / 0xFFFFFFFF_FFFFFFFF
    else
      rand_n.to_f / 0xFFFFFFFF_FFFFFFFF
    end
  end
end

##
# 32-bit xorshift PRNG; Marsaglia
#
class Xorshift32PRNG < AbstractXorshiftPRNG

  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed
      end
      @state = @seed & 0xFFFFFFFF
      @state = 0xDEADBEEF if @state.zero?
    end
  end

  # Gets a 32-bit unsigned integer value.
  def rand_n
    x = @state
    x ^= (x << 13) & 0xFFFFFFFF
    x ^=  x >> 17
    x ^= (x <<  5) & 0xFFFFFFFF
    @state = x
  end
end

##
# 128-bit xorshift PRNG; Marsaglia
#
class Xorshift128PRNG < AbstractXorshiftPRNG

  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed
      end
      @state = [@seed & 0xFFFFFFFF, (@seed >> 8) & 0xFFFFFFFF, (@seed >> 16) & 0xFFFFFFFF, (@seed >> 24) & 0xFFFFFFFF]
      @state[3] = 0xDEADBEEF if @state.all? &:zero?
    end
  end

  # Gets a 32-bit unsigned integer value.
  def rand_n
    t = @state[3]
    t ^= (t << 11) & 0xFFFFFFFF
    t ^= t >> 8
    @state[3] = @state[2]
    @state[2] = @state[1]
    @state[1] = s = @state[0]
    t ^= s
    t ^= s >> 19
    @state[0] = t
  end
end

##
# xorwow PRNG; Marsaglia
#
class XorwowPRNG < AbstractXorshiftPRNG

  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed
      end
      @state = [@seed & 0xFFFFFFFF, (@seed >> 8) & 0xFFFFFFFF, (@seed >> 16) & 0xFFFFFFFF, (@seed >> 24) & 0xFFFFFFFF]
      @state[3] = 0xDEADBEEF if @state.all? &:zero?
      @counter = (@seed >> 32) & 0xFFFFFFFF
    end
  end

  # Gets a 32-bit unsigned integer value.
  def rand_n
    t = @state[3]
    t ^=  t >>  2
    t ^= (t <<  1) & 0xFFFFFFFF
    @state[3] = @state[2]
    @state[2] = @state[1]
    @state[1] = s = @state[0]
    t ^= s
    t ^= (s << 4) & 0xFFFFFFFF
    @state[0] = t
    @counter = (@counter + 362437) & 0xFFFFFFFF
    (t + @counter) & 0xFFFFFFFF
  end
end

##
# xorshift* PRNG; Marsaglia
#
class XorshiftStarPRNG < AbstractXorshift64PRNG
  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed * Random.new_seed
      end
      @state = @seed & 0xFFFFFFFF_FFFFFFFF
      @state = 0xDEADBEEF_DEADBEEF if @state.zero?
    end
  end

  # Gets a 64-bit unsigned integer value.
  def rand_n
    x = @state
    x ^=  x >> 12
    x ^= (x << 25) & 0xFFFFFFFF_FFFFFFFF
    x ^=  x >> 27
    @state = x
    (x * 0x2545F4914F6CDD1D) & 0xFFFFFFFF_FFFFFFFF
  end
end

##
# xorshift1024* PRNG; Marsaglia + Vigna
#
class Xorshift1024StarPRNG < AbstractXorshift64PRNG
  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed * Random.new_seed
      end
      @state = Array.new(16)
      x = @seed
      16.times.inject(@seed) do |s, i|
        @state[i] = s & 0xFFFFFFFF_FFFFFFFF
        s >>= 64
      end
      @state[15] = 0xDEADBEEF_DEADBEEF if @state.all? &:zero?
      @p = 0
    end
  end

  # Gets a 64-bit unsigned integer value.
  def rand_n
    s0 = @state[@p]
    @p = (@p + 1) & 15
    s1 = @state[@p]

    s1 ^= (s1 << 31) & 0xFFFFFFFF_FFFFFFFF
    s1 ^= s1 >> 11
    s1 ^= s0 ^ (s0 >> 20)
    @state[@p] = s1
    (s1 * 0x106689D45497FDB5) & 0xFFFFFFFF_FFFFFFFF
  end
end

##
# xorshift128+ PRNG; Saito & Matsumoto + Vigna
#
class Xorshift128PlusPRNG < AbstractXorshift64PRNG
  def srand seed=nil
    @seed.tap do
      if seed
        @seed = seed.to_i
      else
        @seed = Random.new_seed * Random.new_seed
      end
      @state = [@seed & 0xFFFFFFFF_FFFFFFFF, (@seed >> 64) & 0xFFFFFFFF_FFFFFFFF]
      @state[1] = 0xDEADBEEF_DEADBEEF if @state.all? &:zero?
    end
  end

  # Gets a 64-bit unsigned integer value.
  def rand_n
    s1 = @state[0]
    s0 = @state[1]
    @state[0] = s0
    s1 ^= (s1 << 23) & 0xFFFFFFFF_FFFFFFFF
    # Older version:
    #@state[1] = s1 ^ s0 ^ (s1 >> 17) ^ (s0 >> 26)
    #(@state[1] + s0) & 0xFFFFFFFF_FFFFFFFF
    # Newer version:
    @state[1] = s1 ^ s0 ^ (s1 >> 18) ^ (s0 >> 5)
  end
end


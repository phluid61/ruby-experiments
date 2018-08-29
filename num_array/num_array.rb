
class Array
  NaN = 0 / 0.0

  def mean
    return NaN if empty?
    reduce(&:+) / length
  end

  def fmean
    return NaN if empty?
    reduce(&:+).to_f / length
  end

  def mode
    return nil if empty?
    group_by{|x|x}.map{|i,j|[j.length,i]}.sort_by{|i,j|-i}[0][1]
  end

  def multimode
    return nil if empty?
    a = group_by{|x|x}.map{|i,j|[j.length,i]}.sort_by{|i,j|-i}
    n = a[0][0]
    a.find_all{|i,j|i==n}.map{|i,j|j}
  end

  def median
    return nil if empty?
    s = sort
    l = length/2
    if length.even?
      (s[l] + s[l+1]) / 2
    else
      s[l]
    end
  end

  def fmedian
    return nil if empty?
    s = sort
    l = length/2
    if length.even?
      (s[l] + s[l+1]).to_f / 2
    else
      s[l]
    end
  end
end


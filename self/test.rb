
require_relative 'self'

p 2.self
p 2.self{|i| i * 2 }
p [1,2,3,2,3,4,1,2,3,4,5,3,4,5].group_by &:self

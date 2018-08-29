#!/usr/local/bin/ruby

VERBOSE = false
HIGHLIGHT = :fancy

#
# Inputs
#
word = 'stringy'
list = ['estrange', 'gingerly', 'stop', 'geek', 'dry', 'rad', 'ear', 'wrinkle', 'cringy', 'guy', 'stringwingy']

puts 'Inputs', '------', word.inspect, list.inspect if VERBOSE

#
# Create a clean list; i.e. only those that have 2+ letters from the 'word'
#
regex = /[^#{Regexp::escape word.each_char.to_a.uniq.join}]+/
clean_list = list.map{|lw| [lw, lw.gsub(regex, '')] }.reject{|lw,cw| cw.length < 2 }

puts 'Clean List', '----------', clean_list.inspect if VERBOSE

#
# Create a $dictionary of substrings of 'word' => matching items in list
#
$dict = {}
chars = word.each_char.to_a
(2...chars.length).each do |n|
  chars.each_cons(n).map{|x| x.join }.each do |substr|
    clean_list.each do |lw,cw|
      if cw.include? substr
        $dict[substr] ||= []
        $dict[substr] << lw
      end
    end
  end
end

puts 'Dictionary', '----------', $dict.inspect if VERBOSE

#
# Split the word up into consecutive substrings, like a Markov chain
#
def get_runs str
  return nil if str.length < 2
  return [str] if str.length == 2
  result = []
  (2..str.length).each do |n|
    rest = str.dup
    start = rest.slice! 0, n
    runs = get_runs(rest)
    result << [start, runs] if runs
  end
  result+[str]
end

chains = get_runs word

if VERBOSE
  puts 'Chains', '------'
  def flarb x, d=0
    x.each do |a,b|
      print (' '*(d*2))
      p a
      if b
        flarb b, d+1
      end
    end
  end
  flarb chains
end

#
# Walk the chain, accumulating phrases from the list that could build it.
#
def get_words chains, prefix=[]
  return [] unless chains

  results = []
  chains.each do |chain|
    head, subchains = chain
    head_words = $dict[head]
    if head_words
      head_words.each do |head_word|
        if HIGHLIGHT == :fancy
          hreg = head.each_char.map{|c| Regexp::escape c }.join(')(.*?)(')
          match = head_word.match(/(.*)(#{hreg})/)
          old = match[0]
          new = match[1..-1].inject(['',true,false]) do |x,m|
            str,odd,b = x
            if odd
              if m.empty?
                [str, !odd, b]
              elsif b
                [str + '>' + m, !odd, false]
              else
                [str + m, !odd, false]
              end
            else
              if b
                [str + m, !odd, true]
              else
                [str + '<' + m, !odd, true]
              end
            end
          end.first + ">"
          new_prefix = prefix + [head_word.sub(old, new)]
        elsif HIGHLIGHT
          hreg = head.each_char.map{|c| Regexp::escape c }.join('(.*?)')
          new_prefix = prefix + [head_word.sub(/(#{hreg})/, "<\\1>")]
        else
          new_prefix = prefix + [head_word]
        end
        if subchains
          results += get_words(subchains, new_prefix)
        else
          results << new_prefix
        end
      end
    end
  end

  results
end

foo = get_words(chains)
foo.each do |bar|
  puts bar.join ' '
end

=begin

Copyright (c) 2013, Matthew Kerwin <matthew@kerwin.net.au>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

=end

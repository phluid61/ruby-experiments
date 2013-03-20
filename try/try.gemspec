Gem::Specification.new do |s|
  s.name = 'try'
  s.version = '0.4.1'
  s.date    = '2013-03-21'
  s.summary = 'Try: do, or do not'
  s.description = 'Lazy mechanisms to capture exceptions on-the-fly.'
  s.authors = ['Matthew Kerwin']
  s.email   = 'matthew@kerwin.net.au'
  s.files   = Dir['lib/**/*.rb']
  s.homepage = 'http://rubygems.org/gems/try'
  s.license = 'Simplified BSD License'

  s.has_rdoc = true
  s.rdoc_options <<
      '--title' << 'Try: do, or do not' <<
      '--main' << 'Try' <<
      '--line-numbers' <<
      '--tab-width' << '2'
end

require 'front_matter_parser'

languages = Dir.glob('??')
sources = languages.map { |language| Dir.glob(language + '/' + '*.md') }.flatten
sources = sources.filter { |source| !source.end_with?('README.md') }

errors = []
fields = {
  'index.md' => %w[title description keywords lang comments],
  '*' => %w[id title lang level tags]
}

sources.each do |path|
  solution = FrontMatterParser::Parser.parse_file(path)
  filename = Pathname.new(path).basename.to_s
  fields_to_check = fields.key?(filename) ? fields.fetch(filename) : fields.fetch('*')

  fields_to_check.each do |field|
    errors.push("❌ [#{path}] has a missing field '#{field}'") unless solution.front_matter.key?(field)
  end
end

print "\n--- Front Matter data in #{sources.size} files have been checked ---\n\n"

errors.each { |error| print "#{error}\n" } if errors.size > 0
exit(errors.size === 0)

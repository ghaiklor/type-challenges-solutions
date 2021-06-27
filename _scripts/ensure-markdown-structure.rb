require 'front_matter_parser'

languages = Dir.glob('??')
sources = languages.map { |language| Dir.glob(language + '/' + '*.md') }.flatten
errors = []

sources.each do |path|
  solution = FrontMatterParser::Parser.parse_file(path)

  if path.end_with?('index.md')
    errors.push("❌ [#{path}] has a missing title field") unless solution.front_matter.key?('title')
    errors.push("❌ [#{path}] has a missing lang field") unless solution.front_matter.key?('lang')
    errors.push("❌ [#{path}] has a missing comments field") unless solution.front_matter.key?('comments')
    next
  end

  errors.push("❌ [#{path}] has a missing id field") unless solution.front_matter.key?('id')
  errors.push("❌ [#{path}] has a missing title field") unless solution.front_matter.key?('title')
  errors.push("❌ [#{path}] has a missing lang field") unless solution.front_matter.key?('lang')
  errors.push("❌ [#{path}] has a missing level field") unless solution.front_matter.key?('level')
  errors.push("❌ [#{path}] has a missing tags field") unless solution.front_matter.key?('tags')
end

print "\n--- Front Matter data in #{sources.size} files have been checked ---\n\n"

errors.each { |error| print "#{error}\n" } if errors.size > 0
exit(errors.size === 0)

require 'pathname'
require 'octokit'

languages = Dir.glob('??').filter { |lang| ARGV[0].nil? ? true : lang === ARGV[0] }
questions = Octokit::Client.new
                           .contents('type-challenges/type-challenges', path: 'questions')
                           .map { |question| /\d+-(.+)/.match(question.name)[1] + '.md' }
                           .sort

languages.each do |language|
  questions.each do |question|
    path = Pathname.new("#{language}/#{question}")
    puts '❌ ' + path.to_s unless path.exist?
  end
end

require 'pathname'
require 'octokit'

languages = Dir.glob('??')
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

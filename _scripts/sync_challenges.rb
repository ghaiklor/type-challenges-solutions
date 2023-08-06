# frozen_string_literal: true

require 'pathname'
require 'octokit'

languages = Dir.glob('??').filter { |lang| ARGV[0].nil? ? true : lang == ARGV[0] }
solutions = languages.map { |language| Dir.glob("#{language}/*.md") }.flatten
questions = Octokit::Client.new
                           .contents('type-challenges/type-challenges', path: 'questions')
                           .map { |question| "#{/\d+-(.+)/.match(question.name)[1]}.md" }
                           .sort
                           .map { |question| languages.map { |language| "#{language}/#{question}" } }.flatten

diff = solutions - questions | questions - solutions
diff.each do |solution|
  puts "🙋 #{solution}" unless questions.include?(solution)
  puts "📝 #{solution}" unless solutions.include?(solution)
end

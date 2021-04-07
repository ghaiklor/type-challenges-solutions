require 'pathname'
require 'octokit'

languages = ['en', 'ru', 'uk']
client = Octokit::Client.new
questions = client
  .contents('type-challenges/type-challenges', path: 'questions')
  .map{ |question| /\d+-(.+)/.match(question.name)[1] + '.md' }
  .sort()

for i in 0 ... languages.size
  for j in 0 ... questions.size
    path = Pathname.new(languages[i] + '/' + questions[j])

    if (not path.exist?())
      puts '❌ ' + path.to_s
    end
  end
end

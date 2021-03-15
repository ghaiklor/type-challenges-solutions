require 'pathname'
require 'octokit'

client = Octokit::Client.new
questions = client.contents('type-challenges/type-challenges', path: 'questions')
languages = ['en', 'ru']

for i in 0 ... languages.size
  for j in 0 ... questions.size
    name = /\d+-(.+)/.match(questions[j].name)[1] + '.md'
    path = Pathname.new(languages[i] + '/' + name)

    if (path.exist?())
      puts '✅ ' + path.to_s
    else
      puts '❌ ' + path.to_s
    end
  end
end

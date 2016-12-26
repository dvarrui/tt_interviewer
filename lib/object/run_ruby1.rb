#!/usr/bin/ruby

require_relative 'data_object'
require_relative '../formatter/question_gift_formatter'

files = ['data-array.rb','data-string1.rb','data-string2.rb']

files.each do |filename|
  filepath = File.join('input','files','ruby',filename)
  data = DataObject.new(filepath, :rubycode)
  questions = data.make_questions
  questions.each do |question|
    puts QuestionGiftFormatter.new(question).to_s
  end
end

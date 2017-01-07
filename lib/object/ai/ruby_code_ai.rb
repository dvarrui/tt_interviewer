
require_relative '../../lang/lang_factory'
require_relative '../../ai/question'

class RubyCodeAI
  def initialize(data_object)
    @data_object = data_object
    @lines = data_object.lines
    @lang = LangFactory.instance.get('es')
    @num = 0
    @questions = []
    @output = '' #FIXME
  end

  def name
    @data_object.filename
  end

  def num
    @num+=1
  end

  def clone_array(array)
    out = []
    array.each { |item| out << item.dup }
    out
  end

  def lines_to_s(lines)
    out = ''
    lines.each_with_index do |line,index|
        out << "%2d: #{line}\n"%(index+1)
    end
    out
  end

  def lines_to_html(lines)
    out = ''
    lines.each_with_index do |line,index|
        out << "%2d: #{line}</br>"%(index+1)
    end
    out
  end

  def make_questions
    @questions += make_comment_error
    @questions += make_string_error
    @questions += make_keyword_error
    @questions
  end

  def make_comment_error
    error_lines = []
    questions = []
    @lines.each_with_index do |line,index|
      if line.include?('#')
        lines = clone_array @lines
        lines[index].sub!('#','').strip!

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1uncomment"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'Comment symbol removed'
        questions << q
      elsif line.strip.size>0
        lines = clone_array @lines
        lines[index]='# ' + lines[index]

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1comment"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'Comment symbol added'
        questions << q
      end
    end
    questions
  end

  def make_string_error
    error_lines = []
    questions = []
    @lines.each_with_index do |line,index|
      if line.include?("'")
        lines = clone_array @lines
        lines[index].sub!("'",'')

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1string"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'String error: simple apostrophe deleted'
        questions << q

        lines = clone_array @lines
        lines[index].sub!("'",'"')

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1string"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'String error: simple apostrophe changed'
        questions << q
      elsif line.include?('"')
        lines = clone_array @lines
        lines[index].sub!('"',"'")

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1string"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'String error: doble apostrophe changed'
        questions << q

        lines = clone_array @lines
        lines[index].sub!('"',"")

        q = Question.new(:short)
        q.name = "#{name}-#{num}-code1string"
        q.text = @lang.text_for(:code1,lines_to_html(lines))
        q.shorts << (index+1)
        q.feedback = 'String error: doble apostrophe deleted'
        questions << q
      end
    end
    questions
  end

  def make_keyword_error
    error_lines = []
    questions = []
    @lines.each_with_index do |line,index|
      error_lines << index if line.include?("end")
    end
    error_lines.each do |index|
      lines = clone_array @lines
      lines[index].sub!('end','edn')
      q = Question.new(:short)
      q.name = "#{name}-#{num}-code1keyword"
      q.text = @lang.text_for(:code1,lines_to_html(lines))
      q.shorts << (index+1)
      q.feedback = 'Keyword error: "edn" must be "end"'
      questions << q
    end
    questions
  end
end
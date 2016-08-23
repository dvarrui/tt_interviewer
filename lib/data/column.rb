# encoding: utf-8

class Column
  attr_reader :row, :index, :id, :raw, :lang, :type

  def initialize( pRow, index, pXMLdata )
    @row   = pRow
    @index = index
    @id    = pRow.id + "." + @index.to_s
    @raw   = ""
    @lang  = pRow.langs[@index]
    @type  = "text"

    read_data_from_xml(pXMLdata)
  end

  def to_html
    case @type
    when "text"
      return @raw
    when "image_url"
      return "<img src=\"#{raw}\" alt\=\"image\">"
    when "textfile_path"
      return "<pre>#{raw}</pre>"
    else
      return "ERROR type #{@type}"
    end
  end

private
  def read_data_from_xml(pXMLdata)
    if pXMLdata.elements.count>0 then
      raise "[ERROR] Column: read data from xml"
    end
    @raw = pXMLdata.text.strip.to_s

    #read attributes from XML data
    if pXMLdata.attributes['lang'] then
      @lang = LangFactory.instance.get( pXMLdata.attributes['lang'].strip )
    end

    if pXMLdata.attributes['type'] then
      @type = pXMLdata.attributes['type'].strip
    end
  end

end
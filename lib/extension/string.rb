class String
  def to_bool
    return self if self.class.kind_of?(TrueClass) || self.class.kind_of?(FalseClass)

    if self =~ /^(true|false)$/
      return true if $1 == 'true'
      return false if $1 == 'false'
    else
      raise NoMethodError.new("undefined method `to_bool' for '#{self}'")
    end
  end

  def include_google_ad(is_include: true, target: 'h3')
    return self if !is_include
    base = BaseWorker.new
    contents = self.split(/<#{target}.*?>/)
    result = contents.map.with_index do |content, index|
      next content if contents.length == index + 1
      if contents.length > 4 && index % 2 == 1
        next content + '<' + target + '>' 
      else
        next (content + base.google_ad + '<' + target + '>').html_safe
      end
    end.compact
    return result.join
  end

end
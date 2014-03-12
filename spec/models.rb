class Plus10
  def internalize(n)
    n+10
  end

  def externalize(n)
    n-10
  end
end

class Rot13
  def internalize(str)
    str.tr('A-Za-z', 'N-ZA-Mn-za-m')
  end

  def externalize(str)
    internalize(str)
  end
end

class Book < ActiveRecord::Base
  apply_converter :page, Plus10.new
  apply_converter :title, Rot13.new
end

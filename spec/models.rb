class Plus10
  def to_internal(n)
    n+10
  end

  def from_internal(n)
    n-10
  end
end

class Rot13
  def to_internal(str)
    str.tr('A-Za-z', 'N-ZA-Mn-za-m')
  end

  def from_internal(str)
    to_internal(str)
  end
end

class Book < ActiveRecord::Base
  apply_converter :page, Plus10.new
  apply_converter :title, Rot13.new
end

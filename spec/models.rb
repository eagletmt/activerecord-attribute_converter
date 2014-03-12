class Plus
  def initialize(x)
    @x = x
  end

  def internalize(n)
    n+@x
  end

  def externalize(n)
    n-@x
  end
end

module Rot13
  module_function

  def internalize(str)
    str.tr('A-Za-z', 'N-ZA-Mn-za-m')
  end

  def externalize(str)
    internalize(str)
  end
end

class Book < ActiveRecord::Base
  apply_converter :page, Plus.new(10)
  apply_converter :title, Rot13
end

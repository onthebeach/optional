class Some
  include Option

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def each &block
    block.call(value)
  end

  def none?(&block)
    block.nil? ? false : super
  end

  def value_or(default=nil)
    value
  end

  def some?(type=value.class)
    value.class == type
  end

  def & other
    other.and_option(self)
  end

  def == other
    other.is_a?(Some) && value == other.value
  end

  def | other
    self
  end

  def merge(other, &block)
    other.match do |m|
      m.some { |v| block.nil? ? Some[([value] + [v]).flatten] : Some[block.call(value, v)] }
      m.none { self }
    end
  end

  def to_s
    "Some[#{value.inspect}]"
  end

  def self.[](*values)
    if values.size == 1
      values.first.nil? ? None : new(values.first)
    else
      new(values)
    end
  end

end

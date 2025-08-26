class Player
  attr_reader :name, :shape

  def initialize(shape, name)
    @shape = shape
    @name = name
  end
end
class Recipe
  attr_reader :name, :description, :prep_time, :difficulty
  attr_accessor :done

  def initialize(attributes = { difficulty: false })
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @done = attributes [:done]
    @difficulty = attributes[:difficulty]
  end

  def done!
    @done = true
  end
end

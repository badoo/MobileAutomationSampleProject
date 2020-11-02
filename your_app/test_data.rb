module TestData
  class << self
    attr_accessor :gif_list

    def initialize
      self.gif_list = []
    end
  end
end
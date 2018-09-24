# frozen_string_literal: true

# Item class
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def update_parameters
    method = "update_#{name.downcase.tr(' ', '_').tr(',', '')}_parameters"
    if private_methods.include?(method.to_sym)
      send(method)
    else
      send('update_regular_parameters')
    end
  end

  private

  def update_regular_parameters
    self.sell_in -= 1
    if (quality > 0 && sell_in >= 0) || (sell_in < 0 && quality == 1)
      self.quality -= 1
    elsif quality > 0
      self.quality -= 2
    end
  end

  def update_aged_brie_parameters
    self.sell_in -= 1
    self.quality += 1 if quality < 50
  end

  def update_backstage_passes_to_a_tafkal80etc_concert_parameters
    self.quality += 1 if quality < 50
    self.quality += 1 if quality < 50 && sell_in < 11
    self.quality += 1 if quality < 50 && sell_in < 6
    self.sell_in -= 1
    self.quality = 0 if sell_in < 0
  end

  def update_sulfuras_hand_of_ragnaros_parameters
    true
  end
end

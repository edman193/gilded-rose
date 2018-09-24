# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose_item')

# Gilded Rose class
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.update_parameters
    end
  end
end

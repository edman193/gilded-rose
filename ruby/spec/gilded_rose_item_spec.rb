# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'spec_helper')

describe Item do
  it 'initializes all values' do
    item = Item.new('Aged Brie', 6, 30)

    expect(item.name).to eq('Aged Brie')
    expect(item.sell_in).to eq(6)
    expect(item.quality).to eq(30)
  end
end

# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'spec_helper')

describe GildedRose do
  let(:items) do
    {
      regular: Item.new('foo', 11, 30),
      aged_brie: Item.new('Aged Brie', 11, 30),
      backstage: Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 30),
      sulfuras: Item.new('Sulfuras, Hand of Ragnaros', 0, 80)
    }
  end

  describe '#update_quality' do
    it 'does not change the name' do
      GildedRose.new(items.values).update_quality
      expect(items[:regular].name).to eq 'foo'
    end

    it 'lowers "sell in" value for all items exept Sulfuras items' do
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:regular].sell_in }.by(-1)
        .and change { items[:aged_brie].sell_in }.by(-1)
        .and change { items[:backstage].sell_in }.by(-1)
        .and change { items[:sulfuras].sell_in }.by(0)
    end

    it 'lowers "quality" value for regular items' do
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:regular].quality }.by(-1)
    end

    it 'degrades "quality" of regular product twice as fast after "sell in" has passed' do
      items[:regular].sell_in = 0
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:regular].quality }.by(-2)
    end

    it 'never degrades "quality" of regular product under zero' do
      items[:regular].quality = 0
      GildedRose.new(items.values).update_quality
      expect(items[:regular].quality).to be_zero
    end

    it 'increases "quality" of "Aged Brie" and "backstage" items' do
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:aged_brie].quality }.by(1)
        .and change { items[:backstage].quality }.by(1)
    end

    it 'never increases "quality" of "Aged Brie" items over 50' do
      items[:aged_brie].quality = 50
      GildedRose.new(items.values).update_quality
      expect(items[:aged_brie].quality).to eq(50)
    end

    it 'never change "quality" of "sulfura" item' do
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:sulfuras].quality }.by(0)
    end

    it 'increases "quality" of "backstage" item by 2 when missing 10 days or less for sell' do
      items[:backstage].sell_in = 10
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:backstage].quality }.by(2)
    end

    it 'increases "quality" of "backstage" item by 3 when missing 5 days or less for sell' do
      items[:backstage].sell_in = 5
      expect { GildedRose.new(items.values).update_quality }
        .to change { items[:backstage].quality }.by(3)
    end

    it 'drop "quality" of "backstage" item to 0 after the concert day' do
      items[:backstage].sell_in = 0
      GildedRose.new(items.values).update_quality
      expect(items[:backstage].quality).to be_zero
    end
  end
end

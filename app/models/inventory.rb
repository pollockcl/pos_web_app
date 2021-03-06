class Inventory < ApplicationRecord
  has_many :inventory_cards
  has_many :cards, through: :inventory_cards
  belongs_to :user

  validates :name, presence: true

  def to_csv
    CSV.generate do |csv|
      attrs = %w[name price description stock]
      csv << attrs

      cards.each do |card|
        csv << [card.name,
                card.price,
                card.description,
                quantity(card)]
      end
    end
  end

  def to_param
    name
  end

  def add_card(card, quantity)
    return unless quantity && card
    cards << card unless cards.find_by(id: card.id)
    update_quantity(card, quantity)
    save
  end

  def total_items
    cards.map{ |card| quantity(card) }.sum
  end

  def quantity(card)
    cards = inventory_cards.find_by(card_id: card.id)
    cards ? cards.quantity : 0
  end

  def remove_card(card, quantity)
    card = Card.find_by(name: card)
    inventory_card = inventory_cards.find_by(card_id: card.id)
    inventory_card.quantity -= quantity.to_i
    inventory_card.save
    cards.destroy(card) if quantity(card) == 0 
    save
  end

  private

  def update_quantity(card, quantity)
    inventory_card = inventory_cards.find_by(card_id: card.id)
    inventory_card.quantity += quantity.to_i
    inventory_card.save
  end
end

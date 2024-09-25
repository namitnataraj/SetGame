#Author: Namit Nataraj
# Card class representing each card in the game
class Card
  attr_reader :color, :shape, :shading, :number

  def initialize(color, shape, shading, number)
    @color = color
    @shape = shape
    @shading = shading
    @number = number
  end

  def to_s
    "#{number} #{shading} #{color} #{shape}(s)"
  end
end

# Deck class to create and shuffle the deck of 81 cards
class Deck
  COLORS = ['red', 'green', 'purple']
  SHAPES = ['oval', 'diamond', 'squiggle']
  SHADINGS = ['solid', 'striped', 'outlined']
  NUMBERS = [1, 2, 3]

  def initialize
    @cards = []
    COLORS.product(SHAPES, SHADINGS, NUMBERS) do |color, shape, shading, number|
      @cards << Card.new(color, shape, shading, number)
    end
    @cards.shuffle!
  end

  def deal(num)
    @cards.pop(num)
  end

  def empty?
    @cards.empty?
  end
end

# Game class to manage the game logic
class SetGame
  def initialize
    @deck = Deck.new
    @cards_in_play = @deck.deal(12)
    @score = 0
  end

  # Main game loop
  def play
    while !@deck.empty? && !@cards_in_play.empty?
      display_cards
      puts "Select 3 cards by their indices (e.g., '1 5 9'):"
      indices = gets.chomp.split.map(&:to_i)

      selected_cards = indices.map { |i| @cards_in_play[i - 1] }

      if valid_set?(selected_cards)
        puts "You found a set!"
        @score += 1
        replace_cards(indices)
      else
        puts "Not a valid set. Try again!"
      end
    end
    puts "Game over! Your score: #{@score}"
  end

  private

  # Display the cards in play with indices
  def display_cards
    @cards_in_play.each_with_index do |card, index|
      puts "#{index + 1}: #{card}"
    end
  end

  # Replace the identified set with new cards
  def replace_cards(indices)
    indices.each do |i|
      @cards_in_play[i - 1] = @deck.deal(1).first
    end
  end

  # Check if three selected cards form a valid set
  def valid_set?(cards)
    attributes = [:color, :shape, :shading, :number]
    attributes.all? do |attr|
      values = cards.map { |card| card.send(attr) }
      values.uniq.length == 1 || values.uniq.length == 3
    end
  end
end

# Start the game
game = SetGame.new
game.play

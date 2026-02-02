require_relative 'lib/unit'
require_relative 'lib/army'
require_relative 'lib/battle'

puts "=== Simulation ==="
puts

# Create two armies
army1 = Army.new(Civilization::CHINESE)
army2 = Army.new(Civilization::ENGLISH)

puts "--- Initial State ---"
puts "Army ##{army1.id} (#{army1.civ.name}):"
puts "  Units: #{army1.units.size} (#{army1.units.count { |u| u.is_a?(Pikeman) }} pikemen, #{army1.units.count { |u| u.is_a?(Archer) }} archers, #{army1.units.count { |u| u.is_a?(Knight) }} knights)"
puts "  Total strength: #{army1.total_strength}"
puts "  Gold: #{army1.coins}"
puts
puts "Army ##{army2.id} (#{army2.civ.name}):"
puts "  Units: #{army2.units.size} (#{army2.units.count { |u| u.is_a?(Pikeman) }} pikemen, #{army2.units.count { |u| u.is_a?(Archer) }} archers, #{army2.units.count { |u| u.is_a?(Knight) }} knights)"
puts "  Total strength: #{army2.total_strength}"
puts "  Gold: #{army2.coins}"
puts

# Training
puts "--- Training a Pikeman ---"
pikemen = army1.units.select { |u| u.is_a?(Pikeman) }
pikeman_to_train = pikemen[0]
pikeman_to_transform = pikemen[1]
puts "Unit ##{pikeman_to_train.id}: strength=#{pikeman_to_train.strength}, army gold=#{army1.coins}"
puts "Training cost: #{pikeman_to_train.training_cost} gold, bonus: +#{pikeman_to_train.training_bonus} strength"
army1.train_unit(pikeman_to_train)  
puts "Unit ##{pikeman_to_train.id}: strength=#{pikeman_to_train.strength}, army gold=#{army1.coins}"
puts

# Transformation  
puts "--- Transforming Pikeman to Archer ---"
puts "Unit ##{pikeman_to_transform.id}: type=#{pikeman_to_transform.class}, army gold=#{army1.coins}"
puts "Transformation cost: #{pikeman_to_transform.transformation_cost} gold"
new_archer = army1.transform_unit(pikeman_to_transform)  
puts "Unit ##{new_archer.id}: type=#{new_archer.class} (strength=#{new_archer.strength}), army gold=#{army1.coins}"
puts

# Train the same pikeman using id
puts "--- Training the same Pikeman again (using ID) ---"
same_pikeman = army1.find_unit_by_id(pikeman_to_train.id)
puts "Found Unit ##{same_pikeman.id}: strength=#{same_pikeman.strength}"
army1.train_unit(same_pikeman)
puts "After training: strength=#{same_pikeman.strength}, army gold=#{army1.coins}"
puts

# Battle
puts "--- Battle: Army ##{army1.id} vs Army ##{army2.id} ---"
puts "Army ##{army1.id} strength: #{army1.total_strength}"
puts "Army ##{army2.id} strength: #{army2.total_strength}"
puts

puts "Before battle:"
puts "  Army ##{army1.id}: #{army1.units.size} units, #{army1.coins} gold"
puts "  Army ##{army2.id}: #{army2.units.size} units, #{army2.coins} gold"

battle = Battle.new(army1, army2)
battle.fight

puts
if battle.tie?
    puts "It's a tie! Both armies lost 1 unit."
else
    puts "Battle winner: Army ##{battle.winner.id}"
end

puts
puts "After battle:"
puts "  Army ##{army1.id}: #{army1.units.size} units, #{army1.coins} gold"
puts "  Army ##{army2.id}: #{army2.units.size} units, #{army2.coins} gold"
puts
puts "Battle history (army IDs):"
puts "  Army ##{army1.id} fought against: #{army1.history.join(', ')}"
puts "  Army ##{army2.id} fought against: #{army2.history.join(', ')}"
puts

# Error handling demonstrations
puts "--- Error Handling Demos ---"

# Can`t transform a Knight
knight = army2.units.find { |u| u.is_a?(Knight) }
begin
    army2.transform_unit(knight)
rescue InvalidTransformationError => e
    puts "Caught: #{e.message}"
end

# Can`t train unit from other army
begin
    army1.train_unit(army2.units.first)
rescue UnitNotFoundError => e
    puts "Caught: #{e.message}"
end

# Can`t train without enough gold
poor_army = Army.new(Civilization::BYZANTINE)
poor_army.instance_variable_set(:@coins, 5)
unit_to_train = poor_army.units.first
begin
    poor_army.train_unit(unit_to_train)
rescue InsufficientGoldError => e
    puts "Caught: #{e.message}"
end

puts
puts "=== Simulation Complete ==="

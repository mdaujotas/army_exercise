require_relative 'civilization'

class ArmyError < StandardError; end
class InsufficientGoldError < ArmyError; end
class UnitNotFoundError < ArmyError; end
class InvalidTransformationError < ArmyError; end

class Army
    @@next_id = 1
    attr_reader :id, :civ, :units, :coins, :history

    def initialize(civ)
        @id = @@next_id
        @@next_id += 1
        @civ = civ
        @coins = 1000
        @units = []
        @history = []

        civ.initial_pikemen.times { @units << Pikeman.new }
        civ.initial_archers.times { @units << Archer.new }
        civ.initial_knights.times { @units << Knight.new }
    end

    def train_unit(unit)
        raise UnitNotFoundError, "Unit does not belong to this army" unless @units.include?(unit)
        
        cost = unit.training_cost
        raise InsufficientGoldError, "Not enough gold (need #{cost}, have #{@coins})" if @coins < cost
        
        unit.train
        @coins -= cost
        unit
    end

    def transform_unit(unit)
        raise UnitNotFoundError, "Unit does not belong to this army" unless @units.include?(unit)
        raise InvalidTransformationError, "#{unit.class} cannot be transformed" if unit.transformation_cost.nil?
        
        cost = unit.transformation_cost
        raise InsufficientGoldError, "Not enough gold (need #{cost}, have #{@coins})" if @coins < cost
        
        new_unit = unit.transform
        @units.delete(unit)
        @units << new_unit
        @coins -= cost
        new_unit
    end

    def total_strength
        @units.sum(&:strength)
    end

    def add_gold(amount)
        @coins += amount
    end

    def remove_strongest(count)
        @units.sort_by! { |unit| -unit.strength }
        @units.shift(count)
    end

    def record_battle(opponent)
        @history << opponent.id
    end

    def find_unit_by_id(unit_id)
        @units.find { |u| u.id == unit_id } || raise(UnitNotFoundError, "Unit ##{unit_id} not found in army")
    end

    def attack(enemy)
        my_points = total_strength
        enemy_points = enemy.total_strength

        if my_points > enemy_points
            add_gold(100)
            enemy.remove_strongest(2)
        elsif enemy_points > my_points
            enemy.add_gold(100)
            remove_strongest(2)
        else
            remove_strongest(1)
            enemy.remove_strongest(1)
        end

        # Record history
        record_battle(enemy)
        enemy.record_battle(self)
    end
    
end


class Unit
    @@next_id = 1
    attr_reader :id, :strength, :created_at

    def initialize
        @id = @@next_id
        @@next_id += 1
        @created_at = Time.now
    end

    def train
        @strength += training_bonus
    end 

    def years_alive
        ((Time.now - @life) / (60 * 60 * 24 * 365)).to_i
    end
end

class Pikeman < Unit
    def initialize
        super
        @strength = 5
    end

    def transform
        Archer.new
    end

    def training_bonus = 3
    def training_cost = 10
    def transformation_cost = 30
end

class Archer < Unit
    def initialize
        super
        @strength = 10
    end

    def transform
        Knight.new
    end

    def training_bonus = 7
    def training_cost = 20
    def transformation_cost = 40
end

class Knight < Unit
    def initialize
        super
        @strength = 20
    end

    def transform
        nil
    end 

    def training_bonus = 10
    def training_cost = 30
    def transformation_cost = nil
end

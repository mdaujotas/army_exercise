class Battle
    attr_reader :army1, :army2, :winner, :loser

    def initialize(army1, army2)
        @army1 = army1
        @army2 = army2
        @winner = nil
        @loser = nil
    end

    def fight
        strength1 = @army1.total_strength
        strength2 = @army2.total_strength

        if strength1 > strength2
            apply_results(@army1, @army2)
        elsif strength2 > strength1
            apply_results(@army2, @army1)
        else
            @army1.remove_strongest(1)
            @army2.remove_strongest(1)
        end

        @army1.record_battle(@army2)
        @army2.record_battle(@army1)

        self
    end

    def tie?
        @winner.nil?
    end

    private

    def apply_results(winner, loser)
        @winner = winner
        @loser = loser
        winner.add_gold(100)
        loser.remove_strongest(2)
    end
end

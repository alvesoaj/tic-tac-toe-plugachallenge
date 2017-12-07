class Board
    MARK_RANGE = (0..1)
    CRS_MARK = "✘"
    DOT_MARK = "⏺"

    SPACES_RANGE = (0..8)

    attr_accessor :spaces

    def initialize
        self.spaces = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    end

    def get(index)
        return self.spaces[index]
    end

    def set(index, value)
        self.spaces[index] = value
    end

    def available_spaces
        return self.spaces.reject { |s| s == CRS_MARK || s == DOT_MARK }
    end

    def self.inverse_marker(marker)
        return marker == DOT_MARK ? CRS_MARK : DOT_MARK
    end

    def is_checked?(index)
        return self.spaces[index] == CRS_MARK || self.spaces[index] == DOT_MARK
    end

    def game_is_over?
        return [self.spaces[0], self.spaces[1], self.spaces[2]].uniq.length == 1 ||
            [self.spaces[3], self.spaces[4], self.spaces[5]].uniq.length == 1 ||
            [self.spaces[6], self.spaces[7], self.spaces[8]].uniq.length == 1 ||
            [self.spaces[0], self.spaces[3], self.spaces[6]].uniq.length == 1 ||
            [self.spaces[1], self.spaces[4], self.spaces[7]].uniq.length == 1 ||
            [self.spaces[2], self.spaces[5], self.spaces[8]].uniq.length == 1 ||
            [self.spaces[0], self.spaces[4], self.spaces[8]].uniq.length == 1 ||
            [self.spaces[2], self.spaces[4], self.spaces[6]].uniq.length == 1
    end

    def game_is_tie?
        return self.spaces.all? { |s| s == CRS_MARK || s == DOT_MARK }
    end
end
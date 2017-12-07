require "./models/actor.rb"
require "./utils/window.rb"

class Human < Actor
    @@id = 0

    def initialize(marker)
        @@id += 1
        self.marker = marker
        self.name = "Human ##{@@id}"
        @type = :human
    end

    def get_spot(board)
        spot = nil
        until spot
            spot = Window::ClassMethods.get_valid_input(Board::SPACES_RANGE)
            if !board.is_checked?(spot)
                @last_spot = spot
                board.set(@last_spot, self.marker)
            else
                spot = nil
            end
        end
    end
end
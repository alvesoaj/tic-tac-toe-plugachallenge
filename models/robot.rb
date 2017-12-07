require "./models/actor.rb"

class Robot < Actor
    LEVEL_RANGE = (0..2)
    GAME_LEVEL_HARD   = 0
    GAME_LEVEL_NORMAL = 1
    GAME_LEVEL_EASY   = 2

    attr_accessor :level

    @@id = 0

    def initialize(marker, level)
        @@id += 1
        self.marker = marker
        self.name = "Robot ##{@@id}"
        @type = :robot
        self.level = level
    end

    def get_spot(board)
        # if certain level, choice the best spot
        if board.get(4) == "4" && self.level != GAME_LEVEL_EASY
            @last_spot = 4
            board.set(@last_spot, self.marker)
        else
            # else, test a move
            get_best_move(board)
        end
    end

    private
        def get_best_move(board)
            has_a_best_movie = false

            # if game leves was set to hard
            if self.level == GAME_LEVEL_HARD
                has_a_best_movie = try_spot_to_win?(board)
                if !has_a_best_movie
                    has_a_best_movie = try_a_spot_to_not_lose?(board)
                end
            elsif self.level == GAME_LEVEL_NORMAL    
                # if game leves was set to normal
                has_a_best_movie = try_a_spot_to_win_and_not_lose?(board)
            else
                # if game leves was set to easy
                if rand() > 0.333
                    has_a_best_movie = try_a_spot_to_not_lose?(board)
                end

                if !has_a_best_movie && rand() > 0.666
                    has_a_best_movie = try_spot_to_win?(board)
                end
            end

            if !has_a_best_movie
                @last_spot = board.available_spaces.sample.to_i
                board.set(@last_spot, self.marker)
            end
        end

        def try_spot_to_win?(board)
            # test a spot to win the game
            board.available_spaces.each do |as|
                board.set(as.to_i, self.marker)
                if board.game_is_over?
                    @last_spot = as.to_i
                    return true
                end
                # reset the board
                board.set(as.to_i, as)
            end
            return false
        end

        def try_a_spot_to_not_lose?(board)
            # test a spot to avoid a lose
            board.available_spaces.each do |as|
                board.set(as.to_i, Board.inverse_marker(self.marker))
                if board.game_is_over?
                    # if found, choice the same position
                    board.set(as.to_i, self.marker)
                    @last_spot = as.to_i
                    return true
                end
                # reset the board
                board.set(as.to_i, as)
            end
            return false
        end

        def try_a_spot_to_win_and_not_lose?(board)
            board.available_spaces.each do |as|
                # test first a spot to win the game
                board.set(as.to_i, self.marker)
                if board.game_is_over?
                    @last_spot = as.to_i
                    return true
                else
                    # test now a spot to avoid a lose
                    board.set(as.to_i, Board.inverse_marker(self.marker))
                    if board.game_is_over?
                        # if found, choice the same position
                        board.set(as.to_i, self.marker)
                        @last_spot = as.to_i
                        return true
                    end
                end
                # reset the board
                board.set(as.to_i, as)
            end
            return false
        end
end
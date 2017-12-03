require "./utils/window.rb"
require "./models/human.rb"
require "./models/robot.rb"

class Game
    # Including Window to use its methods as instance
    include Window

    def initialize
        @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
        @com = "✘" # the computer's marker
        @hum = "⏺" # the user's marker
        @mode = nil
        @players = []
    end

    def start_game
        # print a presentation screen
        print_start_screen
        # ask game mode to set playes
        get_game_mode_and_set_players
        # start by printing the board
        print_game_screen
        # loop through until the game was won or tied
        until game_is_over(@board) || tie(@board)
            get_human_spot
            if !game_is_over(@board) && !tie(@board)
                get_robot_spot
            end
        end
        puts "Game over"
    end

    def get_game_mode_and_set_players
        # print mod selection screen
        print_mode_selector
        until @mode
            @mode = gets.chomp.to_i
            if @mode < 0 && @mode > 2
                @mode = nil
            end
        end

        if @mode == 0
            @playes = [Human.new, Robot.new]
        elsif @mode == 1
            @playes = [Human.new, Human.new]
        else
            @playes = [Robot.new(), Robot.new]
        end     
    end

    def get_human_spot
        print_human_turn
        spot = nil
        until spot
            spot = gets.chomp.to_i
            if spot >= 0 && spot <= 8 && @board[spot] != "✘" && @board[spot] != "⏺"
                @board[spot] = @hum
            elsif spot == 9
                abort
            else
                spot = nil
            end
        end
        print_game_screen
        sleep(1.5)
    end

    def get_robot_spot
        print_robot_turn
        sleep(2)
        spot = nil
        until spot
            if @board[4] == "4"
                spot = 4
                @board[spot] = @com
            else
                spot = get_best_move(@board, @com)
                if @board[spot] != "✘" && @board[spot] != "⏺"
                    @board[spot] = @com
                else
                    spot = nil
                end
            end
        end
        print "My choice id #{spot}"
        sleep(1.5)
        print_game_screen
        sleep(1.5)
    end

    def get_best_move(board, next_player, depth = 0, best_score = {})
        available_spaces = []
        best_move = nil
        board.each do |s|
            if s != "✘" && s != "⏺"
                available_spaces << s
            end
        end
        available_spaces.each do |as|
            board[as.to_i] = @com
            if game_is_over(board)
                best_move = as.to_i
                board[as.to_i] = as
                return best_move
            else
                board[as.to_i] = @hum
                if game_is_over(board)
                    best_move = as.to_i
                    board[as.to_i] = as
                    return best_move
                else
                    board[as.to_i] = as
                end
            end
        end
        if best_move
            return best_move
        else
            n = rand(0..available_spaces.count)
            return available_spaces[n].to_i
        end
    end

    def game_is_over(b)
        [b[0], b[1], b[2]].uniq.length == 1 ||
        [b[3], b[4], b[5]].uniq.length == 1 ||
        [b[6], b[7], b[8]].uniq.length == 1 ||
        [b[0], b[3], b[6]].uniq.length == 1 ||
        [b[1], b[4], b[7]].uniq.length == 1 ||
        [b[2], b[5], b[8]].uniq.length == 1 ||
        [b[0], b[4], b[8]].uniq.length == 1 ||
        [b[2], b[4], b[6]].uniq.length == 1
    end

    def tie(b)
        b.all? { |s| s == "✘" || s == "⏺" }
    end
end

game = Game.new
game.start_game
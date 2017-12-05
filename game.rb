require "./utils/window.rb"
require "./models/human.rb"
require "./models/robot.rb"

class Game
    # Including Window to use its methods as instance
    include Window

    CRS_MARK = "✘"
    DOT_MARK = "⏺"

    GAME_MODE_MAN_X_MAN = 0
    GAME_MODE_MAN_X_BOT = 1
    GAME_MODE_BOT_X_BOT = 2

    GAME_LEVEL_HARD   = 0
    GAME_LEVEL_NORMAL = 1
    GAME_LEVEL_EASY   = 2

    def initialize
        @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
        @mode = nil
        @level = nil
        @index = 0
        @players = []
    end

    def start_game
        # print a presentation screen
        # print_start_screen
        
        # ask game mode to set playes
        get_game_mode_and_set_players

        # if a human in game, set level, set markers, raffle
        if @mode == GAME_MODE_MAN_X_MAN || @mode == GAME_MODE_MAN_X_BOT
            set_game_level
            set_players_marker
            hold_a_draw
        end
        
        # start by printing the board
        print_game_screen
        
        # loop through until the game was won or tied
        until game_is_over(@board) || tie(@board)
            # getting player in this turn
            player = @players[@index]

            # changind player index
            change_index

            if player.type == :human
                message = "It's your\nturn!"
                # if mode MAN against MAN
                if @mode == GAME_MODE_MAN_X_MAN
                    message = "#{player.name}\nIt is\nyour turn!\n"
                end
                get_human_spot(player.marker, message)
            else
                if !game_is_over(@board) && !tie(@board)
                    get_robot_spot(player.marker, "#{player.name} says:\nIt is\nmy turn!\n")
                end
            end
        end

        if !tie(@board)
            change_index
            # print a winner message
            puts("#{@players[@index].name} WON!")
        else
            puts("DRAW!")
        end

        # print game over
        puts("Game over")
    end

    def get_game_mode_and_set_players
        # print mod selection screen
        print_mode_selector

        # read mode from input
        @mode = get_valid_input((GAME_MODE_MAN_X_MAN..GAME_MODE_BOT_X_BOT))

        # if MAN agains MAN
        if @mode == GAME_MODE_MAN_X_MAN
            @players = [Human.new, Human.new]
        elsif @mode == GAME_MODE_MAN_X_BOT
            # if MAN agains ROBOT
            @players = [Human.new, Robot.new]
        else
            # if ROBOT agains ROBOT
            @players = [Robot.new(CRS_MARK), Robot.new(DOT_MARK)]
        end
    end

    def set_game_level
        # print presentation screen
        print_level_selector

        # read a option from input
        @level = get_valid_input((GAME_LEVEL_HARD..GAME_LEVEL_EASY))
    end

    def set_players_marker
        # print presentation screen
        print_marker_selector

        # read a option from input
        option = get_valid_input((0..1))

        # if CRS select
        if option == 0
            @players[0].marker = DOT_MARK
            @players[1].marker = CRS_MARK
        else
            # if DOT selected
            @players[0].marker = CRS_MARK
            @players[1].marker = DOT_MARK
        end
    end

    def hold_a_draw
        # print presentation screen
        print_raffle_selector

        # read a option from input
        option = get_valid_input((0..1))

        sleep(1.5)

        # rand a value to test
        v = rand() > 0.5 ? :h : :t

        # test if selection is in scope
        if (option == 0 && v == :h) || (option == 1 && v == :t)
            @index = 0
            puts("Great!\nYou start!")
        else
            @index = 1
            puts("=(\nU play after!")
        end

        sleep(1.5)
    end

    def change_index
        @index = @index == 0 ? 1 : 0
    end

    def get_human_spot(marker, message=nil)
        print_human_turn(message)
        spot = nil
        until spot
            spot = get_valid_input((0..9))
            if spot == 9
                puts("See you\nCoward!")
                abort
            elsif @board[spot] != CRS_MARK && @board[spot] != DOT_MARK
                @board[spot] = marker
            else
                spot = nil
            end
        end
        print_game_screen
        sleep(1.5)
    end

    def get_robot_spot(marker, message=nil)
        print_robot_turn(message)
        sleep(2)
        spot = nil
        until spot
            if @board[4] == "4" && @level != GAME_LEVEL_EASY
                spot = 4
                @board[spot] = marker
            else
                spot = get_best_move(@board, marker)
                if @board[spot] != CRS_MARK && @board[spot] != DOT_MARK
                    @board[spot] = marker
                else
                    spot = nil
                end
            end
        end
        print "My choice is #{spot}"
        sleep(1.5)
        print_game_screen
        sleep(1.5)
    end

    def get_best_move(board, marker, depth=0, best_score={})
        available_spaces = []
        best_move = nil
        board.each do |s|
            if s != CRS_MARK && s != DOT_MARK
                available_spaces << s
            end
        end

        # if game leves was set to hard
        if @level == GAME_LEVEL_HARD
            available_spaces.each do |as|
                board[as.to_i] = marker
                if game_is_over(board)
                    best_move = as.to_i
                    board[as.to_i] = as
                    return best_move
                end
                board[as.to_i] = as
            end
            
            available_spaces.each do |as|
                board[as.to_i] = (marker == DOT_MARK ? CRS_MARK : DOT_MARK)
                if game_is_over(board)
                    best_move = as.to_i
                    board[as.to_i] = as
                    return best_move
                end
                board[as.to_i] = as
            end
        elsif @level == GAME_LEVEL_NORMAL    
            # if game leves was set to normal
            available_spaces.each do |as|
                board[as.to_i] = marker
                if game_is_over(board)
                    best_move = as.to_i
                    board[as.to_i] = as
                    return best_move
                else
                    board[as.to_i] = (marker == DOT_MARK ? CRS_MARK : DOT_MARK)
                    if game_is_over(board)
                        best_move = as.to_i
                        board[as.to_i] = as
                        return best_move
                    else
                        board[as.to_i] = as
                    end
                end
            end
        else
            # if game leves was set to easy
            if rand() > 0.333
                available_spaces.each do |as|
                    board[as.to_i] = (marker == DOT_MARK ? CRS_MARK : DOT_MARK)
                    if game_is_over(board)
                        best_move = as.to_i
                        board[as.to_i] = as
                        return best_move
                    end
                    board[as.to_i] = as
                end
            end

            if rand() > 0.666
                available_spaces.each do |as|
                    board[as.to_i] = marker
                    if game_is_over(board)
                        best_move = as.to_i
                        board[as.to_i] = as
                        return best_move
                    end
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
        b.all? { |s| s == CRS_MARK || s == DOT_MARK }
    end

    def get_valid_input(range)
        option = nil
        until option
            option = gets.chomp
            if option != '' && range.include?(option.to_i)
                return option.to_i
            else
                puts("Try again!")
                option = nil
            end
        end
    end
end

game = Game.new
game.start_game
require "./utils/window.rb"
require "./utils/board.rb"
require "./models/human.rb"
require "./models/robot.rb"

class Game
    # Including Window to use its methods as instance
    include Window

    attr_accessor :board, :mode, :level, :index, :players

    MODE_RANGE = (0..2)
    GAME_MODE_MAN_X_MAN = 0
    GAME_MODE_MAN_X_BOT = 1
    GAME_MODE_BOT_X_BOT = 2

    def initialize
        self.board = Board.new
        self.index = 0
        self.players = []
    end

    def start_game
        # print a presentation screen
        self.print_start_screen()
        
        # ask game mode to set playes
        get_game_mode_and_set_players()

        # set level, set markers, raffle
        set_game_level()

        # set markers
        set_players_marker()

        if self.mode != GAME_MODE_BOT_X_BOT
            # raffle
            hold_a_draw()
        end
        
        # start by printing the board
        self.print_game_screen()
        
        # loop through until the game was won or tied
        until self.board.game_is_over? || self.board.game_is_tie?
            # getting player in this turn
            player = self.players[self.index]

            # changind player index
            switch_player()

            if player.type == :human
                message = "It's your\nturn!"
                # if mode MAN against MAN
                if self.mode == GAME_MODE_MAN_X_MAN
                    message = "#{player.name}\nIt is\nyour turn!\n"
                end
                get_human_spot(player, message)
            else
                if !self.board.game_is_over? && !self.board.game_is_tie?
                    get_robot_spot(player, "#{player.name} says:\nIt is\nmy turn!\n")
                end
            end
        end

        if !self.board.game_is_tie?
            switch_player()
            # print a winner message
            puts("#{self.players[@index].name} WON!")
        else
            puts("DRAW!")
        end

        # print game over
        puts("Game over")
    end

    private
        def get_game_mode_and_set_players
            # print mod selection screen
            self.print_mode_selector()

            # read mode from input
            self.mode = Window::ClassMethods.get_valid_input(MODE_RANGE)
        end

        def set_game_level
            # print presentation screen
            self.print_level_selector()

            # read a option from input
            self.level = Window::ClassMethods.get_valid_input(Robot::LEVEL_RANGE)
        end

        def set_players_marker
            # print presentation screen
            self.print_marker_selector()

            # read a option from input
            option = Window::ClassMethods.get_valid_input(Board::MARK_RANGE)

            # if MAN agains MAN
            if self.mode == GAME_MODE_MAN_X_MAN
                if option == 0
                    self.players = [Human.new(Board::CRS_MARK), Human.new(Board::DOT_MARK)]
                else
                    # if DOT selected
                    self.players = [Human.new(Board::DOT_MARK), Human.new(Board::CRS_MARK)]
                end
            elsif self.mode == GAME_MODE_MAN_X_BOT
                # if MAN agains ROBOT
                if option == 0
                    self.players = [Human.new(Board::CRS_MARK), Robot.new(Board::DOT_MARK, self.level)]
                else
                    # if DOT selected
                    self.players = [Human.new(Board::DOT_MARK), Robot.new(Board::CRS_MARK, self.level)]
                end
            else
                # if ROBOT agains ROBOT
                self.players = [Robot.new(Board::CRS_MARK, self.level), Robot.new(Board::DOT_MARK, self.level)]
            end
        end

        def hold_a_draw
            # print presentation screen
            self.print_raffle_selector()

            # read a option from input
            option = Window::ClassMethods.get_valid_input((0..1))

            sleep(1)

            # rand a value to test
            v = rand() >= 0.5 ? :h : :t

            # test if selection is in scope
            if (option == 0 && v == :h) || (option == 1 && v == :t)
                @index = 0
                puts("=( You start!")
            else
                @index = 1
                puts("=) U play after!")
            end

            sleep(1.5)
        end

        def switch_player
            @index = @index == 0 ? 1 : 0
        end

        def get_human_spot(player, message)
            # print a start presentation
            self.print_human_turn(message)

            # gat player spot
            player.get_spot(self.board)

            # print a finish presentation
            print "You chose #{player.last_spot}"
            self.print_game_screen()
            sleep(1.5)
        end

        def get_robot_spot(player, message)
            # print a start presentation
            self.print_robot_turn(message)
            
            # randon robot action delay
            sleep( rand() + rand() )
            
            # gat player spot
            player.get_spot(self.board)

            # print a finish presentation
            print "My choice is #{player.last_spot}"
            sleep(1.5)
            self.print_game_screen()
            sleep(1.5)
        end
end

game = Game.new
game.start_game()
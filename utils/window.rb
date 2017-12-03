module Window
    module ClassMethods
    end
    
    module InstanceMethods
        def print_cls
            # Just clear the console screen
            puts("\e[H\e[2J")
        end

        def print_start_screen
            # clear console screen
            print_cls
            
            # print a timed presentation
            print("          \n")
            print("   T")
            sleep(0.1)
            print("I")
            sleep(0.1)
            print("C    \n")
            sleep(0.1)
            print("    T")
            sleep(0.1)
            print("A")
            sleep(0.1)
            print("C   \n")
            sleep(0.1)
            print("     T")
            sleep(0.1)
            print("O")
            sleep(0.1)
            print("E  \n")
            sleep(0.1)
            print("          \n")
            sleep(0.5)
            print("  Wellcome! ")
            sleep(2.0)
        end

        def print_mode_selector
            # clear console screen
            print_cls

            # print the mode selection screen
            puts("   MODE   \n          \nmanXman[0]\nmanXcom[1]\ncomXcom[2]\nChoice [0-2]: ")
        end

        def print_level_selector
            # clear console screen
            print_cls

            # print the level selection screen
            puts("  LEVEL   \n          \n  HARD[0] \nNORMAL[1] \n  EASY[2] \nChoice [0-2]: ")
        end

        def print_marker_selector
            # clear console screen
            print_cls
            
            # print the marker selection screen
            puts("  MARKER  \n          \n✘ - CRS[0]\n⏺ - DOT[1]\n          \nChoice [0-1]: ")
        end

        def print_raffle_selector
            # clear console screen
            print_cls
            
            # print the raffle selection screen
            puts("  RAFFLE  \n          \n HEADS[0] \n TAILS[1] \n          \nChoice [0-1]: ")
        end

        def print_game_screen
            # clear console screen
            print_cls

            # print an updated game board
            puts(" #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \nEnter [0-8] \n[9] Exit:")
        end

        def print_human_turn(message="Your Turn!")
            # clear console screen
            print_cls

            # print a human figure
            puts("          \n    [\"]   \n   /[_]\\  \n    ] [   \n          \n#{message}")
            
            # wait a bit
            sleep(3)
            
            # print a updated board
            print_game_screen
        end

        def print_robot_turn(message="My Turn!")
            # clear console screen
            print_cls
            
            # print a robot figure
            puts("     ¤    \n    /     \n * [\"]  ,<\n |/[#]\\/  \n   OOO    \n#{message}")
            
            # wait a bit
            sleep(3)
            
            # print a updated board
            print_game_screen
        end
    end
    
    def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
    end
end
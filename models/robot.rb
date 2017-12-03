require "./models/actor.rb"

class Robot < Actor
    @@id = 0

    def initialize(marker=nil)
        @@id += 1
        @marker = marker
        @name = "Robot ##{@@id}"
        @type = :robot
    end
end
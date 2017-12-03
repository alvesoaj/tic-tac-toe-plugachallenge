require "./models/actor.rb"

class Human < Actor
    @@id = 0

    def initialize
        @@id += 1
        @name = "Human ##{@@id}"
        @type = :human
    end
end
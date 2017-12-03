require "test/unit"
require "./models/actor.rb"
require "./models/robot.rb"
require "./models/human.rb"

class ModelsTest < Test::Unit::TestCase
    def setup
    end

    def teardown
    end

    def test_actor_attributes
        actor = Actor.new

        actor.marker = "#"
        actor.name = "Test"

        assert_raise do
            actor.type = :test
        end

        assert_not_nil(actor.marker)
        assert_not_nil(actor.name)
        assert_nil(actor.type)
    end

    def test_human_instance
        human_01 = Human.new
        human_02 = Human.new

        assert_not_nil(human_01.name)
        assert_not_nil(human_01.type)

        assert_not_equal(human_01.name, human_02.name)

        assert_nil(human_01.marker)
    end

    def test_robot_instance
        robot_01 = Robot.new
        robot_02 = Robot.new

        assert_not_nil(robot_01.name)
        assert_not_nil(robot_01.type)

        assert_not_equal(robot_01.name, robot_02.name)

        assert_nil(robot_01.marker)
    end
end
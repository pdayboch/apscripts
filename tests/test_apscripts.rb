require "./lib/apscripts.rb"
require "test/unit"

class Testapscripts < Test::Unit::TestCase

	def test_sample
		assert_equal(4, 2+2)
	end
end

Esterakt = require '../src/Esterakt'
{ClassType, Float32, List} = Esterakt

describe 'Esterakt', ->

	describe "general", ->

		PointType = new ClassType class Point

			$x: Float32
			$y: Float32
			$z: Float32

			put: (x, y, z) ->

				@x = +x
				@y = +y
				@z = +z

				this

		points = new List(PointType, 20)

		points.length.should.equal 20

		p = points.get 10

		p.x.should.equal 0

		p.put 10, 20, 30

		p.x.should.equal 10
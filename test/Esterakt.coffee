Esterakt = require '../src/Esterakt'
{ClassType, Float32Type, List} = Esterakt
ClassType = require '../src/ClassType'

describe 'Esterakt', ->

	describe "general", ->

		it "should work", ->

			PointType = new ClassType class Point

				$x: Float32Type
				$y: Float32Type
				$z: Float32Type

				put: (x, y, z) ->

					@x = +x
					@y = +y
					@z = +z

					this

			points = new List(PointType, 2)

			points.getLength().should.equal 2

			p = points.get 1

			p.x.should.equal 0
			p.x = 10
			p.x.should.equal 10

			points.get(1).x.should.equal 10

			points.take p

			points.get(0).should.equal p
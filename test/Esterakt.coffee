Esterakt = require '../src/Esterakt'
{List, types} = Esterakt

describe 'Esterakt', ->

	describe "general", ->

		it "should work", ->

			class Point

				$x: types.Float32
				$y: types.Float32
				$z: types.Float64

				constructor: (_, __, @theThing) ->

				put: (x, y, z) ->

					@x = +x
					@y = +y
					@z = +z

					this

			points = List.of Point, 2, (cls, arg1, arg2) ->

				new cls arg1, arg2, 'something'

			points.getLength().should.equal 2

			p = points.get 1

			p.x.should.equal 0
			p.x = 10
			p.x.should.equal 10

			p.theThing.should.equal 'something'

			points.get(1).x.should.equal 10

			points.take p

			points.get(0).should.equal p

			p.z = 10
			p.z.should.equal 10
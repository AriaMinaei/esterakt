List = require '../src/List'
types = require '../src/types'

describe "List", ->

	describe "constructor", ->

		it "should accept a class"

	describe "general", ->

		it "should work", ->

			class Point

				$rotationZ: types.Float32

				$x: types.Float64
				$y: types.Float64

				$id: types.Uint16

				$opacity: types.Uint8

				$active: types.Boolean
				$active2: types.Boolean
				$active3: types.Boolean

			l = List.of Point, 2

			props = l._propsByBytesPerElement

			props['1'].should.have.key 'opacity'

			props['2'].should.have.key 'id'

			props['4'].should.have.key 'rotationZ'

			props['8'].should.have.keys ['x', 'y']

			l._stride.should.equal 32

			first = l.get 0
			second = l.get 1

			# console.log Object.getOwnPropertyDescriptor(first.constructor.prototype, 'x').get.toString()

			first.x.should.equal 0
			first.y.should.equal 0
			first.rotationZ.should.equal 0
			first.id.should.equal 0
			first.opacity.should.equal 0

			first.x = 10
			second.x = 15

			first.x.should.equal 10
			second.x.should.equal 15

			buf = l._listBuffer.arrayBuffer

			f = new Float64Array buf

			# Array::slice.call(f).should.be.like [10, 0, 0, 15, 0, 0, 0]

			first.active.should.equal no
			first.active2.should.equal no
			first.active3.should.equal no

			first.active = yes

			first.active.should.equal yes
			first.active2.should.equal no
			first.active3.should.equal no

			first.active2 = yes

			first.active.should.equal yes
			first.active2.should.equal yes
			first.active3.should.equal no

			first.active2 = no

			first.active.should.equal yes
			first.active2.should.equal no
			first.active3.should.equal no
module.exports = class List

	constructor: (type, length) ->

		@_stride = 0

		@_props = type._getProps()

		do @_calculateStride

		@_length = 0

		@_setLength length

		do @_createClass

	_calculateStride: ->

		stride = 0

		for name, prop of @_props

			stride += prop.byteLength

		@_stride = makeNumberMultipleOf stride, 4

	_setLength: (length) ->

		@_byteLength = length * @_stride

		@_length = length

		@_buffer = new ArrayBuffer @_byteLength
		@_float32Array = new Float32Array @_buffer

	Object.defineProperty @::, "length",

		get: -> @_length

	_createClass: ->

		class ListClass

			constructor: (@_esteraktList, @_esteraktIndex) ->

		curOffset = 0

		for name, prop of @_props

			if prop.typedArray is 'Float32Array'

				stride = @_stride / 4
				offset = curOffset / 4

				curOffset += 4

				typedArrayProp = "_float32Array"

			accessor = "this._esteraktList.#{typedArrayProp}[#{stride} * this._esteraktIndex + #{offset}]"

			evalString =

			eval "function getter(){ return #{accessor}; }"

			eval "function setter(v){ #{accessor} = v; }"


			Object.defineProperty ListClass::, name, get: getter, set: setter

		@_class = ListClass

		return

	get: (i) ->

		new @_class this, i

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k
object = require 'utila/scripts/js/lib/object'

module.exports = class Container

	constructor: ->

		@_floats = {}

		@_bytes = {}

		@_unsignedBytes = {}

		@_shorts = {}

		@_unsignedShorts = {}

		@_normalized = {}

		@_defaults = {}

		@_prepared = no

		@_elements = []

		@_stride = 0

		@_hasElements = no

	_add: (place, name, size, defaults = null, normalized = no) ->

		@_hasElements = yes

		@[place][name] = parseInt size

		@_normalized[name] = Boolean normalized

		if Array.isArray defaults

			if defaults.length isnt size

				throw Error "Length of the `defaults` doesn't match elemen't size"

			@_defaults[name] = defaults

		@

	float: (name, size, defaults) ->

		@_add '_floats', name, size, defaults

	byte: (name, size, defaults, normalized) ->

		@_add '_bytes', name, size, defaults, normalized

	unsignedByte: (name, size, defaults, normalized) ->

		@_add '_unsignedBytes', name, size, defaults, normalized

	short: (name, size, defaults, normalized) ->

		@_add '_shorts', name, size, defaults, normalized

	unsignedShort: (name, size, defaults, normalized) ->

		@_add '_unsignedShorts', name, size, defaults, normalized

	_addEl: (glType, jsType, name, size, len, normalized, offset) ->

		@_elements.push

			glType: glType

			jsType: jsType

			name: name

			size: size

			len: len

			normalized: normalized

			offset: offset

		return

	_prepare: ->

		return if @_prepared

		@_prepared = yes

		offset = 0

		# Floats

		for name, size of @_floats

			@_addEl FLOAT, Float32Array,

				name, size, (len = size * 4), no, offset

			offset += len

		# shorts

		for name, size of @_shorts

			@_addEl SHORT, Int16Array,

				name, size, (len = size * 2), @_normalized[name]?, offset

			offset += len

		# unsigned shorts

		for name, size of @_unsignedShorts

			@_addEl UNSIGNED_SHORT, Uint16Array,

				name, size, (len = size * 2), @_normalized[name]?, offset

			offset += len

		# bytes

		for name, size of @_bytes

			@_addEl BYTE, Int8Array,

				name, size, (len = size * 1), @_normalized[name]?, offset

			offset += len

		# unsigned bytes

		for name, size of @_unsignedBytes

			@_addEl UNSIGNED_BYTE, Uint8Array,

				name, size, (len = size * 1), @_normalized[name]?, offset

			offset += len

		offset = makeNumberMultipleOf offset, 4

		@_stride = offset

	getElements: ->

		do @_prepare

		@_elements

	hasElements: ->

		@_hasElements

	getStride: ->

		do @_prepare

		@_stride

	_makeBuffer: (count) ->

		do @_prepare

		new ArrayBuffer @_stride * count

	_putElementsIn: (holder, buffer, i) ->

		do @_prepare

		for el in @_elements

			holder[el.name] = p = new el.jsType buffer, el.offset + (@_stride * i), el.size

			def = @_defaults[el.name]

			if def?

				p.set def

		return

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k

empty = (o) -> Object.keys(o).length is 0

{FLOAT, BYTE, UNSIGNED_BYTE, SHORT, UNSIGNED_SHORT} = WebGLRenderingContext
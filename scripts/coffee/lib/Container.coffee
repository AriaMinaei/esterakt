module.exports = class Container

	constructor: ->

		@_names = {}

		@_params = {}

		for type in self._types

			[name] = type

			@_params[name] = []

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

		else if defaults?

			throw Error "`defaults` must be an array"

		@

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

		for type in self._types

			[typeName, jsArray, glType] = type

			for paramConfig in @_params[typeName]

				byteLength = paramConfig.size * jsArray.BYTES_PER_ELEMENT

				@_elements.push

					typeName: typeName

					glType: glType

					jsArray: jsArray

					name: paramConfig.name

					size: paramConfig.size

					byteLength: byteLength

					normalized: paramConfig.normalized

					offset: offset

					defaults: paramConfig.defaults

				offset += byteLength

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

	_putElementsIn: (buffer, i, holder) ->

		do @_prepare

		for el in @_elements

			holder[el.name] = p = new el.jsArray buffer,

				el.offset + (@_stride * i), el.size

			p.set el.defaults if el.defaults?

		return

	@_types = []

	@_defineType = (typeName, jsArray, glType, normalizable) ->

		self._types.push Array::slice.call arguments, 0

		self::[typeName] = (name, size, defaults, normalized) ->

			# validate `name`
			unless typeof name is 'string' and name.match /^[a-zA-Z0-9]+$/

				throw Error "Invalid param name '#{name}'"

			# make sure it doesn't already exist
			if @_names[name]?

				throw Error "Param name '#{name}' already exists"

			# validate `size`
			unless typeof size is 'number' and isFinite(size) and 0 < size

				throw Error "Invalid param size '#{size}' for param '#{name}'"

			# validate `defaults`
			if Array.isArray defaults

				if defaults.length isnt size

					throw Error "Length of the `defaults` doesn't match elemen't size"

			else if defaults?

				throw Error "`defaults` must be an array"

			# validate `normalized`
			if normalizable and normalized?

				if typeof normalized isnt 'boolean'

					throw Error "Invalid `normalized` attribute for param '#{name}'"

			else

				normalized = no

			@_params[typeName].push {name, size, defaults, normalized}

			@_names[name] = yes

			@

		return

	@_alias: (originalName, aliasName) ->

		@::[aliasName] = ->

			@[originalName].apply @, arguments

	@_defineDefaultTypes: ->

		{FLOAT, BYTE, UNSIGNED_BYTE, SHORT, UNSIGNED_SHORT} = WebGLRenderingContext

		self._defineType 'double', Float64Array, null, no
		self._alias 'double', 'float64'

		self._defineType 'float', Float32Array, FLOAT, no
		self._alias 'float', 'float32'

		self._defineType 'long', Int32Array, null, no
		self._alias 'long', 'int32'

		self._defineType 'unsignedLong', Uint32Array, null, no
		self._alias 'unsignedLong', 'uint32'

		self._defineType 'short', Int16Array, SHORT, yes
		self._alias 'short', 'int16'

		self._defineType 'unsignedShort', Uint16Array, UNSIGNED_SHORT, yes
		self._alias 'unsignedShort', 'uint16'

		self._defineType 'byte', Int8Array, BYTE, yes
		self._alias 'byte', 'int8'

		self._defineType 'unsignedByte', Uint8Array, UNSIGNED_BYTE, yes
		self._alias 'unsignedByte', 'uint8'

	self = @

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k

Container._defineDefaultTypes()
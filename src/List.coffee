ListBuffer = require './list/ListBuffer'
ListProp = require './list/ListProp'
BitListProp = require './list/BitListProp'
Pool = require './list/Pool'

module.exports = class List

	@of: (cls, length, initializer) ->

		new List cls, length, initializer

	constructor: (@_baseClass, length, initializer) ->

		@_propsByName = {}
		@_propsByBytesPerElement = {1: {}, 2:{}, 4:{}, 8:{}}
		@_stride = 0
		@_bitProps = {}

		@_hasBits = no

		do @_extractProps

		do @_fixStride

		@setLength length

		do @_createClass

		@_pool = new Pool this, initializer

	_extractProps: ->

		for name, value of @_baseClass::

			continue unless name.match /^\$/

			@_addProp name.substr(1, name.length), value

		return

	_addProp: (name, descriptor) ->

		if descriptor.isBoolean

			return @_addBooleanProp name, descriptor

		@_stride += descriptor.bytesPerElement

		listProp = new ListProp this, name, descriptor

		@_propsByBytesPerElement[descriptor.bytesPerElement][name] = listProp

		@_propsByName[name] = listProp

		return

	_addBooleanProp: (name, descriptor) ->

		@_hasBits = yes

		listProp = new BitListProp this, name, descriptor

		@_propsByName[name] = listProp
		@_bitProps[name] = listProp

	_fixStride: ->

		biggestByteLength = 0

		for name in Object.keys(@_propsByBytesPerElement) by -1

			if Object.keys(@_propsByBytesPerElement[name]).length > 0

				biggestByteLength = parseInt name

				break

		if @_hasBits then @_stride += 4

		@_stride = makeNumberMultipleOf @_stride, biggestByteLength

	getLength: ->

		@_length

	setLength: (length) ->

		@_length = length

		byteLength = length * @_stride

		unless @_listBuffer?

			@_listBuffer = new ListBuffer byteLength

		else

			@_listBuffer.setByteLength byteLength

		this

	_createClass: ->

		class ListClass extends @_baseClass

			constructor: (@_esteraktList, @_esteraktIndex) ->

				super

			_setEsteraktIndex: (@_esteraktIndex) ->

		@_class = ListClass

		do @_addPropsToClass

	_addPropsToClass: ->

		curByteOffset = 0

		for bytesPerElement in Object.keys(@_propsByBytesPerElement) by -1

			props = @_propsByBytesPerElement[bytesPerElement]

			bytesPerElement = parseInt bytesPerElement

			for name, listProp of props

				listProp.setupSettersAndGettersOnClass @_class, @_stride, curByteOffset

				curByteOffset += bytesPerElement

		i = 0

		for name, listProp of @_bitProps

			listProp.setupSettersAndGettersOnClass @_class, @_stride, curByteOffset, i

			i++

		return

	get: (i) ->

		@_pool.get i

	take: (obj) ->

		@_pool.take obj

		this

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k
ListBuffer = require './list/ListBuffer'
ListProp = require './list/ListProp'
Pool = require './list/Pool'

module.exports = class List

	constructor: (classType, length) ->

		@_propsByName = {}
		@_propsByBytesPerElement = {1: {}, 2:{}, 4:{}, 8:{}}
		@_stride = 0

		@_classType = classType

		@_useProps classType.getPropDescriptors()

		do @_fixStride

		@setLength length

		do @_createClass

		@_pool = new Pool this

	_useProps: (descriptors) ->

		for name, descriptor of descriptors

			@_addProp name, descriptor

		return

	_addProp: (name, descriptor) ->

		@_stride += descriptor.byteLength

		listProp = new ListProp this, name, descriptor

		@_propsByBytesPerElement[descriptor.bytesPerElement][name] = listProp

		@_propsByName[name] = listProp

		return

	_fixStride: ->

		@_stride = makeNumberMultipleOf @_stride, 4

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

		class ListClass extends @_classType._class

			constructor: (@_esteraktList, @_esteraktIndex) ->

				super

			_setEsteraktIndex: (@_esteraktIndex) ->

		@_class = ListClass

		do @_addPropsToClass

	_addPropsToClass: ->

		curByteOffset = 0

		for _, props of @_propsByBytesPerElement

			for name, listProp of props

				listProp.setupSettersAndGettersOnClass @_class, @_stride, curByteOffset

				curByteOffset += listProp.descriptor.byteLength

		return

	get: (i) ->

		@_pool.get i

	take: (obj) ->

		@_pool.take obj

		this

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k
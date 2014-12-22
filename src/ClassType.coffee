module.exports = class ClassType

	constructor: (@_class) ->

		@_props = {}

		do @_findProps

	_findProps: ->

		for name, value of @_class::

			continue unless name.match /^\$/

			@_addProp name.substr(1, name.length), value

		return

	_addProp: (name, v) ->

		@_props[name] = v

	_getProps: ->

		@_props
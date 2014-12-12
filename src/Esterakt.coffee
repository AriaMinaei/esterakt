Group = require './Group'
props = require './props'

module.exports = class Esterakt

	constructor: ->

		@_classList = []
		@_classes = {}

		@_specShouldChange = yes

	addClass: (cls, name) ->

		if typeof cls isnt 'function'

			throw Error "Only classes are allowed"

		if cls in @_classList

			throw Error "You've already added this class"

		@_specShouldChange = yes

		@_classList.push cls

		unless name? then name = cls.name

		@_classes[name] = cls

		this

	createGroup: (count) ->

		new Group this, count

	_getSpec: ->

		unless @_spec?

			do @_generateSpec

		@_spec

	_generateSpec: ->

		@_spec = 'hello'

	@prop: props
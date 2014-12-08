Group = require './Group'
props = require './props'

module.exports = class Esterakt

	constructor: ->

		@_classes = []

	addClass: (cls) ->

		if cls in @_classes

			throw Error "You've already added this class."

		@_classes.push cls

		this

	createGroup: ->

		new Group

	@prop: props
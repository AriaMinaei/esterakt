module.exports = class Pool

	constructor: (@_cls) ->

		@_allObjects = []
		@_inactiveObjects = []
		@_inactiveCount = 0

	get: (index) ->

		if @_inactiveCount is 0

			return @_instantiateObject()

		@_inactiveCount--

		obj = @_inactiveObjects.pop()

		obj.__setEsteraktIndex index

		obj

	take: (obj) ->

		@_inactiveObjects.push obj
		@_inactiveCount++

		this

	_instantiateObject: ->

		# TODO: set buffers and stuff

		obj = new @_cls

		@_allObjects.push obj

		obj
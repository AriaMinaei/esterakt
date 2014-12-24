module.exports = class Pool

	constructor: (@list, initializer) ->

		@_allObjects = []
		@_reserves = []
		@_reservesCount = 0

		if initializer?

			@_initializer = initializer

		else

			@_initializer = (cls, arg1, arg2) ->

				new cls arg1, arg2

	get: (i) ->

		if @_reservesCount > 0

			@_reservesCount--

			p = @_reserves.pop()

			p._setEsteraktIndex(i)

			return p

		return @_create i

	_create: (i) ->

		obj = @_initializer @list._class, @list, i

		@_allObjects.push obj

		obj

	take: (obj) ->

		@_reservesCount++
		@_reserves.push obj

		return
module.exports = class Pool

	constructor: (@list) ->

		@_allObjects = []
		@_reserves = []
		@_reservesCount = 0

	get: (i) ->

		if @_reservesCount > 0

			@_reservesCount--

			p = @_reserves.pop()

			p._setEsteraktIndex(i)

			return p

		return @_create i

	_create: (i) ->

		obj = new @list._class @list, i

		@_allObjects.push obj

		obj

	take: (obj) ->

		@_reservesCount++
		@_reserves.push obj

		return
module.exports = class Group

	constructor: (@_esterakt, count) ->

		count = count|0

		if count < 1

			throw Error "Count must be a number bigger than zero"

		@_spec = @_esterakt._getSpec()

		@classes = {}

	setCount: ->

		this
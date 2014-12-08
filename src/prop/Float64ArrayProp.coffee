_ArrayProp = require './_ArrayProp'

console.log 'hi'

module.exports = class Float64ArrayProp extends _ArrayProp

	self = this

	constructor: (size) ->

		return new self(size) unless this instanceof self

		super
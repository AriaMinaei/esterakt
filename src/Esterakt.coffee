module.exports = class Esterakt

	constructor: ->

Esterakt.List = require './List'

for name, val of require './basicTypes'

	Esterakt[name] = val
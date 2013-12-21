Container = require './Container'
object = require 'utila/scripts/js/lib/object'

module.exports = class Esterakt

	constructor: ->

		@_containers = {}

	getContainer: (name = 'default') ->

		unless @_containers[name]?

			return @_containers[name] = new Container

		@_containers[name]

	getContainers: ->

		@_containers

	makeParamHolders: (base, count) ->

		count = parseInt count

		if count < 1

			throw Error "`count` must be a positive integer"

		holders = []

		holders.__buffers = buffers = {}

		holders.__uint8Views = uint8Views = {}

		for name, cont of @_containers

			buffers[name] = b = cont._makeBuffer count
			uint8Views[name] = new Uint8Array b

		containers = @_containers

		for i in [0...count]

			holder = if base? then object.clone base else {}

			for name, cont of containers

				cont._putElementsIn holder, buffers[name], i

			holders.push holder

		holders
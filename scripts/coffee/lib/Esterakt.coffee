Container = require './Container'
object = require 'utila/scripts/js/lib/object'

module.exports = class Esterakt

	constructor: ->

		# An Esterakt is just a collection of containers.
		# Each container is configured with its own structure
		# and its own separate buffer.
		@_containers = {}

	# Returns the container with the given name, defaults to the
	# 'default' container.
	#
	# Creates a container if it doesn't exist.
	getContainer: (name = 'default') ->

		unless @_containers[name]?

			return @_containers[name] = new Container

		@_containers[name]

	# Returns all the containers
	getContainers: ->

		@_containers

	# Generates the buffers for the given `count`.
	generate: (count, base) ->

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

				cont._putElementsIn buffers[name], i, holder

			holders.push holder

		holders
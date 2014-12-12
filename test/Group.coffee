require('chai').use(require 'chai-fuzzy').should()

Esterakt = require '../lib/Esterakt'
Group = require '../lib/Group'
{prop} = Esterakt

describe "Group", ->

	describe "constructor()", ->

		it "should work"

	describe "general", ->

		it "should work", ->

			class Point

				$_time: 				prop.Float64().inBuffer('general')
				$value: 				prop.Float64()
				$handlers: 			prop.Float64Array(4).inBuffer('notUsedInShaders')
				$leftHandler: 		prop.Float64Array(2).ofProp('handlers', 0)
				$rightHandler: 	prop.Float64Array(2).ofProp('handlers', 2)
				$leftHandlerX: 	prop.Float64().ofProp('handlers', 0)
				$leftHandlerY: 	prop.Float64().ofProp('handlers', 1)
				$rightHandlerX: 	prop.Float64().ofProp('handlers', 2)
				$rightHandlerY: 	prop.Float64().ofProp('handlers', 3)

				setTime: (t) ->

					@_time = t

			class Connector

				$time: prop.Float64()

			esterakt = new Esterakt()

			esterakt.addClass Point
			esterakt.addClass Connector

			group = esterakt.createGroup(10)

			group.getPoolOf('Point')
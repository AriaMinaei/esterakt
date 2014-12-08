require('chai').use(require 'chai-fuzzy').should()

Esterakt = require '../lib/Esterakt'
{prop} = Esterakt

describe 'Esterakt', ->

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

				constructor: ->

					do @_initEsterakt

				setTime: (t) ->

					@_time = t

					@events.emit 'time-change'

			class Connector

				$time: prop.Float64()

				constructor: ->

					do @_initEsterakt

			esterakt = new Esterakt
			esterakt.addClass Point
			esterakt.addClass Connector

			group = esterakt.createGroup()

			group.setCount 50
			group.setCount 100
			group.setCount 10

			p = new group.classes.Point 5

			group.pool.take p

			class PointView

				constructor: (@point, @eventsManager) ->

					@eventsManager.for('point:' + @point.index).on 'time-change', => do @_updateTime

				_updateTime: ->

					@el.x @point.time * 200

			new pointViewsGenerator.classes.PointView 5
module.exports = class _Prop

	constructor: ->

		###*
		 * If true, then the property will point to values inside another property.
		 * @type Bool
		###
		@_ofOtherProp = no

		@_indexOffsetOfOtherProp = 0

		@_bufferName = 'default'

	inBuffer: (bufferName = 'default') ->

		@_ofOtherProp = no
		@_bufferName = bufferName

		this

	ofProp: (propName, indexOffset = 0) ->

		@_ofOtherProp = yes
		@_indexOffsetOfOtherProp = indexOffset|0

		this
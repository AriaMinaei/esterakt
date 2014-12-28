module.exports = class ListProp

	constructor: (@list, @name, @descriptor) ->

	setupSettersAndGettersOnClass: (cls, byteStride, byteOffset) ->

		stride = byteStride / @descriptor.bytesPerElement
		offset = byteOffset / @descriptor.bytesPerElement

		typedArrayPropName = @list._listBuffer.getPropNameForTypedArray @descriptor.typedArray

		index = "#{stride} * this._esteraktIndex + #{offset}"

		accessor = "this._esteraktList._listBuffer.#{typedArrayPropName}[#{index}]"

		eval "function getter(){ return #{accessor}; }"

		eval "function setter(v){ #{accessor} = v; }"

		Object.defineProperty cls.prototype, @name, get: getter, set: setter
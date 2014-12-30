module.exports = class ListProp

	constructor: (@list, @name, @descriptor) ->

	setupSettersAndGettersOnClass: (cls, byteStride, byteOffset, i) ->

		stride = byteStride / 4
		offset = byteOffset / 4

		us = Math.pow(2, i)

		typedArrayPropName = @list._listBuffer.getPropNameForTypedArray Uint32Array

		index = "#{stride} * this._esteraktIndex + #{offset}"

		accessor = "this._esteraktList._listBuffer.#{typedArrayPropName}[#{index}]"

		eval "function getter(){ return (#{accessor} & #{us}) == #{us}; }"

		st = "function setter(v){

			if (Boolean(v) === true) {
				#{accessor} |= #{us};
			} else {
				#{accessor} &= ~#{us};
			}
		}"

		eval st

		Object.defineProperty cls.prototype, @name, get: getter, set: setter
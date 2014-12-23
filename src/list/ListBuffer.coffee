module.exports = class ListBuffer

	constructor: (byteLength) ->

		@setByteLength byteLength

	setByteLength: (newByteLength) ->

		@_byteLength = newByteLength

		oldBuffer = @arrayBuffer

		@arrayBuffer = new ArrayBuffer @_byteLength

		oldUint8Array = @uint8Array

		newUint8Array = @uint8Array = new Uint8Array @arrayBuffer

		if oldUint8Array?

			if oldUint8Array.length > newUint8Array.length

				oldUint8Array = oldUint8Array.subarray(0, newUint8Array.length)

			newUint8Array.set oldUint8Array

		@uint8ClampedArray = new Uint8ClampedArray @arrayBuffer

		@int8Array = new Int8Array @arrayBuffer

		@uint16Array = new Uint16Array @arrayBuffer
		@int16Array = new Int16Array @arrayBuffer

		@uint32Array = new Uint32Array @arrayBuffer
		@int32Array = new Int32Array @arrayBuffer

		@float32Array = new Float32Array @arrayBuffer
		@float64Array = new Float64Array @arrayBuffer

		this

	getPropNameForTypedArray: (typedArrayConstructor) ->

		switch typedArrayConstructor

			when Uint8ClampedArray then 'uint8ClampedArray'

			when Int8Array then 'int8Array'
			when Uint8Array then 'uint8Array'

			when Uint16Array then 'uint16Array'
			when Int16Array then 'int16Array'

			when Uint32Array then 'uint32Array'
			when Int32Array then 'int32Array'

			when Float32Array then 'float32Array'
			when Float64Array then 'float64Array'

			else

				throw Error "Unkown typedArrayConstructor '#{typedArrayConstructor}'"
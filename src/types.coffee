types = {}

types.Int32 = class Int32

	@bytesPerElement: 4
	@typedArray: Int32Array

types.Uint32 = class Uint32

	@bytesPerElement: 4
	@typedArray: Uint32Array

types.Int16 = class Int16

	@bytesPerElement: 2
	@typedArray: Int16Array

types.Uint16 = class Uint16

	@bytesPerElement: 2
	@typedArray: Uint16Array

types.Int8 = class Int8

	@bytesPerElement: 1
	@typedArray: Int8Array

types.Uint8 = class Uint8

	@bytesPerElement: 1
	@typedArray: Uint8Array

types.Float32 = class Float32

	@bytesPerElement: 4
	@typedArray: Float32Array

types.Float64 = class Float64

	@bytesPerElement: 8
	@typedArray: Float64Array

types.Boolean = class BooleanType

	@isBoolean: yes

module.exports = types
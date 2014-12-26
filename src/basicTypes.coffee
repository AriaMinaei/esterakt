types = {}

types.Int32Type = class Int32Type

	@bytesPerElement: 4
	@typedArray: Int32Array

types.Uint32Type = class Uint32Type

	@bytesPerElement: 4
	@typedArray: Uint32Array

types.Int16Type = class Int16Type

	@bytesPerElement: 2
	@typedArray: Int16Array

types.Uint16Type = class Uint16Type

	@bytesPerElement: 2
	@typedArray: Uint16Array

types.Int8Type = class Int8Type

	@bytesPerElement: 1
	@typedArray: Int8Array

types.Uint8Type = class Uint8Type

	@bytesPerElement: 1
	@typedArray: Uint8Array

types.Float32Type = class Float32Type

	@bytesPerElement: 4
	@typedArray: Float32Array

types.Float64Type = class Float64Type

	@bytesPerElement: 8
	@typedArray: Float64Array

module.exports = types
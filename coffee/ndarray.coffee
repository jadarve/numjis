
###########################################################
# Array data types
###########################################################
UINT8 =
    elementSize : 1
    name : 'uint8'

INT8 =
    elementSize : 1
    name : 'int8'

UINT16 =
    elementSize : 2
    name : 'uint16'

INT16 =
    elementSize : 2
    name : 'int16'

UINT32 =
    elementSize : 4
    name : 'uint16'

INT32 =
    elementSize : 4
    name : 'int32'

FLOAT32 =
    elementSize : 4
    name : 'float32'

FLOAT64 =
    elementSize : 8
    name : 'float64'


DTYPES = [UINT8, INT8,
          UINT16, INT16,
          UINT32, INT32,
          FLOAT32, FLOAT64]


###########################################################
# ND-Array class
###########################################################

class NDArray
    """
    N-dimentional array class
    """

    constructor: (shape, dtype=FLOAT32) ->

        @shape = shape
        @ndim = shape.length
        @dtype = dtype

        # computes array stride
        @stride = new Array(shape.length)
        @stride[@ndim-1] = 1
        for i in [shape.length-2..0]
            @stride[i] = @stride[i+1]*@shape[i+1]

        # total number of elements in the buffer
        @length = @stride[0]*@shape[0]

        # allocates data buffer
        @buffer = new ArrayBuffer(@length*@dtype.elementSize)

        # data view
        @data = switch @dtype
            when UINT8 then new Uint8Array(@buffer)
            when INT8 then new Int8Array(@buffer)
            when UINT16 then new Uint16Array(@buffer)
            when INT16 then new Int16Array(@buffer)
            when UINT32 then new Uint32Array(@buffer)
            when INT32 then new Int32Array(@buffer)
            when FLOAT32 then new Float32Array(@buffer)
            when FLOAT64 then new Float64Array(@buffer)
            # else -> TODO: throw error


error = require('./error')

###########################################################
# Array data types
###########################################################
uint8 =
    size : 1
    name : 'uint8'

int8 =
    size : 1
    name : 'int8'

uint16 =
    size : 2
    name : 'uint16'

int16 =
    size : 2
    name : 'int16'

uint32 =
    size : 4
    name : 'uint16'

int32 =
    size : 4
    name : 'int32'

float32 =
    size : 4
    name : 'float32'

float64 =
    size : 8
    name : 'float64'


###########################################################
# ND-Array class
###########################################################

class NDArray

    constructor: (shape, dtype=float32, buffer=null) ->

        # TODO: validate shape
        @shape = shape
        @ndim = shape.length
        @dtype = dtype

        # computes array stride
        @stride = new Array(shape.length)
        @stride[@ndim-1] = 1

        if @ndim > 1
            for i in [shape.length-2..0]
                @stride[i] = @stride[i+1]*@shape[i+1]

        # total number of elements in the buffer
        @length = @stride[0]*@shape[0]

        # Buffer allocation
        if buffer == null
            # allocates data buffer
            @buffer = new ArrayBuffer(@length*@dtype.size)

        else
            # check if the byte length is the required
            if buffer.byteLength != @length*@dtype.size
                throw new error.NumjisException('insufficient buffer size to store 
                    array elements: got ' + buffer.byteLength +
                    ' bytes, required: ' + @length*@dtype.size)
                
            # use the buffer parameter as storage space
            @buffer = buffer

        # create data view
        @data = switch @dtype
            when uint8 then new Uint8Array(@buffer)
            when int8 then new Int8Array(@buffer)
            when uint16 then new Uint16Array(@buffer)
            when int16 then new Int16Array(@buffer)
            when uint32 then new Uint32Array(@buffer)
            when int32 then new Int32Array(@buffer)
            when float32 then new Float32Array(@buffer)
            when float64 then new Float64Array(@buffer)
            else throw new error.NumjisException('Unexpected array type, got: ' + @dtype)


###########################################################
# Module functions
###########################################################

copy = (arr) ->
    return

decode = (str, base) ->
    return

reshape = (arr, shape) ->
    return


module.exports = 

    # constants
    uint8 : uint8
    int8 : int8
    uint16 : uint16
    int16 : int16
    uint32 : uint32
    int32 : int32
    float32 : float32
    float64 : float64

    # classes
    NDArray : NDArray

    # functions
    copy : copy
    decode : decode
    reshape : reshape



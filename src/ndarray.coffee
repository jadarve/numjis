error = require('./error')

###
Unsigned Integer 8 bits
###
uint8 =
    size : 1
    name : 'uint8'

###
Integer 8 bits
###
int8 =
    size : 1
    name : 'int8'

###
Unsigned Integer 16 bits
###
uint16 =
    size : 2
    name : 'uint16'

###
Integer 16 bits
###
int16 =
    size : 2
    name : 'int16'

###
Unsigned Integer 16 bits
###
uint32 =
    size : 4
    name : 'uint16'

###
Integer 32 bits
###
int32 =
    size : 4
    name : 'int32'

###
Floating point number 32 bits
###
float32 =
    size : 4
    name : 'float32'

###
Floating point number 64 bits
###
float64 =
    size : 8
    name : 'float64'



###
N-Dimensional array container

This class provides the functionality of a N-Dimensional
array container similar to those of Numpy and Matlab.

###
class NDArray

    ###
    @property [int array] Array shape. List of positive integers
      with the size of the array in each dimension.
    ###
    shape : []

    ###
    @property [int] Number of dimensions.
    ###
    ndim : 0

    ###
    @property [dtype] Array element data type.
    ###
    dtype : float32

    ###
    @property [int array]
    ###
    stride : []

    ###
    @property [int] length Total number of elements in the array.
    ###
    length : 0

    ###
    @property [int] byteLength Total length of the array in bytes.
    ###
    byteLength : 0

    ###
    @property [ArrayBuffer] Storage space for array elements.
    ###
    buffer : null

    ###
    @property [dtype Array] dtype view of the array.
    ###
    data : null
    
    ###
    Creates a new ND-array of given shape and type
    
    @param [int array] shape Array shape.
      List of positive integer with the size of each dimension.
    @param [dtype, optional] dtype Array data type.
      It must be one of the following values:
      @see{uint8}
      {uint8, int8, uint16, int16, uint32, int32, float32, float64}
    @param [ArrayBuffer, optional] buffer buffer to store the array elements.
      The length in bytes should be equal to total number of 
      elements times the element size in bytes.
    ###
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
        @byteLength = @length*@dtype.size

        # Buffer allocation
        if buffer == null
            # allocates data buffer
            @buffer = new ArrayBuffer(@byteLength)

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




arange = (start, stop, step=1, dtype=float32) ->

    length = Math.floor((stop-start)/step)

    arr = new NDArray([length], dtype)
    for n in [0..arr.length]
        arr.data[n] = start + n*step

    return arr


copy = (arr) ->
    ###
    Returns a copy of an array

    @param [arr, NDArray] array to copy

    @return [cpy, NDArray] array copy.
    ###

    if !arr instanceof NDArray
        throw new error.NumjisException('Array argument must be and instance of NDArray')

    # creates a copy of the storage buffer
    bufferCopy = arr.buffer.slice(0)
    return new NDArray(arr.shape, arr.dtype, bufferCopy)


# NOTE: This is not working! write own base64 coding/decoding?
# atob = require('atob')
# btoa = require('btoa')
decode = (str, shape, dtype) ->
    
    try
        # buffer = new ArrayBuffer(btoa(str))
        return

    catch err # InvalidCharacterError from atob
        throw new error.NumjisException('Error decoding array data: ' + err)

    return new NDArray(shape, dtype, buffer)


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
    arange : arange
    decode : decode
    reshape : reshape



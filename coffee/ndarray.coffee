error = require('./error')
# util = require('./util')      # Cannot do circular dependencies

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
    name : 'uint32'

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
Data types table
###
DTYPES_TABLE = new Object()


###
Register a new type in the type table

@param [object] dtype Data type object description.
  It should be an object of the form
  dtype = {
    name : 'name',
    size : N
  }
  where N is the size of the type in bytes.

@throws NumjisException if dtype is a malformed object.
###
registerType = (dtype) ->

    if !dtype.name
        throw new error.NumjisException('Dtype object should have a name property')

    if !dtype.size
        throw new error.NumjisException('Dtype object should have a size property')

    DTYPES_TABLE[dtype.name] = {name : dtype.name, size : dtype.size}


###
Return a dtype object given its name.
###
typeFromName = (name) ->
    dtype = DTYPES_TABLE[name]

    if typeof dtype == 'undefined' 
        throw new error.NumjisException('Dtype not found, name: ' + name)

    return dtype


# register default dtypes
registerType(uint8)
registerType(uint16)
registerType(uint32)
registerType(int8)
registerType(int16)
registerType(int32)
registerType(float32)
registerType(float64)


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
        @data = switch @dtype.name
            when 'uint8' then new Uint8Array(@buffer)
            when 'int8' then new Int8Array(@buffer)
            when 'uint16' then new Uint16Array(@buffer)
            when 'int16' then new Int16Array(@buffer)
            when 'uint32' then new Uint32Array(@buffer)
            when 'int32' then new Int32Array(@buffer)
            when 'float32' then new Float32Array(@buffer)
            when 'float64' then new Float64Array(@buffer)
            else throw new error.NumjisException('Unexpected array type name, got: ' + @dtype.name)


    ###
    Returns value of the array at a given position

    @param [int array] p position
    ###
    at: (p) ->
        # error check on p occurs at flatCoordinate method
        return @data[@flat(p)]


    get : (p) ->
        return

    set : (value, p) ->
        return


    ###
    Returns the flattened position equivalent to p

    @param [int array] p ND-position array. p.length must
      be equal to @see{ndim} property

    @return [int] flattened position

    TODO: testing with more than 1 dimension
    ###
    flat: (p) ->

        if p.length != @ndim
            throw new error.NumjisException('incorrect position dimension, got: ' + p.length + ' expecting: ' + @ndim)

        # flattened position
        f = 0
        for d in [0...@ndim]
            f += @stride[d]*p[d]

        return f


    ###
    Fill the array with a given constant value

    @param [dtype] value fill value
    ###
    fill: (value) ->

        for n in [0...@length]
            @data[n] = value


###
Creates a ND-array filled with zeros

@param [int list] shape array shape
@param [dtype, optional] array type

@return NDArray object
###
zeros = (shape, dtype=float32) ->

    arr = new NDArray(shape, dtype=dtype)
    return arr
    

###
Creates a 1D array of elements in sequences from start to stop with step increments

@param [number] start start value.
@paran [number] stop stop value.
@param [number] step step value.
@param [dtype, optional] dtype array data type.
###
arange = (start, stop, step=1, dtype=float32) ->

    length = Math.floor((stop-start)/step)

    arr = new NDArray([length], dtype)
    for n in [0...arr.length]
        arr.data[n] = start + n*step

    return arr

###
Creates a 1D array from an iterable object

@param [Array] values iterable with array values.

@return NDArray object.
###
array = (values, dtype=float32) ->

    arr = new NDArray(values.length, dtype=dtype)

    for n in [0...values.length]
        arr.data[n] = values[n]

    return arr

###
Returns a copy of an array

@param [arr, NDArray] array to copy

@return [cpy, NDArray] array copy.
###
copy = (arr) ->

    if !arr instanceof NDArray
        throw new error.NumjisException('Array argument must be and instance of NDArray')

    # creates a copy of the storage buffer
    bufferCopy = arr.buffer.slice(0)
    return new NDArray(arr.shape, arr.dtype, bufferCopy)


reshape = (arr, shape) ->
    # TODO
    return


module.exports = 

    # constants
    DTYPES_TABLE : DTYPES_TABLE

    # dtypes
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
    registerType : registerType
    typeFromName : typeFromName
    zeros : zeros
    copy : copy
    arange : arange
    reshape : reshape
    array : array


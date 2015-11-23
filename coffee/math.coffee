# nd = require('./ndarray')

###
Returns the sum of an array.
###
sum = (arr, axis=null) ->

    if !arr instanceof NJ.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    if axis == null
        # compute sum over the flattened array
        total = 0
        for n in [0...arr.length]
            total += arr.data[n]

        return total

    # checks value of axis
    if axis < 0 or axis >= arr.ndim
        throw new error.NumjisException('axis out of bound: ' + axis)

    # creates an array from dimension 0 to axis -1
    sshape = arr.shape[0...axis]
    sumArr = new NJ.NDArray(sshape, arr.dtype)

    # sum the elements over axis
    # HOW?

    return sumArr



# Trigonometric functions

cos = (arr, axis=null) ->
    return

sin = (arr, axis=null) ->
    return

tan = (arr, axis=null) ->
    return


module.exports =

    sum : sum

    cos : cos
    sin : sin
    tan : tan

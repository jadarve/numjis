nd = require('./ndarray')

print = (arr) ->
    """
    Prints an NDArray object
    """

    if !arr instanceof nd.NDArray
        throw 'argument is not a NDArray object'

    for e in arr.data
        console.log(e)


module.exports = 
    print : print
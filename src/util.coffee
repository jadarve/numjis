nd = require('./ndarray')

print = (arr) ->

    if !arr instanceof nd.NDArray
        throw 'argument is not a NDArray object'

    dataStr = '['
    for n in [0...arr.length]
        dataStr += arr.data[n] +  (if n < arr.length-1 then ', ' else '')
    dataStr += ']'

    console.log(dataStr)


module.exports = 
    print : print
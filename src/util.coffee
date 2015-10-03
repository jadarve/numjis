nd = require('./ndarray')

print = (arr) ->

    if !arr instanceof nd.NDArray
        throw 'argument is not a NDArray object'

    dataStr = '['
    for n in [0...arr.length]
        dataStr += arr.data[n] +  (if n < arr.length-1 then ', ' else '')
    dataStr += ']'

    console.log(dataStr)


base64Code = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='

toBase64 = (arr) ->

    if !arr instanceof nd.NDArray
        throw 'argument is not a NDArray object'

    code = []

    # scan arr.buffer to create the encoding
    for n in [0..arr.byteLength] by 3

        # read next three bytes to encode
        [b0, b1, b2] = (arr[n+i] for i in [0..2])

        word = (b0 << 16) | (b1 << 8) | b2

        w0 = (word & (0x00003F << 18)) >> 18
        w1 = (word & (0x00003F << 12)) >> 12
        w2 = (word & (0x00003F << 6)) >> 6
        w3 = (word & 0x00003F)

        code.push(base64Code[w0])
        code.push(base64Code[w1])
        code.push(base64Code[w2])
        code.push(base64Code[w3])

    return code.join('')


###
Return an ArrayBuffer object with data 
###
fromBase64 = (str) ->

    for c in str
        console.log(c)


module.exports = 
    print : print
    toBase64 : toBase64
    fromBase64 : fromBase64
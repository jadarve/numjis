nd = require('./ndarray')

print = (arr) ->

    if !arr instanceof nd.NDArray
        throw 'argument is not a NDArray object'

    dataStr = '['
    for n in [0...arr.length]
        dataStr += arr.data[n] +  (if n < arr.length-1 then ', ' else '')
    dataStr += ']'

    console.log(dataStr)


###
Base 64 code used at toBase64 and fromBase64 methods
###
base64Code = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='


###
Encodes and ArrayBuffer object to base 64.

@param [ArrayBuffer] buffer ArrayBuffer to enconde.

@return Base 64 encoded String.
###
toBase64 = (buffer) ->

    if !buffer instanceof ArrayBuffer
        throw 'argument is not an ArrayBuffer object'

    code = []

    # creates a uint8 view of the buffer
    buffer_u8 = new Uint8Array(buffer)

    # number of bytes contained in buffer that
    # are multiple of 3
    mod = buffer.byteLength % 3
    N = (buffer.byteLength) - mod

    # encode the first N bytes of buffer
    for n in [0...N] by 3
        console.log('n: ' + n)

        # read next three bytes to encode
        word = (buffer_u8[n] << 16) | (buffer_u8[n+1] << 8) | buffer_u8[n+2]

        # get the character indices from word and
        # transform it to text
        code.push(base64Code[(word & 0xFC0000) >> 18])
        code.push(base64Code[(word & 0x03F000) >> 12])
        code.push(base64Code[(word & 0x03F000) >> 12])
        code.push(base64Code[(word & 0x00003F)])


    # encode the last bytes of buffer
    word = 0
    switch(mod)

        when 0
            # nothing to do, all bytes in buffer
            # were encoded in the for loop
            break

        when 1
            word = (buffer_u8[N] << 16)

            code.push(base64Code[(word & 0xFC0000) >> 18])
            code.push(base64Code[(word & 0x03F000) >> 12])
            code.push(base64Code[64])   # padding
            code.push(base64Code[64])   # padding

        when 2
            word = (buffer_u8[N] << 16) | (buffer_u8[N+1] << 8)

            code.push(base64Code[(word & 0xFC0000) >> 18])
            code.push(base64Code[(word & 0x03F000) >> 12])
            code.push(base64Code[(word & 0x000FC0) >> 6])
            code.push(base64Code[64])   # padding

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
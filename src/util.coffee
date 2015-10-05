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
Char codes for base64Code string
###
base64CharCode = new Uint8Array(base64Code.length)

# get char codes from base64Code
for i in [0...base64Code.length]
    base64CharCode[i] = base64Code.charCodeAt(i)


###
Encodes and ArrayBuffer object to base 64.

@param [ArrayBuffer] buffer ArrayBuffer to enconde.

@return Base 64 encoded String.
###
toBase64 = (buffer) ->

    if !buffer instanceof ArrayBuffer
        throw 'argument is not an ArrayBuffer object'

    # creates a uint8 view of the buffer
    buffer_u8 = new Uint8Array(buffer)

    # number of bytes contained in buffer that
    # are multiple of 3
    mod = buffer.byteLength % 3
    N = (buffer.byteLength) - mod

    # size of the encoded array, including padding
    S = 4*(N/3) + (if mod != 0 then 4 else 0)

    # stores the char codes for the string
    codeBuffer = new Uint8Array(S)

    # index to scan codeBuffer
    s = -1

    # encode the first N bytes of buffer
    for n in [0...N] by 3
        # read next three bytes to encode
        word = (buffer_u8[n] << 16) | (buffer_u8[n+1] << 8) | buffer_u8[n+2]

        # get the character code for each element of word
        codeBuffer[++s] = base64CharCode[(word & 0xFC0000) >> 18]
        codeBuffer[++s] = base64CharCode[(word & 0x03F000) >> 12]
        codeBuffer[++s] = base64CharCode[(word & 0x000FC0) >> 6]
        codeBuffer[++s] = base64CharCode[(word & 0x00003F)]


    # encode the last bytes of buffer
    word = 0
    switch(mod)

        when 0
            # nothing to do, all bytes in buffer
            # were encoded in the for loop
            break

        when 1
            # read one byte only
            word = (buffer_u8[N] << 16)

            # get the character code for each element of word
            codeBuffer[++s] = base64CharCode[(word & 0xFC0000) >> 18]
            codeBuffer[++s] = base64CharCode[(word & 0x03F000) >> 12]
            codeBuffer[++s] = base64CharCode[64]    # padding
            codeBuffer[++s] = base64CharCode[64]    # padding

        when 2
            # read two bytes only
            word = (buffer_u8[N] << 16) | (buffer_u8[N+1] << 8)

            # get the character code for each element of word
            codeBuffer[++s] = base64CharCode[(word & 0xFC0000) >> 18]
            codeBuffer[++s] = base64CharCode[(word & 0x03F000) >> 12]
            codeBuffer[++s] = base64CharCode[(word & 0x000FC0) >> 6]
            codeBuffer[++s] = base64CharCode[64]     # padding


    # str = String.fromCharCode.apply(null, codeBuffer)
    # return str
    return utf8CodeToString(codeBuffer)


###
Transform an array containing UTF-8 character codes to string

The code is based on the answer provided in StackOverflow: 
http://stackoverflow.com/questions/12710001/how-to-convert-uint8-array-to-base64-encoded-string/12713326#12713326

@param [Uint8Array] codeBuffer UTF-8 characters code buffer
@param [int, optional] chunk  Chunk size to which the conversion
  is applied at once.

@return [String] encoded string
###
utf8CodeToString = (codeBuffer, chunk=0x8000) ->

    strList = []
    for n in [0...codeBuffer.byteLength] by chunk
        strList.push(String.fromCharCode.apply(null, codeBuffer.subarray(n, n+chunk)))

    return strList.join('')


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
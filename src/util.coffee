nd = require('./ndarray')


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
Print a NDArray to console

@param [NDArray] arr NDArray to print.

###
print = (arr) ->

    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    dataStr = '['
    for n in [0...arr.length]
        dataStr += arr.data[n] +  (if n < arr.length-1 then ', ' else '')
    dataStr += ']'

    console.log(dataStr)

###
Print the bytes of a NDArray in hexadecimal code.

@param [NDArray] arr NDArray.
###
printHex = (arr) ->

    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    view = new Uint8Array(arr.buffer)

    str = ''
    for b in view
        str += b.toString(16)

    console.log(str)


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

    if !codeBuffer instanceof Uint8Array
        throw new error.NumjisException('argument must be an Uint8Array object')


    strList = []
    for n in [0...codeBuffer.byteLength] by chunk
        strList.push(String.fromCharCode.apply(null, codeBuffer.subarray(n, n+chunk)))

    return strList.join('')


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
Return an ArrayBuffer object with data 
###
fromBase64 = (str) ->

    S = str.length

    # check the last 2 bytes searching for padding character '='
    padding = 0
    if str[S-2] == '='
        padding = 2
    else if str[S-1] == '='
        padding = 1

    # buffer size
    N = Math.floor(3*(S-padding)/4)

    buffer = new ArrayBuffer(N)
    bufferView = new Uint8Array(buffer)
    n = -1

    # decode loop
    for i in [0...S] by 4

        # Looks for the character index in the base64Code table
        # TODO: Check if there is a more efficient way to do it. IndexOf seems expensive
        w0 = base64Code.indexOf(str[i])
        w1 = base64Code.indexOf(str[i+1])
        w2 = base64Code.indexOf(str[i+2])
        w3 = base64Code.indexOf(str[i+3])

        # decode next 3 bytes
        bufferView[++n] = (w0 << 2) | ((w1 & 0x30) >> 4)
        bufferView[++n] = ((w1 & 0x0F) << 4) | ((w2 & 0x3C) >> 2)
        bufferView[++n] = ((w2 & 0x03) << 6) | w3

    # NOTE: It is not required to check for index out of bounds
    #  in bufferView. If bufferView[++n] is out of bounds, it returns
    #  undefined and the assignment does not take place.

    return buffer


###
Returns a JSON representation of the array
###
toJson = (arr, addParenthesis=false) ->

    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    strList = []
    strList.push('(') if addParenthesis
    strList.push('{')
    strList.push('dtype : "' + arr.dtype.name + '",')
    strList.push('shape : [' + arr.shape + '],')
    strList.push('buffer : "' + toBase64(arr.buffer) + '"')
    strList.push('}')
    strList.push(')') if addParenthesis

    return strList.join('\n')


###
Creates a NDArray from a JSON string
###
fromJson = (str, includeParenthesis=true) ->

    # evaluate JSON string
    obj = if includeParenthesis then eval('(' + str + ')') else eval(str)

    try
        dtype = nd.typeFromName(obj.dtype)
        shape = obj.shape
        buffer = obj.buffer
        arr = new nd.NDArray(shape, dtype, fromBase64(buffer))
        return arr
    catch e
        throw e


module.exports = 
    print : print
    printHex : printHex
    toBase64 : toBase64
    fromBase64 : fromBase64
    toJson : toJson
    fromJson : fromJson

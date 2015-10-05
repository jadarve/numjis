nj = require('../src/numjis')

# try
#     A = new nj.NDArray([3,3])
#     nj.print(A)
#     console.log(A.byteLength)

#     s = "AAAAAAAAgD8AAABAAABAQAAAgEAAAKBAAADAQAAA4EAAAABBAAAQQQ="
#     B = nj.decode(s, [10], nj.float32)
#     nj.print(B)
# catch err
#     console.log(err)



# for n in [0..10] by 3
#     console.log(n)

printHex = (buffer) ->
    view = new Uint8Array(buffer)

    str = ''
    for b in view
        str += b.toString(16)

    return str


C = nj.arange(0,7)
# nj.print(C)

S = nj.toBase64(C.buffer)
# console.log(S)
# console.log(printHex(C.buffer))

buff = nj.fromBase64(S)

D = new nj.NDArray(C.shape, C.dtype, buff)
nj.print(D)

E = new nj.NDArray([5, 3])
js = nj.toJson(E)
console.log(js)

try
    F = nj.fromJson(js)
    nj.print(F)
catch e
    console.log(e.message)

# console.log(printHex(D.buffer))

# try
#     dt = nj.typeFromName('float32')
#     console.log(dt.name)
# catch e
#     console.log(e.message)

# Numpy
# AAAAAAAAgD8AAABAAABAQAAAgEA=
# AAAAAAAAgD8AAABAAABAQAAAgEA=
# AAAAAAAAgDDAAAAAAAAAQAAAgEA=


# Mine
# AAAAAAAAgD8AAABAAABAQAAAgEAA
# AAAAAAAAgD8AAABAAABAQAAAgEAA
# AAAAAAAAgD8AAABAAABAQAAAgED/


# N = C.buffer.byteLength
# console.log(N + ' ' + Math.floor(4*N/3))

# b = new Uint8Array(5)
# for n in [0...5]
#     b[n] = n + 65

# str = String.fromCharCode.apply(null, b)
# console.log(str)
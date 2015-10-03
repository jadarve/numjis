nj = require('../src/numjis')

try
    A = new nj.NDArray([3,3])
    nj.print(A)
    console.log(A.byteLength)

    s = "AAAAAAAAgD8AAABAAABAQAAAgEAAAKBAAADAQAAA4EAAAABBAAAQQQ="
    B = nj.decode(s, [10], nj.float32)
    nj.print(B)
catch err
    console.log(err)



for n in [0..10] by 3
    console.log(n)


C = nj.arange(0, 5)
nj.print(C)

S = nj.toBase64(C.buffer)
console.log(S)

# Numpy
#AAAAAAAAgD8AAABAAABAQAAAgEA=

# Mine
#AAAAAAAAgD8AAABAAABAQAAAgEAA
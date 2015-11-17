nd = require('./ndarray')


surfaceUVs = (arr) ->

    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    if !(arr.ndim == 2 || arr.ndim == 3)
        throw new error.NumjisException('Array dimensions should be 2 or 3, got: ' + arr.ndim)

    
    height = arr.shape[0]
    width = arr.shape[1]

    UV = new nd.NDArray([height, width, 2], nd.float32)

    for r in [0...height]
        for c in [0...width]

            UV.data[UV.flat([r, c, 0])] = r / (height-1)
            UV.data[UV.flat([r, c, 1])] = c / (width-1)

    return UV


surfaceVertexNormals = (arr) ->
    
    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    if !(arr.ndim == 2 || arr.ndim == 3)
        throw new error.NumjisException('Array dimensions should be 2 or 3, got: ' + arr.ndim)

    
    height = arr.shape[0]
    width = arr.shape[1]

    normals = new nd.NDArray([height, width, 3], nd.float32)

    for r in [0...height]
        for c in [0...width]

            # FIXME: copy the arr element by element
            # normals.data[normals.flat([r, c, 0])] = arr.data[arr.flat([r, c, 0])]
            # normals.data[normals.flat([r, c, 1])] = arr.data[arr.flat([r, c, 1])]
            # normals.data[normals.flat([r, c, 2])] = arr.data[arr.flat([r, c, 2])]
            normals.data[normals.flat([r, c, 0])] = 0
            normals.data[normals.flat([r, c, 1])] = 0
            normals.data[normals.flat([r, c, 2])] = 1

    return normals


surfaceFaces = (arr) ->
    
    if !arr instanceof nd.NDArray
        throw new error.NumjisException('argument is not a NDArray object')

    if !(arr.ndim == 2 || arr.ndim == 3)
        throw new error.NumjisException('Array dimensions should be 2 or 3, got: ' + arr.ndim)

    
    height = arr.shape[0]
    width = arr.shape[1]

    faces = new nd.NDArray([height-1, width-1, 6], nd.uint32)

    for r in [0...height-1]
        for c in [0...width-1]

            # first triangle
            faces.data[faces.flat([r,c,0])] = r*width + c
            faces.data[faces.flat([r,c,1])] = (r+1)*width + c + 1
            faces.data[faces.flat([r,c,2])] = (r+1)*width + c

            # second triangle
            faces.data[faces.flat([r,c,3])] = r*width + c
            faces.data[faces.flat([r,c,4])] = r*width + c + 1
            faces.data[faces.flat([r,c,5])] = (r+1)*width + c + 1
    
    return faces


module.exports = 

    surfaceUVs : surfaceUVs
    surfaceVertexNormals : surfaceVertexNormals
    surfaceFaces : surfaceFaces
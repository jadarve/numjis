Numjis = {}


# If the library is used in a browser
window.Numjis = Numjis if window?

appendModule = (root, module) ->
    """
    Append module objects to root object
    """
    for m in Object.keys(module)
        root[m] = module[m]


nd = require('./ndarray')
util = require('./util')


appendModule(Numjis, require('./ndarray'))
appendModule(Numjis, require('./util'))
appendModule(Numjis, require('./error'))


module.exports = Numjis
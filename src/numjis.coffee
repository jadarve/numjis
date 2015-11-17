NJ = {}


# If the library is used in a browser
window.NJ = NJ if window?

appendModule = (root, module) ->
    """
    Append module objects to root object
    """
    for m in Object.keys(module)
        root[m] = module[m]


# nd = require('./ndarray')
# util = require('./util')


appendModule(NJ, require('./ndarray'))
appendModule(NJ, require('./util'))
appendModule(NJ, require('./error'))
appendModule(NJ, require('./math'))
appendModule(NJ, require('./surface'))


module.exports = NJ
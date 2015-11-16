
import base64
import numpy as np

from jinja2 import Environment, PackageLoader


__all__ = ['toJson']


# template Environment object
_templateEnv = Environment(loader=PackageLoader('numjis', 'templates'))

def toJson(arr):
    """
    Returns a JSON string corresponding to a Numpy array

    Parameters
    ----------
    arr : Numpy array

    Returns
    -------
    jsonStr : JSON string representation.

    Raises
    ------
    TypeError : if arr parameters is not a Numpy ndarray object
    """

    if type(arr) != np.ndarray:
        raise TypeError('Expecting a Numpy NDarray object')


    shapeStr = list(arr.shape)
    dtypeStr = str(arr.dtype)
    bufferStr = base64.b64encode(arr)

    arrTemplate = _templateEnv.get_template('array.json')
    jsonStr = arrTemplate.render(shape=shapeStr, dtype=dtypeStr, buffer=bufferStr)

    return jsonStr
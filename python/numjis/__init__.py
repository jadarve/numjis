

if '__RELOAD_NUMJIS__' in globals():
    __RELOAD_NUMJIS__ = True
else:
    __RELOAD_NUMJIS__ = False


from . import encode


if __RELOAD_NUMJIS__:
    
    print('reloading numjis')

    encode = reload(encode)



from .encode import *

__all__ = []
__all__.extend(encode.__all__)
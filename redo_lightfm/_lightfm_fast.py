try:
    # Import OpenMP-enabled extension
    from ._lightfm_fast_openmp import *  # NOQA
    from ._lightfm_fast_openmp import __test_in_positives  # NOQA
except ImportError as openmp_error:
    # Fall back on OpenMP-less extension
    import warnings

    try:
        from ._lightfm_fast_no_openmp import *  # NOQA
        from ._lightfm_fast_no_openmp import __test_in_positives  # NOQA
    except ImportError:
        raise openmp_error

    warnings.warn(
        "LightFM was compiled without OpenMP support. "
        "Only a single thread will be used."
    )

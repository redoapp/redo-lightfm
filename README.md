# redo-lightfm

![LightFM logo](lightfm.png)

Redo's maintained fork of [LightFM](https://github.com/lyst/lightfm).

Upstream LightFM no longer builds against current Python. This fork exists to
keep it working: it tracks modern Python and scikit-learn, and publishes
prebuilt Linux wheels.

The model and its training behaviour are unchanged from upstream. The
differences are in packaging and build configuration.

The distribution is named `redo-lightfm` and imported as `redo_lightfm`.

## About LightFM

LightFM is a Python implementation of a number of popular recommendation algorithms for both implicit and explicit feedback, including efficient implementation of BPR and WARP ranking losses. It's easy to use, fast (via multithreaded model estimation), and produces high quality results.

It also makes it possible to incorporate both item and user metadata into the traditional matrix factorization algorithms. It represents each user and item as the sum of the latent representations of their features, thus allowing recommendations to generalise to new items (via item features) and to new users (via user features).

For API details, see upstream's [Documentation](http://lyst.github.io/lightfm/docs/home.html); only the import name differs.

## Installation

Prebuilt Linux wheels are attached to each [release](https://github.com/redoapp/redo-lightfm/releases). Download the one matching your Python version and install it:

```
pip install ./redo_lightfm-<version>-<tag>.whl
```

To build from source instead — needed on any platform without a published wheel — a C compiler is required:

```
pip install git+ssh://git@github.com/redoapp/redo-lightfm.git
```

## Quickstart
Fitting an implicit feedback model on the MovieLens 100k dataset is very easy:
```python
from redo_lightfm import LightFM
from redo_lightfm.datasets import fetch_movielens
from redo_lightfm.evaluation import precision_at_k

# Load the MovieLens 100k dataset. Only five
# star ratings are treated as positive.
data = fetch_movielens(min_rating=5.0)

# Instantiate and train the model
model = LightFM(loss='warp')
model.fit(data['train'], epochs=30, num_threads=2)

# Evaluate the trained model
test_precision = precision_at_k(model, data['test'], k=5).mean()
```

## Articles and tutorials on using LightFM

These use the upstream `lightfm` import name.

1. [Learning to Rank Sketchfab Models with LightFM](http://blog.ethanrosenthal.com/2016/11/07/implicit-mf-part-2/)
2. [Metadata Embeddings for User and Item Cold-start Recommendations](http://building-babylon.net/2016/01/26/metadata-embeddings-for-user-and-item-cold-start-recommendations/)
3. [Recommendation Systems - Learn Python for Data Science](https://www.youtube.com/watch?v=9gBC9R-msAk)
4. [Using LightFM to Recommend Projects to Consultants](https://medium.com/product-at-catalant-technologies/using-lightfm-to-recommend-projects-to-consultants-44084df7321c#.gu887ky51)

## How to cite
Please cite LightFM if it helps your research. You can use the following BibTeX entry:
```
@inproceedings{DBLP:conf/recsys/Kula15,
  author    = {Maciej Kula},
  editor    = {Toine Bogers and
               Marijn Koolen},
  title     = {Metadata Embeddings for User and Item Cold-start Recommendations},
  booktitle = {Proceedings of the 2nd Workshop on New Trends on Content-Based Recommender
               Systems co-located with 9th {ACM} Conference on Recommender Systems
               (RecSys 2015), Vienna, Austria, September 16-20, 2015.},
  series    = {{CEUR} Workshop Proceedings},
  volume    = {1448},
  pages     = {14--21},
  publisher = {CEUR-WS.org},
  year      = {2015},
  url       = {http://ceur-ws.org/Vol-1448/paper4.pdf},
}
```

## Development

1. Clone the repository: `git clone git@github.com:redoapp/redo-lightfm.git`
2. Setup a virtual environment: `cd redo-lightfm && python3 -m venv venv && source ./venv/bin/activate`
3. Install it for development using pip: `pip install -e . && pip install -r test-requirements.txt`
4. You can run tests by running `./venv/bin/py.test tests`.
5. This project uses [black](https://github.com/ambv/black) to enforce code formatting and flake8 for linting, see `lint-requirements.txt`.
6. [Optional]: You can install pre-commit to locally enfore formatting and linting. Install with:
    ```bash
    pip install pre-commit
    pre-commit install
    ```

When making changes to the `.pyx` extension files, you'll need to run `python setup.py cythonize` in order to produce the extension `.c` files before running `pip install -e .`.

## Upstream

Bugs in the model itself are best reported to [lyst/lightfm](https://github.com/lyst/lightfm). Issues with this fork's packaging, wheels, or Python version support belong here.

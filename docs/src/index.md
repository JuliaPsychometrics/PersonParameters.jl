# PersonParameters.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliapsychometrics.github.io/PersonParameters.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapsychometrics.github.io/PersonParameters.jl/dev/)
[![Build Status](https://github.com/juliapsychometrics/PersonParameters.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/juliapsychometrics/PersonParameters.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/juliapsychometrics/PersonParameters.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/juliapsychometrics/PersonParameters.jl)

[PersonParameters.jl](https://github.com/juliapsychometrics/PersonParameters.jl) implements estimation of person parameters for Item Response Theory models. Item parameters used in the estimation of person parameters are treated as fixed and known.

It is tightly integrated with [ItemResponseFunctions.jl](https://github.com/juliapsychometrics/ItemResponseFunctions.jl) allowing the estimation for all models defined in the package. Currently these are:

- Models for dichotomous responses
  - 1 Parameter Logistic Model
  - 2 Parameter Logistic Model
  - 3 Parameter Logistic Model
  - 4 Parameter Logistic Model
  - 5 Parameter Logistic Model
- Models for polytomous responses: not implemented yet

Available estimation methods are:
- Maximum Likelihood
- Weighted Maximum Likelihood
- Maximum A Posteriori

## Installation
You can install PersonParameters.jl from the General package registry:

```julia
] add PersonParameters
```

## Usage
The most common use case is to estimate person parameters from a response matrix and some known item parameters.

Let us define a response matrix (`responses`) and some item difficulties (`betas`) estimated by a 1 Parameter Logistic Model.

```julia
responses = [
    0 0 1 1
    1 1 1 0
    0 0 1 1
    1 0 1 0
    1 1 0 0
]

betas = [0.2, -0.5, 1.5, -1.0]
```

Person parameters can simply be estimated by calling the `person_parameters` function, providing the data, scaling model and an estimation algorithm as arguments.

```julia
using PersonParameters

alg = MLE()
pp = person_parameters(OnePL, responses, betas, alg)
```

The resulting `pp` object contains ability estimates for all 5 persons.
To get the estimate for a single person you can index the `pp` object and extract values and standard errors.

```julia
pp2 = pp[2]

values(pp2)  # 1.3513656133670724
se(pp2)      # 1.2620475987627175
```

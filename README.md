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
- Models for polytomous responses
  - Partial Credit Model
  - Generalized Partial Credit Model
  - Rating Scale Model
  - Generalized Rating Scale Model

Available estimation methods are:
- Maximum Likelihood
- Weighted Maximum Likelihood
- Maximum A Posteriori

For more details see the [documentation](https://juliapsychometrics.github.io/PersonParameters.jl/)

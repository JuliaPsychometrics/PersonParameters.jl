```@raw html
---
layout: home

hero:
    name: PersonParameters.jl
    tagline: Estimation of person parameters for item response models
    actions:
        - theme: brand
          text: Getting started
          link: /getting-started
        - theme: alt
          text: View on Github
          link: https://github.com/JuliaPsychometrics/PersonParameters.jl  
        - theme: alt
          text: Function reference
          link: /api
---
```

```@raw html
<div class="vp-doc" style="width:80%; margin:auto">
```

# What is PersonParameters.jl?
PersonParameters.jl is a julia package that implements estimation of person parameters for item response models where item parameters are treated as known and fixed.  
It is developed by the [JuliaPsychometrics](https://github.com/juliapsychometrics) organization under MIT license. 

## Installation 
The package can be installed via julias package management. 

```julia
] add PersonParameters
```

## How do I use this package?
PersonParameters.jl can be used to estimate the person parameters of an item response model with known item parameters. 
This can be useful when only item parameters are available, e.g. when estimating a model via conditional maximum likelihood, or for online estimation of person abililty in [adaptive testing](https://en.wikipedia.org/wiki/Computerized_adaptive_testing).

It integrates with [ItemResponseFunctions.jl](https://github.com/juliapsychometrics/ItemResponseFunctions.jl) so parameters can be estimated for the following models:

### Dichotomous response models
- 1-Parameter Logistic Model
- 2-Parameter Logistic Model
- 3-Parameter Logistic Model
- 4-Parameter Logistic Model
- 5-Parameter Logistic Model

### Polytomous response models
- Partial Credit Model
- Generalized Partial Credit Model
- Rating Scale Model
- Generalized Rating Scale Model

For a fully worked example see the [Getting started](/getting-started) section.

```@raw html
</div>
```

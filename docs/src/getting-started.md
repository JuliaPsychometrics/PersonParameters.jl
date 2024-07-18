# Getting started

After successful [installation](/index#installation) you are ready to estimate person parameters.
In this simple example we will estimate person parameters for a simulated data set assuming a [Rasch model](https://en.wikipedia.org/wiki/Rasch_model).

## Simulating data
First, we need to aquire item parameters.
In a Rasch model there is only a single item parameter, the *item difficulty* (`b`). 
Assuming a test with 10 items we therefore need 10 item difficulty parameters. 
For this example we draw these from a standard normal distribution.

```@example getting-started
difficulties = randn(10)
```

Next, responses need to be simulated. 
Assuming 20 test-takers we simply randomly generate a response matrix where each test-taker responds to each item.

```@example getting-started
responses = rand(20, 10) .> 0.5
```

## Estimation of person parameters
Given the item parameters `difficulties` and response matrix `responses`, we are ready to estimate person parameters.
To do this only a single call to [`person_parameters`](@ref) is required. 
[`person_parameters`](@ref) accepts 4 arguments: the model type `M`, some `responses`, item parameters `betas` and an estimation algorithm `alg`. 
For this example we chose simple maximum likelihood estimation using the [`MLE`](@ref) algorithm[^1].

```@example getting-started
using PersonParameters

pp = person_parameters(OnePL, responses, difficulties, MLE())
```

The resulting [`PersonParameterResult`](@ref) object contains the estimated person parameters for all 20 test-takers.
The estimate of a single person can be obtained by indexing the `pp` object.

```@example getting-started
pp17 = pp[17]
```

The [`PersonParameter`](@ref) object consists of the estimate and standard error of estimation for a single test-taker. 
To access the values you can use [`value`](@ref) and [`se`](@ref) respectivelty.

```@example getting-started
value(pp17)
```

```@example getting-started
se(pp17)
```

## How to continue from here?
For specific use cases see one of our guides: 

- [Online estimation of ability in adaptive testing](/guides/adaptive-testing)

Or you can dive straight into the [API Reference](/api).

[^1]: For a full list of implemented algorithms see the [API Reference](/api#types).

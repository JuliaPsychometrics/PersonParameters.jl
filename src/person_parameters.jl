"""
    $(TYPEDEF)

A container holding a single estimated person parameter.

## Fields
$(FIELDS)

## Methods
- [`value`](@ref): Extract the person parameter estimate
- [`se`](@ref): Extract the standard error of estimation
"""
struct PersonParameter{U<:Real}
    "the estimated ability value"
    value::U
    "the estimated standard error"
    se::U
end

"""
    $(SIGNATURES)

Extract the value from a [`PersonParameter`](@ref) estimate `pp`.

## Examples
```jldoctest
julia> pp = PersonParameter(0.0, 1.0);

julia> value(pp)
0.0
```
"""
value(pp::PersonParameter) = pp.value

"""
    $(SIGNATURES)

Extract the standard error from a [`PersonParameter`](@ref) estimate `pp`.

## Examples
```jldoctest
julia> pp = PersonParameter(0.5, 0.3);

julia> se(pp)
0.3
```
"""
se(pp::PersonParameter) = pp.se

"""
    $(TYPEDEF)

A collection of estimated person parameters.

## Fields
$(FIELDS)

## Methods
- [`modeltype`](@ref): Get the model type of the scaling model
- [`algorithm`](@ref): Get the algorithm used for estimation
"""
struct PersonParameterResult{
    T<:ItemResponseModel,
    U<:PersonParameter,
    V<:PersonParameterAlgorithm,
} <: AbstractArray{U,1}
    "A vector of estimated person parameters"
    values::Vector{U}
    "The algorithm used for estimation"
    algorithm::V
end

Base.getindex(pp::PersonParameterResult, i) = getindex(pp.values, i)
Base.size(pp::PersonParameterResult) = size(pp.values)

"""
    $(SIGNATURES)

Get the scaling model used to calculate the person parameters in `pp`.

## Examples
```jldoctest
julia> pp = person_parameters(TwoPL, fill(zeros(3), 10), fill((a = 1.0, b = 0.0), 3), WLE());

julia> modeltype(pp)
TwoParameterLogisticModel
```
"""
modeltype(pp::PersonParameterResult{T,U,V}) where {T,U,V} = T

"""
    $(SIGNATURES)

Get the algorithm used to calculate the person parameters in `pp`.

## Examples
```jldoctest
julia> pp = person_parameters(OnePL, fill(zeros(3), 5), zeros(3), MLE());

julia> algorithm(pp)
MLE()
```
"""
algorithm(pp::PersonParameterResult) = pp.algorithm

"""
    $(SIGNATURES)

Estimate a single person parameter for an item response theory model `M` from a
response vector (`responses`) given item parameters `beta` and an estimation algorithm `alg`.

## Examples
### 1 Parameter Logistic Model
```jldoctest; filter = r"(\\d*)\\.(\\d{4})\\d+" => s"\\1.\\2***"
julia> responses = [0, 1, 1, 0, 0];

julia> betas = [0.2, -1.3, 0.4, 1.2, 0.0];

julia> person_parameter(OnePL, responses, betas, MLE())
PersonParameter{Float64}(-0.34640709530672537, 0.9812365857368596)
```

### 3 Parameter Logistic Model
```jldoctest; filter = r"(\\d*)\\.(\\d{4})\\d+" => s"\\1.\\2***"
julia> responses = [0, 1, 1];

julia> betas = [(a = 1.0, b = 0.3, c = 0.1), (a = 0.3, b = -0.5, c = 0.0), (a = 1.4, b = 1.1, c = 0.3)];

julia> person_parameter(ThreePL, responses, betas, WLE())
PersonParameter{Float64}(0.657715606325967, 1.5321777539977457)
```
"""
function person_parameter(
    M::Type{<:ItemResponseModel},
    responses,
    betas,
    alg::PPA;
    init::Real = 0.0,
    kwargs...,
)
    # missing value treatment
    nonmissings = @. !ismissing(responses)
    betas_nonmissing = view(betas, nonmissings)
    responses_nonmissing = view(responses, nonmissings)
    test_length = length(betas_nonmissing)
    score = sum(responses_nonmissing)

    # boundary estimates
    if !rational_bounds(alg)
        if score == 0
            return PersonParameter(-Inf, Inf)
        elseif score == test_length
            return PersonParameter(Inf, Inf)
        end
    end

    # optimization problem
    estimate = optimize(alg, M, betas_nonmissing, responses_nonmissing; init, kwargs...)
    return estimate
end

"""
    $(SIGNATURES)

Estimate person parameters for an item response theory model of type `M` given
item parameters `betas`, an estimation algorithm `alg` and `responses` for each person.

`responses` can be a vector of responses where each entry corresponds to the responses for
a person, or a response matrix with `size(responses) == (n, length(betas))`, i.e. each row
of the response matrix corresponds to the responses of a single person.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> responses = [1 1 0; 0 1 0; 1 1 0; 0 0 1]
4×3 Matrix{Int64}:
 1  1  0
 0  1  0
 1  1  0
 0  0  1

julia> betas = [-0.1, 0.0, 1.0];

julia> person_parameters(OnePL, responses, betas, MLE());
```
"""
function person_parameters(
    M::Type{<:ItemResponseModel},
    responses::AbstractVector,
    betas,
    alg::PPA,
)
    # patterns, ids = get_unique_response_patterns(responses)
    response_patterns = ResponsePatterns(responses)

    unique_thetas = Folds.map(patterns(response_patterns)) do ys
        return person_parameter(M, ys, betas, alg)
    end

    T = eltype(unique_thetas)
    thetas = Vector{T}(undef, length(responses))

    for (is, theta) in zip(ids(response_patterns), unique_thetas)
        for i in is
            thetas[i] = theta
        end
    end

    return PersonParameterResult{M,T,typeof(alg)}(thetas, alg)
end

function person_parameters(
    M::Type{<:ItemResponseModel},
    responses::AbstractMatrix,
    betas,
    alg,
)
    return person_parameters(M, eachrow(responses), betas, alg)
end

"""
    $(TYPEDEF)

A container holding a single estimated person parameter.

# Fields
$(FIELDS)
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
"""
value(pp::PersonParameter) = pp.value

"""
    $(SIGNATURES)

Extract the standard error from a [`PersonParameter`](@ref) estimate `pp`.
"""
se(pp::PersonParameter) = pp.se

"""
    $(TYPEDEF)

A collection of estimated person parameters.

# Fields
$(FIELDS)
"""
struct PersonParameterResult{
    T<:ItemResponseModel,
    U<:PersonParameter,
    V<:PersonParameterAlgorithm,
}
    "A vector of estimated person parameters"
    values::Vector{U}
    "The algorithm used for estimation"
    algorithm::V
end

Base.getindex(pp::PersonParameterResult, i) = getindex(pp.values, i)

"""
    $(SIGNATURES)

Get the scaling model used to calculate the person parameters in `pp`.
"""
modeltype(pp::PersonParameterResult{T,U,V}) where {T,U,V} = T

"""
    $(SIGNATURES)

Get the algorithm used to calculate the person parameters in `pp`.
"""
algorithm(pp::PersonParameterResult) = pp.algorithm

"""
    $(SIGNATURES)

Estimate the person parameter for an item response theory model (`modeltype`) from a
response vector (`responses`) given item parameters `beta` and an estimation algorithm `alg`.
"""
function person_parameter(
    modeltype::Type{<:ItemResponseModel},
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
    prob = ZeroProblem(
        x -> optfun(alg, modeltype, x, betas_nonmissing, responses_nonmissing),
        init,
    )
    theta = solve(prob, Order1(); kwargs...)

    standard_error = se(alg, modeltype, theta, betas)

    return PersonParameter(theta, standard_error)
end

"""
    $(SIGNATURES)
"""
function person_parameters(
    modeltype::Type{<:ItemResponseModel},
    responses::AbstractVector,
    betas,
    alg,
)
    patterns, ids = get_unique_response_patterns(responses)
    unique_thetas = [person_parameter(modeltype, ys, betas, alg) for ys in patterns]

    T = eltype(unique_thetas)
    thetas = Vector{T}(undef, length(responses))

    for (is, theta) in zip(ids, unique_thetas)
        for i in is
            thetas[i] = theta
        end
    end

    return PersonParameterResult{modeltype,T,typeof(alg)}(thetas, alg)
end

function person_parameters(
    modeltype::Type{<:ItemResponseModel},
    responses::AbstractMatrix,
    betas,
    alg,
)
    return person_parameters(modeltype, eachrow(responses), betas, alg)
end

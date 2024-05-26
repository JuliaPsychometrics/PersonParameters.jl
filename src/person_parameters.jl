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

Estimate the person parameter for an item response theory model (`modeltype`) from a
response vector (`responses`) given item parameters `beta` and an estimation algorithm `alg`.
"""
function person_parameter(modeltype, responses, betas, alg)
    I = length(betas)
    init_x = 0.0
    score = sum(skipmissing(responses))

    if !rational_bounds(alg)
        if score == 0
            return PersonParameter(-Inf, Inf)
        elseif score == I
            return PersonParameter(Inf, Inf)
        end
    end

    f = x -> optfun(alg, modeltype, x, betas, responses)
    theta = find_zero(f, init_x)

    standard_error = se(alg, modeltype, theta, betas)

    return PersonParameter(theta, standard_error)
end

"""
    $(SIGNATURES)
"""
function person_parameters(modeltype, responses, betas, alg)
    thetas = [person_parameter(modeltype, ys, betas, alg) for ys in responses]
    return PersonParameterResult{modeltype,eltype(thetas),typeof(alg)}(thetas, alg)
end

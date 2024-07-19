struct EAP{T<:Distribution{Univariate,Continuous},U<:Real} <: PPA
    prior::T
    domain::NTuple{2,U}
end

EAP(prior = Normal(); domain = extrema(prior)) = EAP(prior, domain)

rational_bounds(alg::EAP) = true

function optimize(alg::EAP, M::Type{<:ItemResponseModel}, betas, responses; init, kwargs...)
    @unpack domain, prior = alg

    # posterior expectation
    f(x) = likelihood(M, x, betas, responses) * pdf(prior, x) * x
    num = quadgk(f, domain...; kwargs...)
    g(x) = likelihood(M, x, betas, responses) * pdf(prior, x)
    denom = quadgk(g, domain...; kwargs...)
    theta = num[1] / denom[1]

    # posterior standard deviation
    h(x) = likelihood(M, x, betas, responses) * pdf(prior, x) * (x - theta)^2
    num = quadgk(h, domain...; kwargs...)
    standard_error = sqrt(num[1] / denom[1])
    return PersonParameter{typeof(theta)}(theta, standard_error)
end

"""
    PersonParameterMLE

Maximum likelihood estimation for person parameters of Rasch models
"""
struct MLE <: PersonParameterAlgorithm end

rational_bounds(::MLE) = false

function optfun(::MLE, T::Type{OneParameterLogisticModel}, theta, betas, r::Int)
    optvalue = zero(theta)

    for beta in betas
        optvalue += irf(T, theta, beta, 1)
    end

    return (r - 1) - optvalue
end

function se(::MLE, T::Type{OneParameterLogisticModel}, theta, betas)
    info = information(T, theta, betas)
    return sqrt(inv(info))
end

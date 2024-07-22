"""
    $(TYPEDEF)

Maximum likelihood estimation for person parameters of item response models.
"""
struct MLE <: PPA end

rational_bounds(alg::MLE) = false

function optfun(alg::MLE, M::Type{<:ItemResponseModel}, theta, betas, responses)
    f(x) = loglikelihood(M, x, betas, responses)
    optval = derivative(f, theta)
    return optval
end

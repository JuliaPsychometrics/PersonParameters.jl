"""
    $(TYPEDEF)

Maximum likelihood estimation for person parameters of item response models.
"""
struct MLE <: PPA end

rational_bounds(alg::MLE) = false

function optfun(alg::MLE, M::Type{<:ItemResponseModel}, theta, betas, responses)
    optval = derivative_loglik(M, theta, betas, responses)
    return optval
end

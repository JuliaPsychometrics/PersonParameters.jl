function get_unique_response_patterns(responses::AbstractVector)
    unique_patterns = unique(responses)
    id_map = [findall(x -> isequal(x, pattern), responses) for pattern in unique_patterns]
    return unique_patterns, id_map
end

function likelihood(M::Type{<:ItemResponseModel}, theta::Real, betas, responses)
    L = one(theta)
    for (beta, y) in zip(betas, responses)
        L *= irf(M, theta, beta, y)
    end
    return L
end

function loglik(M::Type{<:ItemResponseModel}, theta::Real, betas, responses)
    L = zero(theta)
    for (beta, y) in zip(betas, responses)
        L += log(irf(M, theta, beta, y))
    end
    return L
end

function derivative_loglik(M::Type{<:ItemResponseModel}, theta::Real, betas, responses)
    f(x) = loglik(M, x, betas, responses)
    return derivative(f, theta)
end

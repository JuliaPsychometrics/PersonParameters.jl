"""
    $(TYPEDEF)

A struct holding unique response patterns of a data matrix.
"""
struct ResponsePatterns{T<:AbstractVector}
    patterns::T
    id_map::Vector{Vector{Int}}
end

function ResponsePatterns(data)
    patterns, ids = get_unique_response_patterns(data)
    return ResponsePatterns(patterns, ids)
end

function get_unique_response_patterns(responses::AbstractVector)
    unique_patterns = unique(responses)
    id_map = [findall(x -> isequal(x, pattern), responses) for pattern in unique_patterns]
    return unique_patterns, id_map
end

function get_unique_response_patterns(responses::AbstractMatrix)
    return get_unique_response_patterns(eachrow(responses))
end

"""
    $(SIGNATURES)

Get the number of unique response patterns in `p`.
"""
Base.length(p::ResponsePatterns) = length(p.patterns)

"""
    $(SIGNATURES)

Get the unique response patterns from `p`.
"""
patterns(p::ResponsePatterns) = p.patterns

"""
    $(SIGNATURES)

Get the id mapping for the response patterns in `p`
"""
ids(p::ResponsePatterns) = p.id_map

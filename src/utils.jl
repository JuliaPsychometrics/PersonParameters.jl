function get_unique_response_patterns(responses::AbstractVector)
    unique_patterns = unique(responses)
    id_map = [findall(x -> isequal(x, pattern), responses) for pattern in unique_patterns]
    return unique_patterns, id_map
end

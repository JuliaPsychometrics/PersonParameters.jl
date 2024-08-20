@testset "ResponsePatterns" begin
    x = [[0, 1, 0], [1, 1, 0], [0, 0, 0]]
    rp = ResponsePatterns(x)
    @test get_unique_response_patterns(x)[1] == x
    @test get_unique_response_patterns(x)[2] == [[1], [2], [3]]
    @test patterns(rp) == x
    @test ids(rp) == [[1], [2], [3]]
    @test length(rp) == 3

    x = [[1, 1, 1], [1, 1, 1], [0, 1, 0], [0, 0, 0]]
    rp = ResponsePatterns(x)
    @test get_unique_response_patterns(x)[1] == [[1, 1, 1], [0, 1, 0], [0, 0, 0]]
    @test get_unique_response_patterns(x)[2] == [[1, 2], [3], [4]]
    @test patterns(rp) == [[1, 1, 1], [0, 1, 0], [0, 0, 0]]
    @test ids(rp) == [[1, 2], [3], [4]]
    @test length(rp) == 3

    x = [[1, 1, 1], [1, missing, 0], [1, 1, 1], [1, missing, 0]]
    rp = ResponsePatterns(x)
    @test isequal(get_unique_response_patterns(x)[1], [[1, 1, 1], [1, missing, 0]])
    @test get_unique_response_patterns(x)[2] == [[1, 3], [2, 4]]
    @test isequal(patterns(rp), [[1, 1, 1], [1, missing, 0]])
    @test ids(rp) == [[1, 3], [2, 4]]
    @test length(rp) == 2

    srp = ResponsePatterns(stack(x, dims = 1))
    @test isequal(patterns(rp), patterns(srp))
    @test isequal(ids(rp), ids(srp))
end

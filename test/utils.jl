@testset "utils" begin
    @testset "get_unique_response_patterns" begin
        x = [[0, 1, 0], [1, 1, 0], [0, 0, 0]]
        @test get_unique_response_patterns(x)[1] == x
        @test get_unique_response_patterns(x)[2] == [[1], [2], [3]]

        x = [[1, 1, 1], [1, 1, 1], [0, 1, 0], [0, 0, 0]]
        @test get_unique_response_patterns(x)[1] == [[1, 1, 1], [0, 1, 0], [0, 0, 0]]
        @test get_unique_response_patterns(x)[2] == [[1, 2], [3], [4]]

        x = [[1, 1, 1], [1, missing, 0], [1, 1, 1], [1, missing, 0]]
        @test isequal(get_unique_response_patterns(x)[1], [[1, 1, 1], [1, missing, 0]])
        @test get_unique_response_patterns(x)[2] == [[1, 3], [2, 4]]
    end
end

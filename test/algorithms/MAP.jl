@testset "MAP" begin
    @test rational_bounds(MAP()) == true
    @test MAP().prior == Normal()

    prior = Uniform(-1, 1)
    alg = MAP(prior)
    @test alg.prior == prior
end

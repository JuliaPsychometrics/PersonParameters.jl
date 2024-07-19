@testset "EAP" begin
    @test rational_bounds(EAP()) == true
    @test EAP().prior == Normal()
    @test EAP().domain == (-Inf, Inf)

    @test EAP(Uniform(0, 1)).prior == Uniform(0, 1)
    @test EAP(Uniform(0, 1)).domain == (0, 1)
end

# Treatment of missing values
In PersonParameters.jl `missing` values are ignored in estimation of the person ability. Hence, `missing` is treated as if the test-taker was never exposed to the item.
In classical testing this can arise, for example, due to [structural missing values](https://en.wikipedia.org/wiki/Missing_data#Structured_Missingness) by means of the test design.

By definition `missing` data should have no influence on the estimation of the person abilitiy. We can easily verify this property,

```@example missing-values
using Random  # hide
Random.seed!(90345)  # hide
using PersonParameters 

betas = randn(10)
y = rand([0, 1, missing], 10)
```

```@example missing-values
theta_missing = person_parameter(OnePL, y, betas, MLE())
```

```@example missing-values
nonmissing = @. !ismissing(y)
theta_complete = person_parameter(OnePL, y[nonmissing], betas[nonmissing], MLE())
```

Omitting items with `missing` responses leads to the same ability estimate.

```@example missing-values
theta_missing == theta_complete
```


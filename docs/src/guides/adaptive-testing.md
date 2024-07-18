# Online estimation of ability in adaptive testing
In [adaptive testing](https://en.wikipedia.org/wiki/Computerized_adaptive_testing) the updating of the ability estimate plays a central role. 
Generally, adaptive testing consists of the following steps:

1. Select an optimal item from an item pool given the current ability estimate of the test-taker
2. Present the item and await the response of the test-taker
3. Update the ability estimate of the test-taker given the new responses 

Additionally we need to provide an inital ability estimate for the test-taker before the first item is responded to.
Also a stopping criterion is required to terminate the test when the criterion is met. 

In this guide we are going to implement a simple adaptive test using PersonParameters.jl to update the ability values in step 3 of the testing procedure.

## Preparation
### Setting up the item pool
To keep things simple our item pool will consist of 100 items with item parameters given by a Rasch model. 
We draw the item difficulty values from a standard normal distribution.

```@example adaptive-testing
using Random  # hide
Random.seed!(7537)  # hide
item_pool = randn(100)
```

### Defining the item selection procedure
Next, we need to define a function to select the optimal item (step 1). 
In adaptive testing this is usually the item that maximises the item information given the current ability estimate.

Therefore we need a function that takes the `item_pool` and current ability estimate `theta` as inputs, calculates the information for each item in `item_pool` at `theta` and returns the id of the item with maximum information.

Information functions for the Rasch model are available in [`ItemResponseFunctions.jl`](https://github.com/JuliaPsychometrics/ItemResponseFunctions.jl).

```@example adaptive-testing
using ItemResponseFunctions: OnePL, information

function select_item(item_pool, theta)
    infos = [information(OnePL, theta, beta) for beta in item_pool]
    return argmax(infos)
end
```

::: warning

For simplicity items are selected with replacement from the item pool. 

In a real-world application one would prefer to track the exposed items and only select items that weren't previously exposed to the test-taker.

:::

Calling the function at `theta = 0.0` returns a valid item id.

```@example adaptive-testing
select_item(item_pool, 0.0)
```

### Defining the stopping criterion
Our stopping criterion in this example is also based on the ability estimate. 
The test should only be stopped if the accuracy of the estimate is higher than a predefined threshold.
In other words: We stop the test only if the standard error of the ability estimate is below `threshold`.

The stopping criterion returns `false` if the criterion is not met, meaning the test continues and a new item is selected.
If the stopping criterion is met, `true` is returned and the test is stopped.

```@example adaptive-testing
using PersonParameters: PersonParameter, se

function stop(estimate::PersonParameter; threshold = 0.5)
    return se(estimate) < threshold
end
```

A small test confirms the stopping rule works as intended.

```@example adaptive-testing
stop(PersonParameter(0.0, 0.6))  # should return false 
```

```@example adaptive-testing
stop(PersonParameter(0.0, 0.2))  # should return true
```

## Implementing the test logic
Now that the item selection and stopping criterion are defined, we can move on to code the test logic.
Recall that we must 

1. Await the response of the test-taker,
2. Update the ability value given the new response,
3. Evaluate the stopping rule and either present the next item to the test-taker according to `select_item`, or stop the test.

Also we likely want to store responses, administered items, and intermediate ability values like so.

```@example adaptive-testing
responses = Int[]
estimates = [PersonParameter(0.0, Inf)]
items = [rand(eachindex(item_pool))]
```

::: note

The objects `estimates` and `items` already include initial values.
For the ability estimate the initial value was fixed at `0.0`.
For the initial item a random item was chosen from the item pool.

::: 

The following function `update` implements the test logic as described above.
It makes use of [`Observables.jl`](https://github.com/JuliaGizmos/Observables.jl), running every time a new `response` is observed.

```@example adaptive-testing
using Observables: Observable, on
using PersonParameters: person_parameter, value, WLE

response = Observable(0)
is_stopped = Observable(false)

update = on(response) do y
    if !is_stopped[]
        push!(responses, y)
        @info "new response: y = $y"

        theta = person_parameter(OnePL, responses, item_pool[items], WLE())
        push!(estimates, theta)
        @info "new ability estimate: theta = $(value(theta)), se = $(se(theta))"

        if stop(theta)
            @info "stopping criterion reached: se = $(se(theta)) < 0.5"
            is_stopped[] = true
        else
            @info "stopping criterion not reached: se = $(se(theta)) > 0.5"
            new_item = select_item(item_pool, value(theta))
            push!(items, new_item)
            @info "current item: $(new_item)"
            return new_item
        end
    end
end

nothing  # hide
```

### Step-by-step explanation
The first part of the implementation is to define our observables. 
On one hand we need an observable for new responses, `response`. The test logic will run whenever `response` is updated.

On the other hand we need an observable to tell us if the test is active or stopped according to our stoppping rule.
The observable `is_stopped` tells us exactly that.

```julia
response = Observable(0)
is_stopped = Observable(false)
```

The function `update` contains the updating procedure once a new response is observed. 
It will run always if `response` is updated and the test is not stopped, c.f. `is_stopped[] == false`.

```julia
update = on(response) do y
    if !is_stopped[]
        # ...
    end
end
```

Within `update` the steps described above are executed.
First, we commit the new response to storage

```julia
update = on(response) do y
    if !is_stopped[]
        push!(responses, y) # [!code highlight]
        # ...
end
```

Then the new ability is estimated using [`person_parameter`](@ref) and also commited to storage.
For adaptive testing purposes we choose the [`WLE`](@ref) algorithm, since it provides ability estimates even if all responses are 0 or 1 respectively.

```julia
update = on(response) do y
    if !is_stopped[]
        push!(responses, y)

        theta = person_parameter(OnePL, responses, item_pool[items], WLE())  # [!code highlight]
        push!(estimates, value(theta))  # [!code highlight]
        # ...
    end
end
```

Finally the stopping criterion is evaluated. 
If it is reached, the test is terminated by setting `is_stopped[] = true`.
Otherwise, a new item is selected by `select_item`, commited to storage and provided to the test-taker.

```julia
update = on(response) do y
    if !is_stopped[]
        push!(responses, y)

        theta = person_parameter(OnePL, responses, item_pool[items], WLE())
        push!(estimates, value(theta))

        if stop(theta) # [!code highlight]
            is_stopped[] = true # [!code highlight]
        else # [!code highlight]
            new_item = select_item(item_pool, value(theta)) # [!code highlight]
            push!(items, new_item) # [!code highlight]
            return new_item # [!code highlight]
        end # [!code highlight]
    end
end
```

::: info

In the original definition of `update` `@info` statements are placed throughout for logging purposes.

:::

## Administering the test
With all our test logic in place we can administer the test to a virtual test-taker. 
We assume that the test taker has a true ability and their response follows the Rasch model. 
Thus, we can define a `respond` function that gives us a random response to the item, given the expected probability of a correct response under the Rasch model.

```@example adaptive-testing
using Distributions: Bernoulli
using ItemResponseFunctions: irf

function respond(beta; true_theta = 0.0)
    prob = irf(OnePL, true_theta, beta, 1)
    return Int(rand(Bernoulli(prob)))
end
```

The virtual test-taker then responds to the administered items until the stopping criterion is met.

```@example adaptive-testing
while !is_stopped[]
    # get the item difficulty
    current_item = last(items)
    beta = item_pool[current_item]
    # respond
    response[] = respond(beta)
end
```

As is evident from the logging statements, the test stops after 18 items have been administered.
The final estimate is about `-0.09` with a standard error of `0.49`.

```@example adaptive-testing
last(estimates)
```

The following table contains all tracked data from the virtual test.

```@example adaptive-testing
using MarkdownTables

init = (; step = 0, item = "", response = "", estimate = value(estimates[1]), se = se(estimates[1]))
data = [(; 
    step = i, 
    item = items[i], 
    response = responses[i], 
    estimate = value(estimates[i + 1]), 
    se = se(estimates[i + 1])
) for i in eachindex(items)]

markdown_table(vcat(init, data))
```

## Additional information
```@example adaptive-testing
using Pkg
Pkg.status()
```

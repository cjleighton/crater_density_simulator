# Final Project for ASTR 3750 - Planets, Moons, and Rings
If you know the rate of meteoritic deposition on a celestial body and look at the density of craters on its surface, you can get some rough bounds on how old that surface region is. However, as the entire surface eventually becomes saturated with craters, old craters start getting erased. With that in mind, this project basically investigated:
* What's a robust way of counting the number of craters in a region, given that some of them have been partially or completely erased?
* What's the maximum number of craters that can be in a region and still be counted as not having been erased?
* How do crater sizes realistically vary, i.e. what's the distribution of crater sizes and how does that influence the above questions?

To answer those questions, this project simulates a 500 by 500 km area that gets covered with craters over time and counts how many craters it thinks are still on the surface and haven't been erased. Plots going over the results can be found in `Chris_Leighton_ASTR_3750_Project.pdf`. Unfortunately, that paper doesn't make a lot of sense without the original assignment we were given, which I don't have access to anymore. Fortunately, this project isn't important and I doubt anyone will ever look at it in detail.
## Running
`main.m` will run the simulation.

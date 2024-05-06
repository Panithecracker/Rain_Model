# Raindrops-Model
This project aims to model rain and the dynamics of the raindrops once they land on a pond. I decided it was an interesting physical phenomena where I could exploit some of the knowledge gained thorughout my learning on stochastic processes and differential equations, making a basic computer simulated model.
# Stochastic component of the model 
# How is the rain modeled? 
First of all, I let $N(t)$ be the number of droplets that have fallen after $t$ units of time and $`\{N(t),t>=0\}`$ be a Poisson process with rate $\lambda$ droplets per unit of time. 
From this, it follows that $N(T) \sim POISSON(\lambda T)$. 
Another important consequence I used is that if $N(T) = n$ ,then the conditional distribution of the waiting times for each of the drops $S_1,...,S_n$ is like the distribution of the $n$-order statistics of $n$ iid $U(0,T)$ rvs. More precisely : $(S_1,...,S_n)|(N(T) = n)$ has the same distribution as  $(Y^1,...,Y^n)$ where $Y_i \sim U(0,T)$
Secondly, the location of an arbitrary drop is assumed to be a random vector: $(X,Y) \sim U(-l,l)*U(-l,l)$ where $2l$ is the length of the square grid where the raining simulation takes place.
# Differential equations component of the model
# Dynamics of the water particles around a hitting point:
# Once a drop hits the water, how do the water particles around move?
To give an answer to this question, I tried to capture the intuition and empirical observation from the real world into a more analytical description in the following manner:
The idea is that once a droplet hits the pond, the water particles that are at a distance $\epsilon$ away from the hitting position will be accelerated from rest with the maximum force right at that instant. From then on, these guys will all move in different directions away at a common velocity,whose rate of change (acceleration) will stay positive on the beginning but decreasing due to the short resistance offered by the time exponential contribution of the initial impact and counter force exerted in the opposite direction due to the water resistance.For this reason, at some later instant there will be no curvature and and the particle will be travelling at its maximum velocity. From then, the acceleration will become negative until the velocity goes to 0 from above, and the particle will be barely moving , approaching a limit displacement. To be more exact, the straight line distance from the hitting point to a nearby particle will obey the equation:
$R''(t) = Aexp(-t) -\mu R'(t)$ with $R(0) = \epsilon$ and $R'(0) = 0$. Here $A > 0$ is the maximum acceleration which happens at $t = 0$ and $\mu >0$ is the drag coefficient. This is a first order linear drag model with a time exponential forcing, for the radial velocity $R'$. I also explored the dynamics of the model using other equations (same initial conditions) with very similar qualitative and quantitative results such as the nonlinear equation $R''(t) = 1/R(t) -\mu R'(t)$. However, they gave no more significant differences in the simulations and they suffer from the flaw of having no closed form solution, which meant more time consuming for the computer to previously approximate their solutions nummerically. The advantage of the linear drag model is that I could solve it analytically. The solution of the linear equation problem is then:
$R(t) = \epsilon + \dfrac{A}{\mu}+\dfrac{A}{1-\mu}*(exp(-t)-\dfrac{exp(-\mu t)}{\mu})$






# Example: INTENSE RAIN 
The following results uses $\lambda = 15$ drops per unit of time for the stochastic raining process , $A =1, \mu = 1.8$
It could serve as a decent way to simulate an intense rain during a storm.

https://github.com/Panithecracker/Raindrops-Model/assets/97905110/d31e4699-38d4-478b-b896-fdcb7344849e

![Intense_counts](https://github.com/Panithecracker/Raindrops-Model/assets/97905110/607e529e-782d-4c48-b8eb-8a414c1fc7f5)

![Intense_positions](https://github.com/Panithecracker/Raindrops-Model/assets/97905110/a8613534-5f44-40d5-8056-d70ffd5b87dc)

# Example: STARTING RAIN
The following case uses $\lambda = 3$ droplets per unit of time for the stochastic raining process, $A = 1, \mu = 1.8$
It could immitate the dynamics of a just started rain, where some few drops start hitting the ground with some longer pauses in between different to the above case, which could be the later behaviour

https://github.com/Panithecracker/Raindrops-Model/assets/97905110/645b6849-3f40-4db1-9541-f41558f87246

![StartingRain_counts](https://github.com/Panithecracker/Raindrops-Model/assets/97905110/802745a6-68be-4016-bcda-bd0ed7c4ac24)
![StartingRain_positions](https://github.com/Panithecracker/Raindrops-Model/assets/97905110/125eb1b1-1ed8-4b8f-b36c-ef16f958e151)






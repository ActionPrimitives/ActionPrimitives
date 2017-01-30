Action primitives demo by anonymous.

The demo shows the generation of primitive actions such as lifting a leg, lifting an arm, turning the head, bending both legs, etc. according to the analysis of the flux done on the MoCap data collected from Human3.6M. Here only the generation of actions is shown and not their recognition and denotation using the descriptors.

Data needed by the demo have been precomputed and stored in the file Data.mat. 
The whole computation will be available on this website once the paper describing the formal method and algorithms is published.

To launch the demo clone this repository of size 1.915KB into a folder of your working Matlab.

The demo will automatically extracts the skeleton groups and the primitives for each group, according to their joints motion flux.

What you will see:

1. Skeleton absolute poses and flux graphs of the groups. For visual clarity only primitives of two of the defined skeleton groups are highlighted: the right arm and the right leg.
2. The colors of the skeleton links of the highlighted group changes when a new primitive is discovered. Note that because no recognition is done at this stage, same colors are not associated with same primitive.
3. Flux graphs for the shown groups, located on the right of the primitive action frames get colored in parallel with the new primitives discovered. The x-axis corresponds to the geodesic distance of the curve on the manifold.


 Tested on Matlab 2015a and Matlab 2015b.

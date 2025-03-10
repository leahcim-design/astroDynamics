# astroDynamics


## What is this project about?
This project is a simulation framework to simulate the celestial dynamic of suns, planets, moons and asteroids. 
The existing classes are designed to make them easy to use and easy to add further functionality, e.g. bodies with internal structure or deformable bodys to properly simulate tidal effects.

The current project does not include any relativistic effects, it only uses Newton's gravitational law (https://en.wikipedia.org/wiki/Newton%27s_law_of_universal_gravitation). 

## Explanation of the Architecture
All classes that represent celestial bodies with mass must inherit from the MassiveBodyInterface. Additionally, there must be a class to store changes in the dynamic properties for every massive body that inherits from the MassiveBodyDeltaInterface class. If these rules are followed, instances of different MassiveBody-classes can be used to form one Universe, which is a class that combines multiple massive bodies. The UniverseSimulation class is used to time-propagate a universe. 
In the following, a short explanation of the different classes is given.

### MassiveBodyInterface
This is an abstract class that represents the basis for all celestial bodies with mass. All classes that represent a massive body must inherit from this interface.

### MassiveBodyDeltaInterface
This is an abstract class that represents the basic structure of a data-container to store the change of the dynamic properties of the corresponding massive body. For example, this would be the change in the center-of-mass position and the change in the center-of-mass velocity in the case of a point-mass like body. More complex bodies with internal structure could also have additional dynamic property-changes like angle-change gier-rate-change. 

### MassiveSphere
This class inherits from the MassiveBodyInterface. It represents a model of a spherical body. The radius, mass, density and the generated force-density are those of a mass sphere. The time-propagation is calculated as if the whole mass where centered in the center-of-mass in order to speed up calculations. In that sense this is a combination of an actual mass sphere and a point mass.

### MassiveSphereDelta
This class inherits from the MassiveBodyDeltaInterface. It is the container for changes in the position and velocity of MassiveSphere objects.

### Universe
The Universe class is a container for multiple MassiveBody classes. It also provides a runge-kutta-4 time propagator and a plotting method. 

### UniverseDelta
This class serves as a container for changes of the dynamical properties of all massive bodies in the corrseponding Universe. 

### UniverseSimulation
The UniverseSimulation class can time-propagate a Universe-instance and hold the generated time-slices in memory. It also provides different plotting methods, for example to plot the orbital curves of its massive bodies. 

## CI/CD
This project contains a pipeline for GitHub in the folder .github/workflows. As there is no direct Matlab support on GitLab it was decided to mirror the project into a public repository in GitHub to use its Matlab-support. The pipeline.runs can be found here: https://github.com/leahcim-design/astroDynamics/actions/workflows/matlab-pipeline.yml .

The pipeline runs all Matlab-tests. All files that bear the "test" label count as test for the pipeline. The results of the test-stage are published as artifacts. For convenience the result of the latest run are checked into this repository in the folder "artifactsFromGithub".
Additionally the pipeline has a simulation stage that can execute simulations and publish the generated outputs as artifacts. For convenience the results of the latest runf are checked into this repo in the "simulations/simulationResults" folder. 

## simulations
This project includes simulations of celestial bodis of our solar system. The results of the simulations can be found in the folder "simulations/simulationResults". 
- sunEarthMoonSimulation: this is a simulation of the Sun, Earth and the earth Moon over the course of one earth-year
- sunEarthJupiterGallileanMoonsSimulation: this is a simulation of the Sun, Earth, Jupiter and the Gallilean moons Io, Ganymede, Kallisto and Europa over the course of one earth-year
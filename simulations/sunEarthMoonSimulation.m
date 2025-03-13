
% this script simulates the movement of the sun, earth and the moon over
% the course of one earth-year
% note that the gravitational constant is set to 1! hence the mass-unit
% must be adjusted when setting the simulation-parameters
% all other simulation parameters use SI-units!

name = "sunEarthMoon_oneYear";

gravSI = 6.6743*10^-11; %gravitational constant

%time-step dT and end-time of the simulation
dT = 1 * 60 * 60; 
startTime = 0;
endTime = 1 * 365 * 24 * 60 * 60 ;

%initialize factory for celestial bodies in the solar system
myFactory = SolarSystemFactory();

%initialize the universe at time t=0
initialUniverse = Universe(...
    myFactory.createSun, ...
    myFactory.createEarth, ...
    myFactory.createMoon);

%run the simulation
myUniverseSimulation = UniverseSimulation();
myUniverseSimulation = myUniverseSimulation.runSimulation(initialUniverse, startTime,dT, endTime);

%plot and save the calculated celestial movement
close all;
fig = figure;
myUniverseSimulation.plot();
proj = currentProject;
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,".fig")));
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,".png")));

xlim([0.8 * 152.1 * 10^9, (1.1 * 152.1 * 10^9 + 0.3844 * 10^9)]);
ylim([(-1.1)* 0.3844 * 10^9, 0.51 * 152.1 * 10^9]);
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,"_zoom.png")));
close all;
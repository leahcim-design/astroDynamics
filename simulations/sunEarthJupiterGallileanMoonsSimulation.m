
% this script simulates the movement of the sun,earth jupiter and its 
% Gallilean moons over the course of one earth-year

name = "sunEarthJupiterGallileanMoons_oneYear";

gravSI = 6.6743*10^-11; %gravitational constant

%time-step dT and end-time of the simulation
dT = 1 * 60 * 60 ; 
startTime = 0;
endTime = 1 * 365 * 24 * 60 * 60 ;

%initialize factory for celestial bodies in the solar system
myFactory = SolarSystemFactory();

%initialize the universe at time t=0
initialUniverse = Universe(...
    myFactory.createSun, ...
    myFactory.createEarth, ...
    myFactory.createJupiter,...
    myFactory.createIo, ...
    myFactory.createGanymede, ...
    myFactory.createKallisto, ...
    myFactory.createEuropa);

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

xlim([6.18 * 10^11, 6.34 * 10^11]);
ylim([3.77 * 10^11, 3.93 * 10^11]);
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,"_zoom.png")));
close all;
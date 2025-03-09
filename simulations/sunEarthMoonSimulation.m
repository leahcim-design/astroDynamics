
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
endTime = 2 * 365 * 24 * 60 * 60 ;

%add sun
iniPosXsun = 0;
iniPosYsun = 0;
iniVelXsun = 0;
iniVelYsun = 0;
massSun = 1.989 * 10^30 * gravSI;
densitySun = 1.408 * 10^3 * gravSI;
massSphereSun = SphericalMass(iniPosXsun, iniPosYsun, iniVelXsun, iniVelYsun, massSun, densitySun);

%add earth
iniPosXearth = 152.1 * 10^9;
iniPosYearth = 0;
iniVelXearth = 0;
iniVelYearth = 29290;
massEarth = 5.9722 * 10^24 * gravSI;
densityEarth =  5.51 * 10^3 * gravSI; 
massSphereEarth = SphericalMass(iniPosXearth, iniPosYearth, iniVelXearth, iniVelYearth, massEarth, densityEarth);

%add moon
deltaXEarthMoon = 0.3844 * 10^9;
iniPosXmoon = iniPosXearth + deltaXEarthMoon;
iniPosYmoon = 0;
iniVelXmoon = 0;
iniVelYmoon = iniVelYearth + 1100;
massMoon = 7.346 * 10^22 * gravSI;
densityMoon = 5.51 * 10^3 * gravSI;
massSphereMoon = SphericalMass(iniPosXmoon, iniPosYmoon, iniVelXmoon, iniVelYmoon, massMoon, densityMoon);

%initialize the universe at time t=0
initialUniverse = Universe(massSphereSun, massSphereEarth, massSphereMoon);

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

xlim([0.8*iniPosXearth, (iniPosXearth + 1.1*deltaXEarthMoon)]);
ylim([(-1.1)* deltaXEarthMoon, 0.51*iniPosXearth]);
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,"_zoom.png")));
close all;
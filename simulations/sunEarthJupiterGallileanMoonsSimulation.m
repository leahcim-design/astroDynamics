
% this script simulates the movement of the sun,earth jupiter and its 
% Gallilean moons over the course of one earth-year
% note that the gravitational constant is set to 1! hence the mass-unit
% must be adjusted when setting the simulation-parameters
% all other simulation parameters use SI-units!

name = "sunEarthJupiterGallileanMoons_oneYear";

gravSI = 6.6743*10^-11; %gravitational constant

%time-step dT and end-time of the simulation
dT = 1 * 60 * 60 ; 
startTime = 0;
endTime = 1 * 365 * 24 * 60 * 60 ;

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

%add jupiter
iniPosXjupiter = 5.458 * abs(iniPosXearth);
iniPosYjupiter = 0;
iniVelXjupiter = 0;
iniVelYjupiter = 13069;
massJupiter =  1.89813 * 10^27 * gravSI;
densityJupiter = 1.33 * 10^3 * gravSI;
massSphereJupiter = SphericalMass(iniPosXjupiter, iniPosYjupiter, iniVelXjupiter, iniVelYjupiter, massJupiter, densityJupiter);

%add Io
iniPosXio = abs(iniPosXjupiter) + 0.4218 * 10^9;
iniPosYio = 0;
iniVelXio = 0;
iniVelYio = iniVelYjupiter + 17334;
massIo = 8.93193797 * 10^22 * gravSI;
densityIo = 3.528 * 10^3 * gravSI;
massSphereIo = SphericalMass(iniPosXio, iniPosYio, iniVelXio, iniVelYio, massIo, densityIo);

%add Ganymede
iniPosXganymede = abs(iniPosXjupiter) + 1.0715 * 10^9;
iniPosYganymede = 0;
iniVelXganymede = 0;
iniVelYganymede = iniVelYjupiter + 10880;
massGanymede = 1.4819 * 10^23 * gravSI;
densityGanymede = 1.936 * 10^3 * gravSI;
massSphereGanymede = SphericalMass(iniPosXganymede, iniPosYganymede, iniVelXganymede, iniVelYganymede, massGanymede, densityGanymede);

%add Kallisto
iniPosXkallisto = abs(iniPosXjupiter) + 1.8959 * 10^9;
iniPosYkallisto = 0;
iniVelXkallisto = 0;
iniVelYkallisto = iniVelYjupiter + 8200;
massKallisto = 1.0759 * 10^23 * gravSI;
densityKallisto = 1.830 * 10^3 * gravSI;
massSphereKallisto = SphericalMass(iniPosXkallisto, iniPosYkallisto, iniVelXkallisto, iniVelYkallisto, massKallisto, densityKallisto);

%add Europa
iniPosXeuropa = abs(iniPosXjupiter) + 0.6771 * 10^9;
iniPosYeuropa = 0;
iniVelXeuropa = 0;
iniVelYeuropa = iniVelYjupiter + 13740;
massEuropa = 4.8 * 10^22 * gravSI;
densityEuropa = 3.01 * 10^3 * gravSI;
massSphereEuropa = SphericalMass(iniPosXeuropa, iniPosYeuropa, iniVelXeuropa, iniVelYeuropa, massEuropa, densityEuropa);

%initialize the universe at time t=0
initialUniverse = Universe(massSphereSun, massSphereEarth, massSphereJupiter,...
    massSphereIo, massSphereGanymede, massSphereKallisto, massSphereEuropa);

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

xlim([8.26 * 10^11, 8.34 * 10^11]);
ylim([0, 2.5 * 10^10]);
saveas(fig, fullfile(proj.RootFolder,"simulations","simulationResults",strcat(name,"_zoom.png")));
close all;
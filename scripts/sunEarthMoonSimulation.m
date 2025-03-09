
% this script simulates the movement of the sun, earth and the moon over
% the course of one earth-year

gravSI = 6.6743*10^-11;

dT = 1 * 60 * 60;
endTime = 1 * 365 * 24 * 60 * 60 ;

%add sun
iniPosXsun = 0;
iniPosYsun = 0;
iniVelXsun = 0;
iniVelYsun = 0;
massSun = 2 * 10^30 * gravSI;
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
iniPosXmoon = iniPosXearth + 0.3844 * 10^9;
iniPosYmoon = 0;
iniVelXmoon = 0;
iniVelYmoon = iniVelYearth + 1100;
massMoon = 7.346 * 10^22 * gravSI;
densityMoon = 5.51 * 10^3 * gravSI;
massSphereMoon = SphericalMass(iniPosXmoon, iniPosYmoon, iniVelXmoon, iniVelYmoon, massMoon, densityMoon);

myUniverse = Universe(massSphereSun, massSphereEarth, massSphereMoon);

myUniverseSimulation = UniverseSimulation();
myUniverseSimulation = myUniverseSimulation.runSimulation(myUniverse, 0,dT, endTime);
%myUniverseSimulation.plotFrames(10, [(-1) * iniPosXearth,iniPosXearth],[(-1)* iniPosXearth,iniPosXearth]);
figure;
myUniverseSimulation.plot();
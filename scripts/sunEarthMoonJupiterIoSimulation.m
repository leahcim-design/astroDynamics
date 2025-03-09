
gravSI = 6.6743*10^-11;

dT = 1 * 60 * 60 / 5;
endTime = 1 * 365 * 24 * 60 * 60;

%add sun
iniPosXsun = 0;
iniPosYsun = 0;
iniVelXsun = 0;
iniVelYsun = 0;
massSun = 2 * 10^30 * gravSI;
densitySun = 1.408 * 10^3 * gravSI;
massSphereSun = SphericalMass(iniPosXsun, iniPosYsun, iniVelXsun, iniVelYsun, massSun, densitySun);

%add earth
iniPosXearth = 149 * 10^9;
iniPosYearth = 0;
iniVelXearth = 0;
iniVelYearth = 29784.8;
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

%add jupiter
iniPosXjupiter = 5.458 * abs(iniPosXearth);
iniPosYjupiter = 0;
iniVelXjupiter = 0;
iniVelYjupiter = 13069;
massJupiter =  1.89813 * 10^27 * gravSI;
densityJupiter = 1.33 * 10^3 * gravSI;
massSphereJupiter = SphericalMass(iniPosXjupiter, iniPosYjupiter, iniVelXjupiter, iniVelYjupiter, massJupiter, densityJupiter);


%add io
iniPosXio = abs(iniPosXjupiter) + 0.4218 * 10^9;
iniPosYio = 0;
iniVelXio = 0;
iniVelYio = 17339.75;
massIo = 8.93193797 * 10^22 * gravSI;
densityIo = 3.528 * 10^3 * gravSI;
massSphereIo = SphericalMass(iniPosXio, iniPosYio, iniVelXio, iniVelYio, massIo, densityIo);

myUniverse = Universe(massSphereSun, massSphereMoon, massSphereEarth, massSphereJupiter, massSphereIo);

myUniverseSimulation = UniverseSimulation();
myUniverseSimulation = myUniverseSimulation.runSimulation(myUniverse, 0,dT, endTime);
myUniverseSimulation.plotFrames(10, [(-1) * iniPosXjupiter,iniPosXjupiter],[(-1)* iniPosXjupiter,iniPosXjupiter]);
figure;
myUniverseSimulation.plot();
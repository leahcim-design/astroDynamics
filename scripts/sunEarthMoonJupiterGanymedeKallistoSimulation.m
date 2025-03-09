
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

%add jupiter
iniPosXjupiter = 5.458 * abs(iniPosXearth);
iniPosYjupiter = 0;
iniVelXjupiter = 0;
iniVelYjupiter = 13069;
massJupiter =  1.89813 * 10^27 * gravSI;
densityJupiter = 1.33 * 10^3 * gravSI;
massSphereJupiter = SphericalMass(iniPosXjupiter, iniPosYjupiter, iniVelXjupiter, iniVelYjupiter, massJupiter, densityJupiter);


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
massSphereEuropa = SphericalMass(iniPosXganymede, iniPosYganymede, iniVelXganymede, iniVelYganymede, massGanymede, densityGanymede);

myUniverse = Universe(massSphereSun, massSphereMoon, massSphereEarth, massSphereJupiter, massSphereEuropa, massSphereGanymede, massSphereKallisto);

myUniverseSimulation = UniverseSimulation();
myUniverseSimulation = myUniverseSimulation.runSimulation(myUniverse, 0,dT, endTime);
myUniverseSimulation.plotFrames(10, [(-1) * iniPosXjupiter,iniPosXjupiter],[(-1)* iniPosXjupiter,iniPosXjupiter]);
figure;
myUniverseSimulation.plot();
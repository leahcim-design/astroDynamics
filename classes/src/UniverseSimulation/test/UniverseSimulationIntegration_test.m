classdef UniverseSimulationIntegration_test < matlab.unittest.TestCase
    %UNIVERSESIMULATIONINTEGRATION_TEST 
    
    properties (SetAccess = private)
        geometricTolerance = 10^-5;
    end
    
    methods (Test)
        function twoBodyCirculation(testCase)
            %TWOBODYCIRCULATION compares a two-body problem with analytics
            %   calculates the circulation of two spherical point-like
            %   masses with different mass and compares the curves with the
            %   analytical solution. The initial values are chosen in a way
            %   so that the resuling curves are circles centered at [0,0]
            %   but with different radii.

            %simulation parameters
            startTime = 0;
            endTime = 1;
            dT = 0.001;
            
            %setup initial parameters to ensure circular curves for two
            %bodies one of them is twice the mass
            r = 10; %initial distance between the masses
            mass1 = 10^6;
            mass2 = 2 * mass1;

            density = mass1;
            
            %dummy instance of SphericalMass is needed to extract the
            %gravitational constant
            dummyMass = SphericalMass();
            G = dummyMass.G;

            %first massive body in the Universe
            iniPosX1 = 2 * r / 3;
            iniPosY1 = 0;
            iniVelX1 = 0;
            iniVelY1 = sqrt( G * mass2^2 / (r * (mass1 + mass2)) );
            massSphere1 = SphericalMass(iniPosX1, iniPosY1, iniVelX1, iniVelY1, mass1, density);
            
            %second massive body in the Universe
            iniPosX2 = (-1) * r / 3;
            iniPosY2 = 0;
            iniVelX2 = 0;
            iniVelY2 = (-1) * sqrt( dummyMass.G * mass1^2 / (r * (mass1 + mass2)) );
            massSphere2 = SphericalMass(iniPosX2, iniPosY2, iniVelX2, iniVelY2, mass2, density);

            %expected radii of the curves
            expRadius1 = 2 * r / 3;
            expRadius2 = r / 3;

            myUniverse = Universe(massSphere1, massSphere2);

            myUniverseSimulation = UniverseSimulation();
            myUniverseSimulation = myUniverseSimulation.runSimulation(myUniverse, startTime, dT, endTime);
            %myUniverseSimulation.plot();
            
            numTimeframes = myUniverseSimulation.getNumberTimeframes();
            [xCurve1, yCurve1] = myUniverseSimulation.getCurveSingleMassiveBody(1, 1, numTimeframes);
            [xCurve2, yCurve2] = myUniverseSimulation.getCurveSingleMassiveBody(2, 1, numTimeframes);

            testCase.verifyRadialCurve(xCurve1, yCurve1, expRadius1);
            testCase.verifyRadialCurve(xCurve2, yCurve2, expRadius2);
        end

    end

    methods
        function verifyRadialCurve(testCase, xCurve, yCurve, expectedRadius)
            radius = sqrt(xCurve.^2 + yCurve.^2);
            checkRadiusMax = all(radius <= expectedRadius + testCase.geometricTolerance);
            checkRadiusMin = all(radius >= expectedRadius - testCase.geometricTolerance);
            
            testCase.verifyTrue(checkRadiusMax, ['the calculated curve is out of max-bounds! error is ',num2str(abs(max(radius))-expectedRadius)]);
            testCase.verifyTrue(checkRadiusMin, ['the calculated curve is out of min-bounds! error is ',num2str(abs(min(radius))-expectedRadius)]);
        end
    end

end


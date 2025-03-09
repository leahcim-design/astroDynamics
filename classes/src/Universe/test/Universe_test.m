classdef (TestTags = {'MatlabUnitTest'}) Universe_test < matlab.unittest.TestCase
    %UNIVERSE_TEST 
    
    properties (Constant)
        smallTolerance = 10 * eps %tolerance for calculated quantities
        largeTolerance = 0.01; %tolerance used for the runge-kutta <-> forward-euler comparison
    end
    
    methods (Test)
        function checkUniverseConstructor(testCase)
            %CHECKUNIVERSEADDMASSIVEBODY
            %   checks Universe-constructor used with two initial
            %   MassiveBodyInterface-children 

            %first massive body in the Universe
            iniPosX1 = 2.131;
            iniPosY1 = -1.1;
            iniVelX1 = 4.6;
            iniVelY1 = 3.4;
            massSphere1 = SphericalMass(iniPosX1, iniPosY1, iniVelX1, iniVelY1);
            
            %second massive body in the Universe
            iniPosX2 = 6.131;
            iniPosY2 = -2.1;
            iniVelX2 = 6.6;
            iniVelY2 = 1.4;
            massSphere2 = SphericalMass(iniPosX2, iniPosY2, iniVelX2, iniVelY2);
           
            myUniverse = Universe(massSphere1, massSphere2);

            testCase.verifyUniverse(testCase.smallTolerance, myUniverse, massSphere1, massSphere2);
        end

        function checkUniverseAddMassiveBody(testCase)
            %CHECKUNIVERSEADDMASSIVEBODY
            %   checks the adding of a new massiveBodyInterface-child
            %   object

            %first massive body in the Universe
            iniPosX1 = 2.131;
            iniPosY1 = -1.1;
            iniVelX1 = 4.6;
            iniVelY1 = 3.4;
            massSphere1 = SphericalMass(iniPosX1, iniPosY1, iniVelX1, iniVelY1);
            
            %second massive body in the Universe
            iniPosX2 = 6.131;
            iniPosY2 = -2.1;
            iniVelX2 = 6.6;
            iniVelY2 = 1.4;
            massSphere2 = SphericalMass(iniPosX2, iniPosY2, iniVelX2, iniVelY2);
           
            myUniverse = Universe();
            myUniverse = myUniverse.addMassiveBody(massSphere1);
            myUniverse = myUniverse.addMassiveBody(massSphere2);

            testCase.verifyUniverse(testCase.smallTolerance, myUniverse, massSphere1, massSphere2);
        end

        function checkCalculateDeltaT(testCase)
            %CHECKCALCULATEDELTAT  
            %   tests the action of each massiveBody in Universe onto each
            %   other; test is set up with two SphericalMass objects in the
            %   universe
            
            %time-step for test
            dT = 1.1;
            
            %first massive body in the Universe
            iniPosX1 = 20.131;
            iniPosY1 = -1.1;
            iniVelX1 = 4.6;
            iniVelY1 = 3.4;
            massSphere1 = SphericalMass(iniPosX1, iniPosY1, iniVelX1, iniVelY1);
            
            %second massive body in the Universe
            iniPosX2 = 6.131;
            iniPosY2 = -2.1;
            iniVelX2 = 6.6;
            iniVelY2 = 1.4;
            massSphere2 = SphericalMass(iniPosX2, iniPosY2, iniVelX2, iniVelY2);
            
            %get the force-densities of each body onto each other
            forceDensity1 = massSphere2.getForceDensityGeneratedByBody(iniPosX1, iniPosY1);
            forceDensity2 = massSphere1.getForceDensityGeneratedByBody(iniPosX2, iniPosY2);

            %expected position and velocity of massiveBody1 after time dT
            expPosX1 = iniPosX1 + dT * iniVelX1;
            expPosY1 = iniPosY1 + dT * iniVelY1;
            expVelX1 = iniVelX1 + dT * forceDensity1(1);
            expVelY1 = iniVelY1 + dT * forceDensity1(2);
            expMassSphere1 = SphericalMass(expPosX1, expPosY1, expVelX1, expVelY1);
            
            %expected position and velocity of massiveBody2 after time dT
            expPosX2 = iniPosX2 + dT * iniVelX2;
            expPosY2 = iniPosY2 + dT * iniVelY2;
            expVelX2 = iniVelX2 + dT * forceDensity2(1);
            expVelY2 = iniVelY2 + dT * forceDensity2(2);
            expMassSphere2 = SphericalMass(expPosX2, expPosY2, expVelX2, expVelY2);

            myUniverse = Universe(massSphere1, massSphere2);
            myUniverse = myUniverse + myUniverse.calculateDeltaT(dT);

            testCase.verifyUniverse(testCase.smallTolerance, myUniverse, expMassSphere1, expMassSphere2)
        end

        function checkTimePropagateUniverse(testCase)
            %CHECKTIMEPROPAGATEUNIVERSE compares runge-kutta4 with
            %forward-euler
            %this test doese not ensure that the runge-kutta4 works exact, 
            %but rather that the two results are sufficiently close after
            %one timestep
            
            %time-step for test
            dT = 1.1;
            
            %first massive body in the Universe
            iniPosX1 = 20.131;
            iniPosY1 = -1.1;
            iniVelX1 = 4.6;
            iniVelY1 = 3.4;
            massSphere1 = SphericalMass(iniPosX1, iniPosY1, iniVelX1, iniVelY1);
            
            %second massive body in the Universe
            iniPosX2 = 6.131;
            iniPosY2 = -2.1;
            iniVelX2 = 6.6;
            iniVelY2 = 1.4;
            massSphere2 = SphericalMass(iniPosX2, iniPosY2, iniVelX2, iniVelY2);
            
            %get the force-densities of each body onto each other
            forceDensity1 = massSphere2.getForceDensityGeneratedByBody(iniPosX1, iniPosY1);
            forceDensity2 = massSphere1.getForceDensityGeneratedByBody(iniPosX2, iniPosY2);

            %expected position and velocity of massiveBody1 after time dT
            expPosX1 = iniPosX1 + dT * iniVelX1;
            expPosY1 = iniPosY1 + dT * iniVelY1;
            expVelX1 = iniVelX1 + dT * forceDensity1(1);
            expVelY1 = iniVelY1 + dT * forceDensity1(2);
            expMassSphere1 = SphericalMass(expPosX1, expPosY1, expVelX1, expVelY1);
            
            %expected position and velocity of massiveBody2 after time dT
            expPosX2 = iniPosX2 + dT * iniVelX2;
            expPosY2 = iniPosY2 + dT * iniVelY2;
            expVelX2 = iniVelX2 + dT * forceDensity2(1);
            expVelY2 = iniVelY2 + dT * forceDensity2(2);
            expMassSphere2 = SphericalMass(expPosX2, expPosY2, expVelX2, expVelY2);

            myUniverseIni = Universe(massSphere1, massSphere2);
            myUniverseProp = myUniverseIni.timePropagateUniverse(dT);

            testCase.verifyUniverse(testCase.largeTolerance, myUniverseProp, expMassSphere1, expMassSphere2)
        end


    end

    methods (Access = private)
        function verifyUniverse(testCase, tolerance, universe, expMassSphere1, expMassSphere2)
            massSphere1 = universe.massiveBodies{1};
            massSphere2 = universe.massiveBodies{2};

            checkPosX1 = (abs(massSphere1.posX - expMassSphere1.posX) <= tolerance);
            checkPosY1 = (abs(massSphere1.posY - expMassSphere1.posY) <= tolerance);
            checkVelX1 = (abs(massSphere1.velX - expMassSphere1.velX) <= tolerance);
            checkVelY1 = (abs(massSphere1.velY - expMassSphere1.velY) <= tolerance);

            checkPosX2 = (abs(massSphere2.posX - expMassSphere2.posX) <= tolerance);
            checkPosY2 = (abs(massSphere2.posY - expMassSphere2.posY) <= tolerance);
            checkVelX2 = (abs(massSphere2.velX - expMassSphere2.velX) <= tolerance);
            checkVelY2 = (abs(massSphere2.velY - expMassSphere2.velY) <= tolerance);

            checkNumberBodies = (numel(universe.massiveBodies) == 2);

            testCase.verifyTrue(checkPosX1, 'posX1 was not correct!');
            testCase.verifyTrue(checkPosY1, 'posY1 was not correct!');
            testCase.verifyTrue(checkVelX1, 'velX1 was not correct!');
            testCase.verifyTrue(checkVelY1, 'velY1 was not correct!');

            testCase.verifyTrue(checkPosX2, 'posX2 was not correct!');
            testCase.verifyTrue(checkPosY2, 'posY2 was not correct!');
            testCase.verifyTrue(checkVelX2, 'velX2 was not correct!');
            testCase.verifyTrue(checkVelY2, 'velY2 was not correct!');

            testCase.verifyTrue(checkNumberBodies, 'number of bodies was not correct!');
        end
    end
end


classdef (TestTags = {'MatlabUnitTest'}) SphericalMassDynamics_test < matlab.unittest.TestCase
    %SPHERICALMASSDYNAMICS_TEST   
    
    properties (Constant)
        tolerance = 10 * eps %tolerance for calculated quantities
    end
    
    methods (Test)
        function checkCalculateDeltaTselfZeroVelocity(testCase)
            %CHECKCALCULATEDELTATSELFZEROVELOCITY 
            %   calculates a forward-euler propagation for one time-step
            %   zero initial velocity is applied
            
            %parameters for test
            dT = 2.;
            
            %initial position and velocity
            iniPosX = 0.0;
            iniPosY = 0.0;
            iniVelX = 0.0;
            iniVelY = 0.0;
            
            %mass and density must remain unchanged!
            mass = 1.0;
            density = 1.0;

            %expected position and velocity after time dT
            expPosX = 0.0;
            expPosY = 0.0;
            expVelX = 0.0;
            expVelY = 0.0;

            massSphere = SphericalMass(iniPosX, iniPosY, iniVelX, iniVelY, mass, density);
            massSphere = massSphere + massSphere.calculateDeltaTself(dT);
            
            verifySphericalMassProperties(testCase, massSphere, expPosX, expPosY, expVelX, expVelY, mass, density);
        end

        function checkCalculateDeltaTselfFiniteVelocity(testCase)
            %CHECKCALCULATEDELTATSELFFINITEVELOCITY
            %   calculates a forward-euler propagation for one time-step
            %   finite initial velocity is applied
            
            %parameters for test
            dT = 2.;
            
            %initial position and velocity
            iniPosX = -12.0;
            iniPosY = 6.3;
            iniVelX = 2.34;
            iniVelY = -1.552;
            
            %mass and density must remain unchanged!
            mass = 1.0;
            density = 1.0;

            %expected position and velocity after time dT
            expPosX = iniPosX + dT * iniVelX;
            expPosY = iniPosY + dT * iniVelY;
            expVelX = iniVelX;
            expVelY = iniVelY;

            massSphere = SphericalMass(iniPosX, iniPosY, iniVelX, iniVelY, mass, density);
            massSphere = massSphere + massSphere.calculateDeltaTself(dT);
            
            verifySphericalMassProperties(testCase, massSphere, expPosX, expPosY, expVelX, expVelY, mass, density);
        end

        function checkDynamicCentralMassAction(testCase)
            %CHECKDYNAMICCENTRALMASSACTION 
            %   tests the action of one SphericalMass onto another
            
            %parameters for test
            dT = 2;
            
            %initial position and velocity of test-mass
            iniPosX = -10.353;
            iniPosY = 30.211;
            iniVelX = -2.31;
            iniVelY = 1.244;
           
            mass = 1;
            density = 1;
            
            %setup central mass that acts on the test-mass
            centralBodyMass = 10;
            centralBodyDensity = 100; 
            massCentral = SphericalMass(0,0,0,0,centralBodyMass, centralBodyDensity);
            forceDensity = massCentral.getForceDensityGeneratedByBody(iniPosX, iniPosY);

            %expected position and velocity of test-mass after time dT
            expPosX = iniPosX + dT * iniVelX;
            expPosY = iniPosY + dT * iniVelY;
            expVelX = iniVelX + dT * forceDensity(1);
            expVelY = iniVelY + dT * forceDensity(2);

            massSphere = SphericalMass(iniPosX, iniPosY, iniVelX, iniVelY, mass, density);   
            massSphere = massSphere + ...
                massSphere.calculateDeltaTself(dT) + ...
                massSphere.calculateDeltaTfromForceSource(massCentral, dT);
            
            verifySphericalMassProperties(testCase, massSphere, expPosX, expPosY, expVelX, expVelY, mass, density);
        end

    end

    methods (Access = private)
        function verifySphericalMassProperties(testCase, massSphere, expPosX, expPosY, expVelX, expVelY, expMass, expDensity)
            checkPosX = (abs(massSphere.posX - expPosX) <= testCase.tolerance);
            checkPosY = (abs(massSphere.posY - expPosY) <= testCase.tolerance);
            checkVelX = (abs(massSphere.velX - expVelX) <= testCase.tolerance);
            checkVelY = (abs(massSphere.velY - expVelY) <= testCase.tolerance);
            
            checkMass = (abs(massSphere.mass - expMass) <= eps);
            checkDensity = (abs(massSphere.density - expDensity) <= eps);

            testCase.verifyTrue(checkPosX, 'posX was not correct!');
            testCase.verifyTrue(checkPosY, 'posY was not correct!');
            testCase.verifyTrue(checkVelX, 'velX was not correct!');
            testCase.verifyTrue(checkVelY, 'velY was not correct!');
            testCase.verifyTrue(checkMass, 'mass was not correct!');
            testCase.verifyTrue(checkDensity, 'density was not correct!');
        end
    end
end


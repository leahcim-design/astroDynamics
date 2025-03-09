classdef (TestTags = {'MatlabUnitTest'}) SphericalMass_test < matlab.unittest.TestCase
    %SPHERICALMASS_TEST
    % checks all the basic functions of the SphericalMass class
    
    properties (Constant)
        tolerance = 10 * eps %tolerance for calculated quantities
    end

    properties (TestParameter)
        deltaPos = num2cell(-7:2:7);
    end
    methods (Test)
        function checkConstructor_0args(testCase)
            
            expPosX = 0;
            expPosY = 0;
            expVelX = 0;
            expVelY = 0;
            expMass = 1;
            expDensity = 1;

            massSphere = SphericalMass();
            
            testCase.verifySphericalMassProperties(massSphere, expPosX, expPosY, expVelX, ...
                expVelY, expMass, expDensity);
        end

        function checkConstructor_2args(testCase)
            
            expPosX = 12.1241;
            expPosY = -51.22;
            expVelX = 0;
            expVelY = 0;
            expMass = 1;
            expDensity = 1;

            massSphere = SphericalMass(expPosX, expPosY);
            
            testCase.verifySphericalMassProperties(massSphere, expPosX, expPosY, expVelX, ...
                expVelY, expMass, expDensity);
        end

        function checkConstructor_4args(testCase)
            
            expPosX = 12.1241;
            expPosY = -51.22;
            expVelX = -23.22;
            expVelY = 0.223;
            expMass = 1;
            expDensity = 1;

            massSphere = SphericalMass(expPosX, expPosY, expVelX, expVelY);
            
            testCase.verifySphericalMassProperties(massSphere, expPosX, expPosY, expVelX, ...
                expVelY, expMass, expDensity);
        end

        function checkConstructor_6args(testCase)
            
            expPosX = 12.1241;
            expPosY = -51.22;
            expVelX = -23.22;
            expVelY = 0.223;
            expMass = 15.2322;
            expDensity = 0.2242;

            massSphere = SphericalMass(expPosX, expPosY, expVelX, expVelY, ...
                expMass, expDensity);
            
            testCase.verifySphericalMassProperties(massSphere, expPosX, expPosY, expVelX, ...
                expVelY, expMass, expDensity);
        end

        function checkRadius(testCase)
            expRadius = 5.23521;

            density = 2.414445;
            mass = density * 4 * pi * expRadius^3 / 3;

            massSphere = SphericalMass();
            massSphere = massSphere.setMass(mass);
            massSphere = massSphere.setDensity(density);

            checkRadius = (abs(expRadius - massSphere.radius) <= eps);
            testCase.verifyTrue(checkRadius, 'radius calculation failed!');
        end

        function checkForceDensityXdirectionOutsideSphere(testCase, deltaPos)
            posMassX = 1.23;
            posMassY = -5.44;
            
            %with these parameters the radius is min(deltaPos), 
            %which is needed to have pure 1/r^2 behavior
            mass = 1; 
            requiredRadius = min(abs([testCase.deltaPos{:}]));
            density = 3 * mass / (4 * pi * requiredRadius^3);

            probePointX = posMassX + deltaPos;
            probePointY = posMassY;

            massSphere = SphericalMass(posMassX, posMassY);
            massSphere = massSphere.setMass(mass);
            massSphere = massSphere.setDensity(density);

            forceDensity = massSphere.getForceDensityGeneratedByBody(probePointX, probePointY);
            
            checkForceDensityValueX = (abs(...
                abs(forceDensity(1)) - massSphere.mass * massSphere.G / deltaPos^2 ...
                ) <= testCase.tolerance);
            checkForceDensityValueY = (abs(forceDensity(2)) <= testCase.tolerance);
            checkForceDensityDirectionX = (sign(deltaPos) ~= sign(forceDensity(1)));

            testCase.verifyTrue(checkForceDensityValueX, 'absolute x-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityValueY, 'absolute y-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityDirectionX, 'sign of force-density is incorrect!');
        end

        function checkForceDensityYDirectionOutsideSphere(testCase, deltaPos)
            posMassX = 1.23;
            posMassY = -5.44;
            
            %with these parameters the radius is min(deltaPos), 
            %which is needed to have pure 1/r^2 behavior
            mass = 1; 
            requiredRadius = min(abs([testCase.deltaPos{:}]));
            density = 3 * mass / (4 * pi * requiredRadius^3);

            probePointX = posMassX;
            probePointY = posMassY + deltaPos;

            massSphere = SphericalMass(posMassX, posMassY);
            massSphere = massSphere.setMass(mass);
            massSphere = massSphere.setDensity(density);

            forceDensity = massSphere.getForceDensityGeneratedByBody(probePointX, probePointY);
            
            checkForceDensityValueX = (abs(forceDensity(1)) <= testCase.tolerance);
            checkForceDensityValueY = (abs(...
                abs(forceDensity(2)) - massSphere.mass * massSphere.G / deltaPos^2 ...
                ) <= testCase.tolerance);
            checkForceDensityDirectionY = (sign(deltaPos) ~= sign(forceDensity(2)));

            testCase.verifyTrue(checkForceDensityValueX, 'absolute x-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityValueY, 'absolute y-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityDirectionY, 'sign of force-density is incorrect!');
        end

        function checkForceDensityXdirectionInsideSphere(testCase, deltaPos)
            posMassX = 1.23;
            posMassY = -5.44;
            
            %with these parameters the radius is max(deltaPos), 
            %which is needed to have pure r^1 behavior
            mass = 1; 
            requiredRadius = max(abs([testCase.deltaPos{:}]));
            density = 3 * mass / (4 * pi * requiredRadius^3);

            probePointX = posMassX + deltaPos;
            probePointY = posMassY;

            massSphere = SphericalMass(posMassX, posMassY);
            massSphere = massSphere.setMass(mass);
            massSphere = massSphere.setDensity(density);

            forceDensity = massSphere.getForceDensityGeneratedByBody(probePointX, probePointY);
            
            checkForceDensityValueX = (abs(...
                abs(forceDensity(1)) - ...
                abs(massSphere.density * massSphere.G * 4 * pi * deltaPos / 3)...
                ) <= testCase.tolerance);
            checkForceDensityValueY = (abs(forceDensity(2)) <= testCase.tolerance);
            checkForceDensityDirectionX = (sign(deltaPos) ~= sign(forceDensity(1)));

            testCase.verifyTrue(checkForceDensityValueX, 'absolute x-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityValueY, 'absolute y-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityDirectionX, 'sign of force-density is incorrect!');
        end

        function checkForceDensitYdirectionInsideSphere(testCase, deltaPos)
            posMassX = 1.23;
            posMassY = -5.44;
            
            %with these parameters the radius is max(deltaPos), 
            %which is needed to have pure r^1 behavior
            mass = 1; 
            requiredRadius = max(abs([testCase.deltaPos{:}]));
            density = 3 * mass / (4 * pi * requiredRadius^3);

            probePointX = posMassX;
            probePointY = posMassY + deltaPos;

            massSphere = SphericalMass(posMassX, posMassY);
            massSphere = massSphere.setMass(mass);
            massSphere = massSphere.setDensity(density);

            forceDensity = massSphere.getForceDensityGeneratedByBody(probePointX, probePointY);
            
            checkForceDensityValueX = (abs(forceDensity(1)) <= testCase.tolerance);
            checkForceDensityValueY = (abs(...
                abs(forceDensity(2)) - ...
                abs(massSphere.density * massSphere.G * 4 * pi * deltaPos / 3)...
                ) <= testCase.tolerance);
            checkForceDensityDirectionY = (sign(deltaPos) ~= sign(forceDensity(2)));

            testCase.verifyTrue(checkForceDensityValueX, 'absolute x-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityValueY, 'absolute y-value of force density incorrect!');
            testCase.verifyTrue(checkForceDensityDirectionY, 'sign of force-density is incorrect!');
        end


    end

    methods (Access = private)
        function verifySphericalMassProperties(testCase, massIn, expPosX, expPosY, expVelX, ...
                expVelY, expMass, expDensity)

            checkPosX = (abs(expPosX - massIn.posX) <= eps);
            checkPosY = (abs(expPosY - massIn.posY) <= eps);
            checkVelX = (abs(expVelX - massIn.velX) <= eps);
            checkVelY = (abs(expVelY - massIn.velY) <= eps);
            checkMass = (abs(expMass - massIn.mass) <= eps);
            checkDensity = (abs(expDensity - massIn.density) <= eps);

            testCase.verifyTrue(checkPosX, 'check posX failed!');
            testCase.verifyTrue(checkPosY, 'check posY failed!');
            testCase.verifyTrue(checkVelX, 'check velX failed!');
            testCase.verifyTrue(checkVelY, 'check velY failed!');
            testCase.verifyTrue(checkMass, 'check mass failed!');
            testCase.verifyTrue(checkDensity, 'check Density failed!');
        end
    end
end


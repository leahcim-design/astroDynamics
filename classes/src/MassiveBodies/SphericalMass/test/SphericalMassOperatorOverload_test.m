classdef SphericalMassOperatorOverload_test < sltest.TestCase
    %SPHERICALMASSOPERATOROVERLOAD_TEST 
    
    properties (Constant)
        tolerance = 10 * eps %tolerance for calculated quantities
    end

    methods (Test)
        function checkPlusOperatorOverload(testCase)
            %CHECKPLUSOPERATOROVERLOAD checks the plus operator
            %   includes all four cases:
            %   a) [SphericalMass] = [SphericalMass] + [double] * [SphericalMassDelta]
            %   b) [SphericalMass] = [double] * [SphericalMassDelta] + [SphericalMass]
            %   c) [SphericalMass] = [SphericalMass] + [SphericalMassDelta] * [double]
            %   d) [SphericalMass] = [SphericalMassDelta] * [double] + [SphericalMass]

            iniPosX = 12.1241;
            iniPosY = -51.22;
            iniVelX = -23.22;
            iniVelY = 0.223;
            
            %mass and density must remain unchanged!
            mass = 1.22;
            density = 3.52;
            
            %change of the dynamic properties
            deltaPosX = 0.235;
            deltaPosY = 2.3125;
            deltaVelX = 1.31555;
            deltaVelY = -5.3;
            
            %scalar with which the delta is multiplied
            s = 3.2;
            
            %expected dynamic properties after addition
            expPosX = iniPosX + s * deltaPosX;
            expPosY = iniPosY + s * deltaPosY;
            expVelX = iniVelX + s * deltaVelX;
            expVelY = iniVelY + s * deltaVelY;

            massSphere = SphericalMass(iniPosX, iniPosY, iniVelX, iniVelY, mass, density);
            delta = SphericalMassDelta(deltaPosX, deltaPosY, deltaVelX, deltaVelY);
            
            massSphere1 = massSphere + s * delta;
            massSphere2 = s * delta + massSphere;
            massSphere3 = massSphere + delta * s;
            massSphere4 = delta * s + massSphere;

            verifySphericalMassProperties(testCase, massSphere1, expPosX, expPosY, expVelX, expVelY, mass, density);
            verifySphericalMassProperties(testCase, massSphere2, expPosX, expPosY, expVelX, expVelY, mass, density);
            verifySphericalMassProperties(testCase, massSphere3, expPosX, expPosY, expVelX, expVelY, mass, density);
            verifySphericalMassProperties(testCase, massSphere4, expPosX, expPosY, expVelX, expVelY, mass, density);
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


classdef SphericalMass < MassiveBodyInterface  
    
    properties (SetAccess = protected)
        posX double %center-of-mass x-coordinate
        posY double %center-of-mass y-coordinate
        velX double %center-of-mass x-velocity
        velY double %center-of-mass y-velocity
        mass double %total mass of the body

        density double %mass-density of the sphere -> determines the radius
    end

    properties (Dependent)
        radius double
    end

    methods
        function obj = SphericalMass(varargin)
            %SPHERICALMASS Construct an instance of this class
            %   depending in the number of passed arguments, different
            %   properties are set; all other properties are initialized 
            %   with default values 

            if numel(varargin) == 0
                obj = obj.setPosition(0.0, 0.0);
                obj = obj.setVelocity(0.0, 0.0);
                obj = obj.setMass(1.0);
                obj = obj.setDensity(1.0);

            elseif numel(varargin) == 2
                obj = obj.setPosition(varargin{1}, varargin{2});
                obj = obj.setVelocity(0.0, 0.0);
                obj = obj.setMass(1.0);
                obj = obj.setDensity(1.0);

            elseif numel(varargin) == 4
                obj = obj.setPosition(varargin{1}, varargin{2});
                obj = obj.setVelocity(varargin{3}, varargin{4});
                obj = obj.setMass(1.0);
                obj = obj.setDensity(1.0);

            elseif numel(varargin) == 5
                obj = obj.setPosition(varargin{1}, varargin{2});
                obj = obj.setVelocity(varargin{3}, varargin{4});
                obj = obj.setMass(varargin{5});
                obj = obj.setDensity(1.0);

            elseif numel(varargin) == 6
                obj = obj.setPosition(varargin{1}, varargin{2});
                obj = obj.setVelocity(varargin{3}, varargin{4});
                obj = obj.setMass(varargin{5});
                obj = obj.setDensity(varargin{6});

            else
                error('sphericalMass: invalid input-number in constructor!');
            end
        end
       
        function obj = setDensity(obj,newDensity)
            %SETDENSITY
            %   setter for the density; must be nonzero
            arguments
                obj (1,1) 
                newDensity (1,1) {mustBeNumeric,mustBeReal,mustBeNonzero}
            end
            
            obj.density = newDensity;
        end

        function obj = setMass(obj,newMass)
            %SETMASS
            %   setter for the mass; must be nonzero
            arguments
                obj (1,1) 
                newMass (1,1) {mustBeNumeric,mustBeReal,mustBeNonzero}
            end
            
            obj.mass = newMass;
        end

        function r = get.radius(obj)
            r = nthroot(3 * obj.mass / (4 * pi * obj.density), 3); 
        end

        function [forceDensity] = getForceDensityGeneratedByBody(obj, posForceX, posForceY)            
            %GETFORCEDENSITYGENERATEDBYBODY calculates the force-density
            %   calculates the force-density (force per unit mass) that is
            %   generated by this instance at the point [posForceX, posForceY]
            %INPUT
            %   posForceX (1,1): x-position of the force-density
            %   posForceY (1,1): y-position of the force-density
            %OUTPUT
            %   forceDensity (1,2) double: force in x- and y-direction 
            %                              unit is forceUnit / massUnit
            arguments
                obj (1,1) 
                posForceX (1,1) {mustBeNumeric,mustBeReal}
                posForceY (1,1) {mustBeNumeric,mustBeReal}
            end
            dR = [obj.posX - posForceX, obj.posY - posForceY];
            dRnorm = norm(dR);
            if dRnorm >= obj.radius
                forceDensity = dR * obj.G * obj.mass / ( dRnorm^3 );
            else
                forceDensity = 4 * pi * obj.density * dR / 3;
            end
        end

        function [objReturn] = plus(obj1, obj2)
            if isa(obj1, 'SphericalMass') && isa(obj2, 'SphericalMassDelta')
                objReturn = obj1; 

                objReturn = objReturn.setPosition(...
                objReturn.posX + obj2.deltaPosX, objReturn.posY + obj2.deltaPosY);
                objReturn = objReturn.setVelocity(...
                objReturn.velX + obj2.deltaVelX, objReturn.velY + obj2.deltaVelY);
            else 
                error('SphericalMass: cannot handle addition with these classes!');
            end
        end
        
        function [deltaT] = calculateDeltaTself(obj, dT)
            %CALCULATEDELTATSELF returns the change dynamic properties
            %   returns the change in the dynamic properties due to an 
            %   elapsed time interval
            %INPUT:
            %   spherical mass
            %   dT: time step that is applied
            %OUTPUT:
            %   deltaT [SphericalMassDelta]: the change in position and 
            %   velocity due to the elapsed time
            arguments
                obj (1,1) 
                dT (1,1) {mustBeNumeric,mustBeReal, mustBePositive}
            end

            deltaT = SphericalMassDelta(...
                dT * obj.velX,...
                dT * obj.velY,...
                0.0,...
                0.0);
        end
        
        function [deltaT] = calculateDeltaTfromForceSource(obj, massivBodyFieldSource, dT)
            %CALCULATEDELTATFROMFORCESOURCE 
            %   this function calculates the change in velocity due to 
            %   the force-density generated by another mass; as a 
            %   simplification, only the force-density at the 
            %   center-of-mass of this body is used, this is equivalent to 
            %   treating the sphere like a pointmass
            %INPUT: 
            %   massivBodyFieldSource [child of MassiveBodyInterface]
            %   dT: time step that is applied
            %OUTPUT:
            %   deltaT [SphericalMassDelta]: the change in velocity due to 
            %   the elapsed time and the force-density
            arguments
                obj (1,1) 
                massivBodyFieldSource (1,1) MassiveBodyInterface
                dT (1,1) {mustBeNumeric,mustBeReal, mustBePositive}
            end
            forceDensity = massivBodyFieldSource.getForceDensityGeneratedByBody(obj.posX, obj.posY);

            deltaT = SphericalMassDelta(...
                0.0,...
                0.0,...
                dT * forceDensity(1),...
                dT * forceDensity(2));
        end

        function plot(obj)
            %PLOT plots the sphere into the current plot
            ang=[0:0.2:2*pi, 0]; 
            r = obj.radius;
            xp = r * cos(ang);
            yp = r * sin(ang);
            hold on;
            plot(obj.posX + xp, obj.posY + yp);
            hold off;
        end
    end
end


classdef SphericalMassDelta < MassiveBodyDeltaInterface
    %SPHERICALMASSDELTA datacontainer for changes in the dynmic properties
    %   this class is a data container for changes of the dynamic
    %   properties of SphericalMass objects
    
    properties (SetAccess = private)
        deltaPosX double %center-of-mass x-coordinate change
        deltaPosY double %center-of-mass y-coordinate change
        deltaVelX double %center-of-mass x-velocity change
        deltaVelY double %center-of-mass y-coordinate change
    end
    
    methods
        function obj = SphericalMassDelta(deltaPosX, deltaPosY, deltaVelX, deltaVelY)
            %SPHERICALMASSDELTA Construct an instance of this class
            %   the properties can only be set upon construction
            arguments
                deltaPosX (1,1) {mustBeNumeric,mustBeReal}
                deltaPosY (1,1) {mustBeNumeric,mustBeReal}
                deltaVelX (1,1) {mustBeNumeric,mustBeReal}
                deltaVelY (1,1) {mustBeNumeric,mustBeReal}
            end
            obj.deltaPosX = deltaPosX;
            obj.deltaPosY = deltaPosY;
            obj.deltaVelX = deltaVelX;
            obj.deltaVelY = deltaVelY;
        end

        function [objReturn] = plus(obj1, obj2)
            if isa(obj1, 'SphericalMassDelta') && isa(obj2, 'SphericalMass')
                objReturn = obj2 + obj1;
            elseif isa(obj1, 'SphericalMassDelta') && isa(obj2, 'SphericalMassDelta')
                objReturn = SphericalMassDelta(...
                    obj1.deltaPosX + obj2.deltaPosX,...
                    obj1.deltaPosY + obj2.deltaPosY,...
                    obj1.deltaVelX + obj2.deltaVelX,...
                    obj1.deltaVelY + obj2.deltaVelY);
            else 
                error('SphericalMassDelta: cannot handle addition with these classes!');
            end
        end

        function [objReturn] = mtimes(obj1, obj2)
            if isa(obj1, 'SphericalMassDelta') && isa(obj2, 'double')
                objIn = obj1;
                s = obj2;
            elseif isa(obj1, 'double') && isa(obj2, 'SphericalMassDelta')
                objIn = obj2;
                s = obj1;
            else 
                error('SphericalMassDelta: cannot handle addition with these classes!');
            end

            objReturn = SphericalMassDelta(...
                    s * objIn.deltaPosX,...
                    s * objIn.deltaPosY,...
                    s * objIn.deltaVelX,...
                    s * objIn.deltaVelY);
        end
    end
end


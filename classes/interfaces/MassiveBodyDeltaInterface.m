classdef (Abstract) MassiveBodyDeltaInterface
    %MASSIVEBODYDELTAINTERFACE this is an interface for position-changes
    %   this class acts as a data-container for calculations with
    %   MassiveBody objects. Each implementation of a MassiveBody must have
    %   its corresponding MassiveBodyDelta. The MassiveBodyDelta must
    %   contain changes of all the dynamic properties that describe the
    %   state of motion of a MassiveBody
    
    properties (Abstract, SetAccess = private)
        deltaPosX double %center-of-mass x-coordinate change
        deltaPosY double %center-of-mass y-coordinate change
        deltaVelX double %center-of-mass x-velocity change
        deltaVelY double %center-of-mass y-coordinate change
    end
    
    methods (Abstract)
        %the plus-operator (+) must be overloaded in order to work with the
        %overloaded plus-operator of the corresponding MassiveBody
        [objReturn] = plus(obj1, obj2)
        
        %the mtimes-operator ( * )  must be overloaded to work with scalars
        [objReturn] = mtimes(obj1, obj2)

    end
end


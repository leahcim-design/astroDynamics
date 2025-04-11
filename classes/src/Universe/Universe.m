classdef Universe
    
    properties (SetAccess = private)
        massiveBodies = {}
    end
    
    methods
        function obj = Universe(varargin)
            %UNIVERSE Construct an instance of this class
            %   any number of MassiveBodyInterface-children may be passed
            %   as arguments
            for ii=1:numel(varargin)
                obj = obj.addMassiveBody(varargin{ii});
            end
        end
        
        function obj = addMassiveBody(obj, newMassiveBody)
            %ADDMASSIVEBODY adds child of MassiveBodyInterface to universe
            %   the passed MassiveBodyInterface-child is added to the
            %   universe 
            arguments
                obj (1,1) 
                newMassiveBody (1,1) MassiveBodyInterface
            end

            obj.massiveBodies{end+1} = newMassiveBody;
        end

        function [deltaT] = calculateDeltaT(obj, dT)    
            %CALCULATEDELTAT calculates the forward-euler of the Universe 
            %   this function calculates the change in dynamic parameters
            %   due to elapsed time and the force-densities of all bodies
            %   onto each other
            %INPUT: 
            %   dT: time step that is applied
            %OUTPUT:
            %   deltaT [UniverseDelta]: the change in the Universe in time
            %                           interval dT
            
            %initialize an empty UniverseDelta that is filled in the loop
            arguments
                obj (1,1) 
                dT (1,1) {mustBeNumeric,mustBeReal, mustBePositive}
            end

            deltaT = UniverseDelta();
            numBodies = obj.getNumberMassiveBodies();
            for ii = 1:numBodies
                
                %calculate the delta of a single massive body due to the
                %force-densities of all the other massive bodies
                localMassiveBody = obj.getMassiveBody(ii);
                localDeltaT = localMassiveBody.calculateDeltaTself(dT);
                for jj = 1:numBodies
                    if ii ~= jj
                        localDeltaT = localDeltaT + ...
                            localMassiveBody.calculateDeltaTfromForceSource(obj.getMassiveBody(jj), dT);
                    end
                end

                %add the delta of the ii-th massive body to the
                %UniverseDelta
                deltaT = deltaT.addDelta(localDeltaT);
            end
        end 

        function obj = timePropagateUniverse(obj, dT)
            %TIMEPROPAGATEUNIVERSE calculates the Universe after time dT
            %the time propagation method implemented is runge-kutta4 
            arguments
                obj (1,1) 
                dT (1,1) {mustBeNumeric,mustBeReal, mustBePositive}
            end
            
            dTtimesK1 = obj.calculateDeltaT(dT);

            yK1 = obj + 0.5 * dTtimesK1;
            dTtimesK2 = yK1.calculateDeltaT(dT);

            yK2 = obj + 0.5 * dTtimesK2;
            dTtimesK3 = yK2.calculateDeltaT(dT);

            yK3 = obj + dTtimesK3;
            dTtimesK4 = yK3.calculateDeltaT(dT);

            obj = obj + ...
                (1/6) * (dTtimesK1 + 2 * dTtimesK2 + 2 * dTtimesK3 + dTtimesK4);           
        end

        function num = getNumberMassiveBodies(obj)
            %GETNUMBERBODIES returns the number of bodies in the universe
            num = numel(obj.massiveBodies);
        end
        
        function massiveBody = getMassiveBody(obj, bodyIdx)
            %GETMASSIVEBODIES getter for the idx-th body in the universe
            arguments
                obj (1,1) 
                bodyIdx (1,1) uint16 {mustBeNumeric,mustBeReal, mustBePositive, mustBeNonzero}
            end
            if bodyIdx <= obj.getNumberMassiveBodies()
                massiveBody = obj.massiveBodies{bodyIdx}; 
            else
                error('Universe: index exceeds bounds!');
            end
        end

        function [objReturn] = plus(obj1, obj2)
            if isa(obj1, 'Universe') && isa(obj2, 'UniverseDelta')

                localMassiveBodies = cell(1, obj1.getNumberMassiveBodies());
                for ii = 1:obj1.getNumberMassiveBodies()
                    localMassiveBodies{ii} = ...
                        obj1.getMassiveBody(ii) + obj2.deltaMassiveBodies{ii};
                end
                objReturn = Universe(localMassiveBodies{:});
            else 
                error('SphericalMass: cannot handle addition with these classes!');
            end
        end

        function plot(obj)
            for ii = 1:obj.getNumberMassiveBodies()
                obj.getMassiveBody(ii).plot();
            end
        end
        
    end
end


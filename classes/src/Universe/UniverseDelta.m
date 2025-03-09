classdef UniverseDelta
    %UNIVERSEDELTA Summary of this class goes here
    
    properties (SetAccess = private)
        deltaMassiveBodies
    end
    
    methods
        function obj = UniverseDelta(varargin)
            %UNIVERSEDELTA Construct an instance of this class
            %   Detailed explanation goes here
            for ii = 1:numel(varargin)
                obj.addDelta(varargin{ii});
            end
        end

        function obj = addDelta(obj, newDelta)
            arguments
                obj (1,1)
                newDelta (1,1) 
            end
            obj.deltaMassiveBodies{end+1} = newDelta;
        end

        function [objReturn] = plus(obj1, obj2)
            if isa(obj1, 'UniverseDelta') && isa(obj2, 'Universe')
                objReturn = obj2 + obj1;
            elseif isa(obj1, 'UniverseDelta') && isa(obj2, 'UniverseDelta')

                if numel(obj1.deltaMassiveBodies) == numel(obj2.deltaMassiveBodies)
                    objReturn = UniverseDelta();
                    for ii = 1:numel(obj1.deltaMassiveBodies)
                        objReturn = objReturn.addDelta(...
                            obj1.deltaMassiveBodies{ii} + obj2.deltaMassiveBodies{ii});
                    end
                else
                    error('UniverseDelta: attempt to add two UniverseDelta instances with differnet size!');
                end
            else 
                error('UniverseDelta: cannot handle addition with these classes!');
            end
        end

        function [objReturn] = mtimes(obj1, obj2)
            if isa(obj1, 'UniverseDelta') && isa(obj2, 'double')
                objIn = obj1;
                s = obj2;
            elseif isa(obj1, 'double') && isa(obj2, 'UniverseDelta')
                objIn = obj2;
                s = obj1;
            else 
                error('UniverseDelta: cannot handle multiplication with these classes!');
            end
            
            objReturn = UniverseDelta();
            for ii = 1:numel(objIn.deltaMassiveBodies)
                objReturn = objReturn.addDelta(...
                    s * objIn.deltaMassiveBodies{ii});
            end
        end
    end
end


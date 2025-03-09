classdef UniverseSimulation
    %UNIVERSESIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        universeTimeSeries = {}
        time

        startTime double
        dT double
        endTime double
    end
    
    methods
        function obj = UniverseSimulation()
            %UNIVERSESIMULATION Construct an instance of this class
        end
        
        function obj = runSimulation(obj,initialUniverse, startTime, dT, endTime)
            %RUNSIMULATION simulates a given universe
            %INPUTS:
            %   initialUniverse: universe at the startTime
            %   startTime: time at which the simulation starts
            %   dT: time-step for the time propagation; must be positive!
            %   endTime: time until which the universe is propagated
            arguments
                obj (1,1) 
                initialUniverse (1,1) Universe
                startTime (1,1) {mustBeNumeric,mustBeReal}
                dT {mustBeNumeric,mustBeReal, mustBePositive}
                endTime {mustBeNumeric,mustBeReal}
            end

            if (startTime <= endTime)
                %delete current (if any) simulation
                obj.universeTimeSeries = {};
                obj.time = [];

                %set initial universe and simulation parameters
                obj.universeTimeSeries{1} = initialUniverse;
                obj.time(1) = startTime;
                obj.startTime = startTime;
                obj.dT = dT;
                obj.endTime = endTime;
                
                %run simulation
                currentTime = startTime;
                nSteps = floor( (endTime - startTime)/dT );
                for ii = 1:nSteps
                    currentTime = currentTime + dT;
                    obj.time(end + 1) = currentTime;
                    obj.universeTimeSeries{end + 1} = obj.universeTimeSeries{end}.timePropagateUniverse(dT);
                end
            else
                error('UniverseSimulation: endTime must be after the startTime!');
            end
        end

        function num = getNumberTimeframes(obj)
            %GETNUMBERUNIVERSES returns the number of universe timeframes
            num = numel(obj.universeTimeSeries);
        end

        function universe = getSingleTimeframe(obj, timeIdx)
            %GETSINGLETIMEFRAME returns the universe at timeIdx
            %   the corresponding time would be timeIdx * dT + startTime
            %INPUTS:
            %   timeIdx: index, indicates the corresponding time
            %OUTPUTS:
            %   universe: instance of class Universe
            arguments
                obj (1,1) 
                timeIdx (1,1) uint16 {mustBeNumeric,mustBeReal, mustBePositive, mustBeNonzero}
            end
            if timeIdx <= obj.getNumberTimeframes()
                universe = obj.universeTimeSeries{timeIdx};
            else
                error('UniverseSimulation: index exceeds bounds!');
            end
        end

        function [x,y] = getCurveSingleMassiveBody(obj, bodyIdx, startTimeIdx, endTimeIdx)
            %GETCURVESINGLEMASSIVEBODY returns the path of one massiveBody 
            %   returns the center-of-mass curve of the massiveBody
            %   indicated by bodyIdx in the time-interval indicated by
            %   startTimeIdx and endTimeIdx
            %INPUTS:
            % bodyIdx: index the addresses the body in the universe
            % startTimeIdx: index that indicates the start time
            % endTimeIdx: index that indicates the end time of the curve
            %OUTPUTS:
            % x: row-array of double, x-coordinate of the center-of-mass
            % y: row-array of double, y-coordinate of the center-of-mass
            arguments
                obj (1,1) 
                bodyIdx (1,1) uint16 {mustBeNumeric,mustBeReal, mustBePositive, mustBeNonzero}
                startTimeIdx (1,1) uint16 {mustBeNumeric,mustBeReal, mustBePositive, mustBeNonzero}
                endTimeIdx (1,1) uint16 {mustBeNumeric,mustBeReal, mustBePositive, mustBeNonzero}
            end
            
            if (startTimeIdx <= endTimeIdx) && (endTimeIdx <= obj.getNumberTimeframes())
                if bodyIdx <= obj.getSingleTimeframe(endTimeIdx).getNumberMassiveBodies()
                    x = zeros(1, (1 + endTimeIdx - startTimeIdx) );
                    y = zeros(1, (1 + endTimeIdx - startTimeIdx) );
                    
                    %extract the center-of-mass coordinates of every
                    %timeframe in the given time-interval
                    for timeIdx = startTimeIdx:endTimeIdx
                        localUniverse = obj.getSingleTimeframe(timeIdx);
                        x(timeIdx) = localUniverse.getMassiveBody(bodyIdx).posX;
                        y(timeIdx) = localUniverse.getMassiveBody(bodyIdx).posY;
                    end
                else
                    error('UniverseSimulation: index exceeds bounds!');
                end
            else
                error('UniverseSimulation: index exceeds bounds!');
            end

        end
        
        function plot(obj)
            
            timeIdx = obj.getNumberTimeframes();
            localUniverse = obj.getSingleTimeframe( timeIdx );
            
            figure(gcf);
            axis equal;
            localUniverse.plot();
            numBodies = localUniverse.getNumberMassiveBodies();
            for bodyIdx = 1:numBodies
                [xMassCenter, yMassCenter] = obj.getCurveSingleMassiveBody(bodyIdx, 1, timeIdx);
                hold on;
                plot(xMassCenter,yMassCenter,'-');
                hold off;
            end
        end

        function plotFrames(obj, nPlots, xLimit, yLimit)
            %PLOT plots several frames of different times
            %   divides the total simulation time into nPlots-1 intervals
            %   and generates nPlots plots
            %INPUTS:
            % nPlots: integer that indicates the number of desired plots
            % xLimit: array that contains the 
            nTotal = obj.getNumberTimeframes();
            dN = floor((nTotal-1) / nPlots) + 1;
            for timeIdx = 1:dN:nTotal

                figure;
                xlim(xLimit);
                ylim(yLimit);

                localUniverse = obj.getSingleTimeframe(timeIdx);
                localUniverse.plot();
                numBodies = localUniverse.getNumberMassiveBodies();
                for bodyIdx = 1:numBodies
                    [xMassCenter, yMassCenter] = obj.getCurveSingleMassiveBody(bodyIdx, 1, timeIdx);
                    hold on;
                    plot(xMassCenter,yMassCenter,'-');
                    hold off;
                end
            end
        end
    end
end


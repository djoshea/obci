classdef ImageRunningAverageSystem2 < matlab.System
    % Untitled Add summary here
    %
    % NOTE: When renaming the class name Untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties,
    % attributes, and methods that you can implement for a System object.
    
    % Public, tunable properties.
    properties
        
    end
    
    % Public, non-tunable properties.
    properties (Nontunable)
        imageSize = [512 512];
        nFrames = 16;
    end
    
    % Pre-computed constants.
    properties (Access = private)
    end
    
    properties (DiscreteState)
        buffer
        bufPos
        bufUsed
    end
    
    methods
        % Constructor
        function obj = ImageRunningAverageSystem2(varargin)
            % Support name-value pair arguments when constructing the
            % object.
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods
         function avg = computeAverageImage(obj)
            if any(obj.bufUsed)
                avg = squeeze(mean(obj.buffer(obj.bufUsed, :, :), 1));
            else
                avg = zeros(obj.imageSize);
            end
         end 
    end
    
    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
 
        end
        
        function [avg] = stepImpl(obj, image)
            % Implement algorithm. Calculate y as a function of
            % input u and discrete states.
            if obj.bufPos == 1
                lastFrame = squeeze(obj.buffer(obj.nFrames, :, :));
            else
                lastFrame = squeeze(obj.buffer(obj.bufPos-1, :, :));
            end
            
            if ~isequal(image, lastFrame)
                % update the buffer if this is not the same data as last
                % time
                obj.buffer(obj.bufPos, :, :) = image;
                obj.bufUsed(obj.bufPos) = true;
                obj.bufPos = obj.bufPos + 1;
                if obj.bufPos > obj.nFrames
                    obj.bufPos = 1;
                end
            end
            
            avg = obj.computeAverageImage();
        end
        
        function resetImpl(obj)
            % Initialize discrete-state properties.
            obj.buffer = zeros([obj.nFrames obj.imageSize], 'uint32');
            obj.bufPos = 1;
            obj.bufUsed = false(obj.nFrames, 1);
        end
        
       
        %% Advanced functions
%         function validateInputsImpl(obj,u)
%             % Validate inputs to the step method at initialization.
%         end
        
        function processTunedPropertiesImpl(obj)
            % Define actions to perform when one or more tunable property
            % values change.
            if size(obj.buffer, 1) > obj.nFrames
                % getting smaller
                obj.buffer = obj.buffer(1:obj.nFrames, :, :);
                obj.bufUsed = obj.bufUsed(1:obj.nFrames);
                if obj.bufPos > obj.nFrames
                    obj.bufPos = 1;
                end
            elseif size(obj.buffer, 1) < obj.nFrames
                % getting bigger
                nExtra = obj.nFrames - size(obj.buffer, 1);
                obj.buffer = cat(1, obj.buffer, zeros([nExtra obj.imageSize], 'uint32'));
                obj.bufUsed = cat(1, obj.bufUsed, false(nExtra, 1));
            end 
        end

    end
end

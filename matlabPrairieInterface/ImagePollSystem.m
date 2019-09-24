classdef ImagePollSystem < matlab.System & matlab.system.mixin.Propagates
    % Fetches an image from PrairieControl
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
        maxSize = 2048;
    end
    
    % Pre-computed constants.
    properties (Access = private)
    end
    
    methods
        % Constructor
        function obj = ImagePollSystem(varargin)
            % Support name-value pair arguments when constructing the
            % object.
            setProperties(obj,nargin,varargin{:});
        end
    end
        
    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Implement tasks that need to be performed only once,
            % such as pre-computed constants.
%             obj.pc = PrairieControl.getInstance();  
        end
        
        function [image] = stepImpl(obj)
            % Fetch a new image. update indicates the image has changed
            % since last time, sizechanged indicates the the image size has
            % changed
            coder.extrinsic('pcGetImage');
            image = zeros(512, 512);
            image = pcGetImage();
        end
        
        function resetImpl(obj)
            % Initialize discrete-state properties.
        end
        
        function num = getNumOutputsImpl(~)
            num = 1;
        end

        function [sz1] = getOutputSizeImpl(obj)
            % Maximum length of linear indices and element vector is the
            % number of elements in the input
            sz1 = [obj.maxSize obj.maxSize];
        end

        function [fz1] = isOutputFixedSizeImpl(~)
            %Both outputs are always variable-sized
            fz1 = false;
        end

        function [dt1] = getOutputDataTypeImpl(obj)
            dt1 = 'uint32';
        end

        function [cp1] = isOutputComplexImpl(obj)
            cp1 = false;
        end
        
%         function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj, name)
%             switch name
%                 case 'lastImage'
%                     sz = [obj.maxSize obj.maxSize];
%                     dt = 'uint32';
%                     cp = false;
%                 case 'imageSize'
%                     sz = [obj.maxSize obj.maxSize];
%                     dt = 'uint32';
%                     cp = false;
%             end
%         end
    end
end

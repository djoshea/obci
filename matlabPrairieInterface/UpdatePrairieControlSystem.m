classdef UpdatePrairieControlSystem < matlab.System
    % Updates the PrairieControl gui
    
    % Public, tunable properties.
    properties
    
    end
    
    % Public, non-tunable properties.
    properties (Nontunable)
        
    end
    
    % Pre-computed constants.
    properties (Access = private)
        pc
    end
    
    methods
        % Constructor
        function obj = UpdatePrairieControlSystem(varargin)
            setProperties(obj,nargin,varargin{:});
        end
    end
        
    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Implement tasks that need to be performed only once,
            % such as pre-computed constants.
            obj.pc = PrairieControl.getInstance();
        end
        
        function stepImpl(obj, image)
            obj.pc.updateImage(image);
        end
        
        function resetImpl(obj)
            % Initialize discrete-state properties.
        end
        
    end
end

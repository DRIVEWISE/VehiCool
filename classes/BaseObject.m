%------------------------------------------------------------------------------%
% Latest revision: 08/04/2023.
%
% Authors:
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef (Abstract) BaseObject < handle
    %% BaseObject
    % Base class for all objects in the library.
    % This class is abstract and cannot be instantiated.
    %

    %% Properties - abstract
    properties (Abstract, SetAccess = private, Hidden = true)

        ax    % axes handle
        state % state of the object

    end

    %% Methods - abstract
    methods (Abstract)

        set_state( obj, state ) % set the state of the object
        plot( obj, ax )         % plot the object
        update( obj )           % update the object

    end

end

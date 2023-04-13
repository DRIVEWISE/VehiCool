%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%
% Contributors
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef (Abstract) BaseObject < handle
    %% BaseObject
    % Base class for all objects in the library.
    %
    % This class is abstract and cannot be instantiated. It serves as a
    % template for all objects in the library.
    %
    % Usage
    % -----
    % Whenever you want to create a new object, you should inherit from this
    % class. You should implement the following properties and methods:
    %  - properties (SetAccess = private, Hidden = true)
    %    - ax    -> axes handle.
    %    - state -> state of the object.
    %  - methods
    %    - set_state( obj, state ) -> set the state of the object.
    %    - plot( obj, ax )         -> plot the object.
    %    - update( obj )           -> update the object.
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

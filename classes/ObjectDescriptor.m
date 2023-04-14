%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

classdef ObjectDescriptor < handle
    %% ObjectDescriptor
    % This class describes the graphical properties of an object in the scene.
    %
    % This class is abstract and cannot be instantiated. It serves as a
    % template for all objects descriptors in the library.
    %
    % Usage
    % -----
    % Whenever you want to create a new object descriptor, you should inherit
    % from this class. You should implement the following properties and
    % methods:
    %  - properties (SetAccess = private, Hidden = true)
    %    - fig -> axes handle.
    %    - ax  -> axes handle.
    %  - methods
    %    - plot( obj, ax ) -> plot the object descriptor.
    %    - update( obj )   -> update the object descriptor.
    %

    %% Properties - abstract
    properties (Abstract, SetAccess = private, Hidden = true)

        fig % figure handle
        ax  % axes handle

    end

    %% Methods - abstract
    methods (Abstract)

        plot( obj, ax ) % plot the object descriptor
        update( obj )   % update the object descriptor

    end

end

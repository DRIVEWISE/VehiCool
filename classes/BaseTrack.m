%------------------------------------------------------------------------------%
% Latest revision: 08/04/2023.
%
% Authors:
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

classdef (Abstract) BaseTrack < handle
    %% BaseTrack
    % Base class for all tracks in the library.
    % This class is abstract and cannot be instantiated.
    %

    %% Properties - abstract
    properties (Abstract, SetAccess = private, Hidden = true)

        ax % axes handle

    end

    %% Methods - abstract
    methods (Abstract)

        plot( obj, ax ) % plot the object

    end

end

%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%  - Mattia Piazza.
%------------------------------------------------------------------------------%

function plot_children( obj, ax, varargin )
    % Plot the object's children
    %
    % Arguments
    % ---------
    %  - ax -> the axes handle.
    %
    % Usage
    % -----
    %  - obj.plot_children( ax )
    %

    % Unravel the tree of objects
    for i = 1:length( obj.children )
        % Plot the root object
        obj.children{i}.plot( ax );

        % Plot its children
        if ~isempty( obj.children{i}.children )
            obj.children{i}.plot_children( ax );
        end
    end

end
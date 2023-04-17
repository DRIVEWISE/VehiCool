%------------------------------------------------------------------------------%
% Authors
%  - Sebastiano Taddei.
%------------------------------------------------------------------------------%

function out = get_state( obj )
    % Get the current state of the object.
    %
    % Outputs
    % -------
    %  - out -> the next state of the object.
    %
    % Usage
    % -----
    %  - out = obj.get_state()
    %

    if size( obj.state, 1 ) == 1
        out = obj.state;
    else
        out     = obj.state( obj.idx, : );
        obj.idx = obj.idx + 1;
    end

end
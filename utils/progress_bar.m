% progress_bar is a simple utility developed to easily incorporate a progress
% bar in any MATLAB loop.
%
% Authors
% -------
%  - Sebastiano Taddei.
%
function progress_bar(start, stop, step, idx, type)
%PROGRESS_BAR
%   Prints a progress bar to the console.
%
%   Arguments
%   ---------
%    - start -> start index.
%    - stop  -> stop index.
%    - step  -> step to take.
%    - idx   -> current index.
%    - type  -> the type of progress bar:
%                - 0 -> XXX%;
%                - 1 -> [===    ].
%

bar_len  = 50;
bar_step = floor(100/bar_len);

last = floor( (stop - start) / step ) * step + start;
perc = floor( idx / (last - start) * 100 );

if type == 0
    if idx ~= start
        fprintf('\b\b\b\b\b%3d%%\n', perc);
    else
        fprintf('%3d%%\n', perc);
    end
elseif type == 1
    bar_adv = floor(perc/bar_step);
    if idx ~= start && mod(perc, bar_step) == 0
        fprintf([repmat('\b', 1, 3 + bar_len), '[', ...
                 repmat('=', 1, bar_adv), ...
                 repmat(' ', 1, bar_len - bar_adv), ']\n']);
    elseif mod(perc, bar_step) == 0
        fprintf(['[', repmat('=', 1, bar_adv), ...
                 repmat(' ', 1, bar_len - bar_adv), ']\n']);
    end
end

end


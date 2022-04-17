function [ax,args,nargs] = check_axes(varargin)
    %% check_axes
    %
    % input: (varargin)
    % varargin  cell array
    %
    % output: [ax,args,nargs]
    % ax        axes
    % args      cell array
    %
    % update:2021/12/29
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    args = varargin{:};
    nargs = nargin;
    ax=[];
    
    % Check for either a scalar numeric Axes handle, or any size array of Axes.
    % 'isgraphics' will catch numeric graphics handles, but will not catch
    % deleted graphics handles, so we need to check for both separately.
    if (nargs > 0) && ...
            ((isnumeric(args{1}) && isscalar(args{1}) && isgraphics(args{1}, 'axes')) ...
            || isa(args{1},'matlab.graphics.axis.AbstractAxes') || isa(args{1},'matlab.ui.control.UIAxes'))
        ax = handle(args{1});
        args = args(2:end);
        nargs = nargs-1;
    end
    if nargs > 0
        % Detect 'Parent' or "Parent" (case insensitive).
        inds = find(cellfun(@(x) (isStringScalar(x) || ischar(x)) && strcmpi('parent', x), args));
        if ~isempty(inds)
            inds = unique([inds inds+1]);
            pind = inds(end);
            
            % Check for either a scalar numeric handle, or any size array of graphics objects.
            % If the argument is passed using the 'Parent' P/V pair, then we will
            % catch any graphics handle(s), and not just Axes.
            if nargs >= pind && ...
                    ((isnumeric(args{pind}) && isscalar(args{pind}) && isgraphics(args{pind})) ...
                    || isa(args{pind},'matlab.graphics.Graphics'))
                ax = handle(args{pind});
                args(inds) = [];
                nargs = length(args);
            end
        end
    end
    
    % Make sure that the graphics handle found is a scalar handle, and not an
    % empty graphics array or non-scalar graphics array.
%     if (nargs < nargin) && ~isscalar(ax)
%         throwAsCaller(MException(message('MATLAB:graphics:axescheck:NonScalarHandle')));
%     end
    
    % Throw an error if a deleted graphics handle is detected.
%     if ~isempty(ax) && ~isvalid(ax)
%         % It is possible for a non-Axes graphics object to get through the code
%         % above if passed as a Name/Value pair. Throw a different error message
%         % for Axes vs. other graphics objects.
%         if(isa(ax,'matlab.graphics.axis.AbstractAxes') || isa(ax,'matlab.ui.control.UIAxes'))
%             throwAsCaller(MException(message('MATLAB:graphics:axescheck:DeletedAxes')));
%         else
%             throwAsCaller(MException(message('MATLAB:graphics:axescheck:DeletedObject')));
%         end
%     end
end


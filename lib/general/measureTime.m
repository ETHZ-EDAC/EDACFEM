% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function time = measureTime(time,string,varargin)

string = matlab.lang.makeValidName(string); % valid variable name
if ~isempty(time)
    string = matlab.lang.makeUniqueStrings(string,fields(time)); % make it unique, so each measurement is taken and stored
end

if isfield(time,string)
    error('Attempted to measure time which was allready stopped: %s!',string);
end

if ~isfield(time,'started') || ~isfield(time.started,string)
    % start the clock
    time.started.(string) = tic;
    
elseif isfield(time,'started') && isfield(time.started,string)
   % take measurement
    time.(string) = toc(time.started.(string));
    % delete starting value
    time.started = rmfield(time.started,string);
    if ~isempty(varargin) && strcmp(varargin(1),'print')
        % and print to screen
        fprintf('Time to "%s": %s\n',string,toTime(time.(string)));
    end

    if isempty(fields(time.started))
        % delete started struct if its empty
        time = rmfield(time,'started');
    end
else
    error('Attempt to measure time which was never started: %s!',string);
end
end
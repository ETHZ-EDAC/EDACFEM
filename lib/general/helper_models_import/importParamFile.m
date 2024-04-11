% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function out = importParamFile(fn)
% create empty template
out = struct();

% open file
fid = fopen(fn);

% read file line by line
while true
    % current line
    curL = fgetl(fid);

    % break at end of file
    if curL == -1 
        break
    end
    
    % skip empty or commented lines
    if ~isempty(curL) && curL(1)~='%' 
        % split line
        curL = strsplit(curL,',');

        % initialize vector with current values
        curV = zeros(size(curL,2)-1,1); 

        % get first value
        curV(1) = str2double(curL{2});  

        % if not nan, it is either a number or array of numbers
        if ~isnan(curV(1)) 
            % load all numbers except the first one
            for i= 2:length(curL)-1
                curV(i) = str2double(curL{i+1});
            end

            % put in output struct
            out.(curL{1}) = curV;

        % if curV(1) is nan, it is text
        else 
            % load to output struct if only one entry is given
            if size(curL,2)==2
                out.(curL{1}) = curL{2};

            % reassemble to string
            else
                % empty string
                string = [];

                % assemble string
                for i=2:size(curL,2)
                    string = [string,curL{i},','];
                end

                % delete last comma
                string(end) = [];

                % put in output struct
                out.(curL{1}) = string;
            end
        end
    end
end

% close file
fclose(fid);
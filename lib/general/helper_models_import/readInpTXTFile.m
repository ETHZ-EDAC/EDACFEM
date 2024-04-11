% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [out types] = readInpTXTFile(fn)

% try reading the text file
try
    % open file
    fid = fopen(fn);

    % initialize counter for header lines
    header = 0;
    while 1
        % read a line
        curL = fgetl(fid);

        % Stop counting header lines if line does not start with '%'
        if ~isempty(curL) && curL(1)~='%'
            break
        end

        % Count header lines
        header = header + 1; 
    end

    % close file
    fclose(fid);

    % read variable types if output is called
    if nargout==2
        types = strsplit(curL);
    end

    % dlmread(filename,delimiter,R1,C1) starts reading at row offset R1 and column offset C1
    out = dlmread(fn,'\t',header+1,0);

% stop at error
catch e
    % print error identifier
    fprintf(2,'Error during importing: %s!\n',fn);
    fprintf(2,'The identifier was:\n%s\n\n',e.identifier);
    
    % open text file
    winopen(fn);
    
    % print error message
    error('There was an error! The message was:\n%s',e.message);
    
end

end
% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function s = toTime(s)

    h = floor(s/3600);
    m = floor((s)/60)-h*60;
    s = round(s-h*3600-m*60,2);
    
    if h~=0
        if m==0&s==0
            s = sprintf('%ih',h);
        elseif s==0
            s = sprintf('%ih%02im',h, m);
        else
            s = sprintf('%ih%02im%04.1fs',h, m ,s);
        end
    elseif m~=0
        if s==0,
            s = sprintf('%02im',m);
        else
            s = sprintf('%02im%04.1fs',m ,s);
        end
    else
        s = sprintf('%04.1fs',s);
    end

end
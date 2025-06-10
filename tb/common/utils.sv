package utils;
    
    function int min(input int x, input int y);
        return (x > y) ? y : x;
    endfunction

    function int max(input int x, input int y);
        return (x > y) ? x : y;
    endfunction
endpackage
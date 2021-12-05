function [h_t] = h_t(t, h, a_h, b_h)

    h_t = a_h*(1-h) - b_h*h;
    
end


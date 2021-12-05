function [x,y] = rg4(h, x0, xf, y0, y_dot)

    x = x0:h:xf; %intervalo de x
    y = zeros(1,length(x));
    y(1) = y0;   % valor inicial de y
    
    n = length(x)-1;
    
    for i = 1:n

        k1 = y_dot(x(i),y(i));
        k2 = y_dot(x(i)+.5*h,y(i)+.5*k1*h);
        k3 = y_dot(x(i)+.5*h,y(i)+.5*k2*h);
        k4 = y_dot(x(i)+h,y(i)+k3*h);
        y(i+1) = y(i)+((k1+2*k2+2*k3+k4)/6)*h;
    end
end
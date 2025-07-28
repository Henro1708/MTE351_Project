function v = trapezoid_velocity(t, vmax, a, d)
% Outputs velocity v at time t

tr = vmax / a;
dr = 0.5 * vmax * tr;

if 2*dr >= d
    % Triangular profile
    tr = sqrt(d / a);
    vmax_adj = a * tr;
    if t < tr
        v = a * t;
    elseif t < 2 * tr
        v = vmax_adj - a * (t - tr);
    else
        v = 0;
    end
else
    dc = d - 2 * dr;
    tc = dc / vmax;
    T = 2 * tr + tc;

    if t < tr
        v = a * t;
    elseif t < tr + tc
        v = vmax;
    elseif t < T
        v = vmax - a * (t - tr - tc);
    else
        v = 0;
    end
end

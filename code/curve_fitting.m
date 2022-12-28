function [p] = curve_fitting(emg,win_size)
    x = 1:1:win_size+1;
    fitted_weight = fit(x',emg','poly2');
    p1 = fitted_weight.p1;
    p2 = fitted_weight.p2;
    p3 = fitted_weight.p3;
    p = [p1 p2 p3];
end


function [p, t, q, o3, wkl] = model_erai_input(filename, lat, lon, first_day, last_day) 
    [p, t, q, o3] = read_erai_profiles(filename, lat, lon, first_day, last_day);
    nlayers = length(p)-1;
    wkl = zeros(7, nlayers+1);
    wkl(1, :) = q(1, 1:nlayers+1);
    wkl(3, :) = o3(1, 1:nlayers+1);

end
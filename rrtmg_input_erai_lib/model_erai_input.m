function [p, t, q, o3, pz1, tz, wkl, cc, ciwc, clwc, rie, rle] = model_erai_input(filename, lat, lon, first_day, last_day) %#ok<STOUT>
    [p, t, q, o3] = read_erai_profiles(filename, lat, lon, first_day, last_day);
    tz = t(1, :);
    pz1 = p(1, :);
    nlayers = length(tz)-1;
    wkl = zeros(7, nlayers+1);
    wkl(1, :) = q(1, 1:nlayers+1);
    wkl(3, :) = o3(1, 1:nlayers+1);
    for var_name = {'cc', 'clwc', 'ciwc', 'rle', 'rie'}
        eval([var_name{1}, '= zeros(size(p));']);
    end
end
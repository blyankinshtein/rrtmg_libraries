function [p, t, q, o3] = read_erai_profiles(filename, lat, lon, first_day, last_day) %#ok<STOUT,INUSD>
% reads pressure hPa, temperature K, wv volume mixing ratio, ozone volume mixing ratio profiles
% form ERA Interim for the given day range over the given station (1-10)
    p = double(ncread(filename, 'level'))'; % "millibars" ; "pressure_level" ;
    p = flip(p);
    for var_name = {'t', 'q', 'o3'}
        eval([var_name{1}, '= read_erai_levels(filename, ''', var_name{1}, ''',  lat, lon, first_day, last_day);'  ]);
    end
    q = 28.960*q ./ 18.016; %#ok<NODEF> %specific humidity -> volume mixing ratio
    o3 = 28.960*o3 ./ 47.998; %#ok<NODEF> %mass mixing ratio ->  volume mixing ratio
end
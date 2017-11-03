function [idx_lon, idx_lat] = pick_point(filename, lat, lon, type)
    if strcmp(type, 'ceres')
        longitude = ncread(filename, 'lon');
        latitude = ncread(filename, 'lat');
    end
    if strcmp(type, 'erai')
        longitude = ncread(filename, 'longitude');
        latitude = ncread(filename, 'latitude');
    end
    
    longitude(longitude > 180) = longitude(longitude > 180) - 360;
    [~, idx_lat] = min(abs(lat - latitude));
    [~, idx_lon] = min(abs(lon - longitude));
end
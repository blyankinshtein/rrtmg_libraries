function [idx_lon, idx_lat] = pick_station(filename, station_num, type)
    load('../Formation_analysis/data/series.mat', 'stations');
    if strcmp(type, 'ceres')
        longitude = ncread(filename, 'lon');
        latitude = ncread(filename, 'lat');
    end
    if strcmp(type, 'erai')
        longitude = ncread(filename, 'longitude');
        latitude = ncread(filename, 'latitude');
    end
    
    longitude(longitude > 180) = longitude(longitude > 180) - 360;
    lat = stations.lat(station_num);
    lon = stations.lon(station_num);
    [~, idx_lat] = min(abs(lat - latitude));
    [~, idx_lon] = min(abs(lon - longitude));
end
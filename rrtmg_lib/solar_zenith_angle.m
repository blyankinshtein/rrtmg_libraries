function sza = solar_zenith_angle(day_time, lat, lon)
    % solar zenith angle at the point
    % day_time in datetime format
    % lat in range (-90, 90)
    % lon in range (0, 360) or (-180, 180)
    if lon>180
        lon = lon - 360;
    end
    %d = day(day_time,'dayofyear');
    d = days(day_time - datetime([2000 01 01 12 00 00]));
    time = hour(day_time) + (minute(day_time) + second(day_time)/60.)/60.;
    delta = solar_declination_angle(d);
    h = solar_hour_angle(lon, time, d);
    lat = lat/180.*pi;
    sza = acos(sin(lat)*sin(delta) + cos(lat)*cos(delta)*cos(h));
    sza = sza/pi*180;
end
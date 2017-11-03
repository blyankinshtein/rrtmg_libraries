function av_sza = average_solar_zenith_angle(day_time, frame, step, lat, lon)
    % solar zenith angle average at times (day_time-frame:step:day_time+frame) 
    % values of 90 for nighttime 
    % day_time in datetime format
    % frame in hours
    % step in hours
    % lat in range (-90, 90)
    % lon in range (0, 360) or (-180, 180)
    szas = [];
    for i = day_time+ hours(-frame:step:frame)
        sza = solar_zenith_angle(i, lat, lon);
        szas = [szas, sza];
    end
    szas(szas>90)=90;
    av_sza = mean(szas);
end
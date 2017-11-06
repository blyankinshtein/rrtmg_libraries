function delta = solar_declination_angle(juldat)
% adapted from http://www.psa.es/sdg/sunpos.htm
    omega = 2.1429 - 0.0010394594 * juldat;
    mean_longitude = 4.8950630 + 0.017202791698 * juldat;
    mean_anomaly = 6.2400600 + 0.0172019699 * juldat;
    longitude = mean_longitude + 0.03341607 * sin(mean_anomaly) + 0.00034894*sin( 2 * mean_anomaly) - 0.0001134 - 0.0000203 * sin(omega);
    obliquity = 0.4090928 - 6.2140e-9 * juldat +0.0000396 * cos(omega);
    delta = asin(sin(obliquity) * sin(longitude));
end

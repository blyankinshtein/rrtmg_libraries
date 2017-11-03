function h = solar_hour_angle(lon, time, d)
    %B = 2 * pi / 365. * (d - 81);
    %EoT = 9.87 * sin(2*B) - 7.53 * cos(B)-1.5 * sin(B);
    B = 6.24004077 + 0.01720197 * d;
    EoT = 9.863 * sin(2*B + 3.5932) - 7.659 * sin(B);
    LST = lon / 15. + time + EoT / 60.;
    h = 15. * (LST - 12.) * pi / 180.;
end
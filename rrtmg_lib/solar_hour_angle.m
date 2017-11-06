function h = solar_hour_angle(lon, time, d)
% adapted form https://en.wikipedia.org/wiki/Equation_of_time
    B = 6.24004077 + 0.01720197 * d;
    EoT = 9.863 * sin(2*B + 3.5932) - 7.659 * sin(B);
    LST = lon / 15. + time + EoT / 60.;
    h = 15. * (LST - 12.) * pi / 180.;
end

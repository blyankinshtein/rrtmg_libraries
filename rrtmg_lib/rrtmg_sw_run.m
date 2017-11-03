function [heatrate, ssrd, ssr, tsr, tisr] = rrtmg_sw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle, juldat, sza, albedo)
    %runs shortwave rapid radiative transfer model
    %pz1 - pressure at levels in hPa
    %pavg - pressure in layers in hPa
    %tz1 - temperature at levels in K
    %tavg - temperature in layers in K
    %wkl - matrix with greenhouse species
    %cc - cloud cover, fraction
    %clwc - cloud liquid water content
    %ciwc - cloud ice water content
    %rie - effective radius of ice particles
    %rle - effective radius of liquid particles
    %juldat - julian day of the year
    %sza - solar zenith angle
    %albedo - surface albedo
    %heatrate - shortwave radiative heating rate at levels in K/day
    %ssrd - surfacr solar radiation flux downwards in W/m^2, positive downwards
    %ssr - surface net solar radiation flux in W/m^2, positive downwards
    %tsr - TOA net solar radiation flux in W/m^2, positive downwards
    %tisr - TOA incident solar radiation flux in W/m^2

    nlayers = length(tavg);
    wbrodl = broad(pz1, wkl);
    %% make cloud input
    if(sum(cc(1:nlayers)) > 0) 
        cflag=1;
        cloud_input(cc, clwc, ciwc, rie, rle, pz1, wkl);
     else
        cflag=0;
     end 
    %% make RRTMG input
    if sza <90
        rrtmg_sw_input(cflag, nlayers, pavg, tavg, pz1, tz1, wkl, wbrodl, juldat, sza, albedo);
        %% run RRTMG
        system([rrtmg_folder, '/rrtmg_sw_v3.9_linux_intel &> /dev/null']);  % run rrtmg model
        %% parse output data
        INDATA = importdata('OUTPUT_RRTM', ' ', 5);
        INDATA = INDATA.data;
        heatrate = zeros(1, nlayers+1);
        heatrate(:) = flipud(INDATA(:, 8));
        ssrd = INDATA(nlayers + 1, 6);
        ssr = INDATA(nlayers + 1, 7);
        tsr = INDATA(1, 7);
        tisr = INDATA(1, 6);
    else
        heatrate = zeros(1, nlayers+1);
        ssrd = 0;
        ssr = 0;
        tsr = 0;
        tisr = 0;
    end
end
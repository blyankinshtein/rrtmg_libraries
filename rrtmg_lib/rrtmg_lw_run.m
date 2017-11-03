function [heatrate, ttr, surfaceflux] = rrtmg_lw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle)
    %runs longwave rapid radiative transfer model
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
    %heatrate - longwave radiative heating rate at levels in K/day
    %ttr - outgoing longwave radiation flux in W/m^2
    %surfaceflux - net surface longwave radiative flux in W/m^2, positive upwards
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
    rrtmg_lw_input(cflag, nlayers, pavg, tavg, pz1, tz1, wkl, wbrodl)
    %% run RRTMG
    system([rrtmg_folder, '/rrtmg_lw_v4.85_linux_intel &> /dev/null']);  % run rrtmg model
    %% parse output data
    INDATA = importdata('OUTPUT_RRTM', ' ', 3);
    INDATA = INDATA.data;
    ttr = INDATA(1, 5);
    heatrate = zeros(1, nlayers+1);
    heatrate(:) = flipud(INDATA(:, 6));
    surfaceflux = INDATA(nlayers + 1,5);
end
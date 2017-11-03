function [zh, pz1, tz1, wkl] = read_standard_profile(profile_name, sparse_layers)
    % profile_name = 'day'/'ngt'/'win'/'sum'/'equ'
    % if sparse_layers = 1, delete layers that are closer than pressure_dif_tresh
    pressure_dif_tresh = 0.01;
    
    filename = strcat('./atmos_profile/',profile_name,'.atm');
    profile = zeros(121,12);
    for i = 1:12
        INDATA = importdata(filename, ' ', 25+26*(i-1));
        INDATA = reshape(transpose(INDATA.data), 125, 1);
        INDATA = INDATA(1:121);
        profile(:, i) = INDATA;
    end
    nlayers = size(profile, 1) - 1;
    % delete layers that are too close:
        pz1(:) = profile(1 : nlayers + 1, 2);
    if sparse_layers
        deltap = diff(pz1);
        idx = abs(deltap) < pressure_dif_tresh;
        idx = [false, idx];
        profile = profile(~idx, :);
        nlayers = size(profile, 1) - 1;
    end 

    zh = profile(1:nlayers + 1, 1)' * 1000; %km to m
    pz1 = profile(1:nlayers + 1, 2)';
    tz1 = profile(1:nlayers + 1, 3)';

    wkl = zeros(7, nlayers + 1); % concentrations of molecular species (parts per unit volume)
    wkl(1, :) = profile(1:nlayers + 1, 8) * 10^(-6); %H2O 
    wkl(2, :) = profile(1:nlayers + 1, 6) * 10^(-6); %CO2 
    wkl(3, :) = profile(1:nlayers + 1, 7) * 10^(-6); %O3  
    wkl(4, :) = profile(1:nlayers + 1, 10) * 10^(-6); %N2O
    wkl(5, :) = profile(1:nlayers + 1, 12) * 10^(-6);%CO
    wkl(6, :) = profile(1:nlayers + 1, 9) * 10^(-6); %CH4
    %wkl(7,:) %O2
end
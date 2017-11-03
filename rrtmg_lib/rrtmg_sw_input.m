function rrtmg_sw_input(cflag, nlayers, pavg, tavg, pz1, tz1, wkl, wbrodl, juldat, sza, albedo)
% make RRTMG SW input
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename = 'INPUT_RRTM';
    fileID=fopen(filename, 'wt');
    
    % record 1.1
    slist = '$ ATMOSPHERE PROFILE';
    fprintf(fileID, '%s\n', slist);
    
    % record 1.2
    iaer = 0;		%flag for aerosols (0,10)		
    iatm = 0;		%flag for RRTATM (0,1->yes)		
    iscat = 1;      %switch for DISORT or simple two-stream scattering (0-> DISORT (unavailable), 1->  two-stream (default))
    istrm = 0;      %flag for number of streams used in DISORT  (ISCAT must be equal to 0)
    iout = 0;		%-1 no output% 0 for 820-50000% n from band n% 98 15 spectral bands
    imca = cflag;	%flag for McICA of sub-grid cloud fraction	
    icld = cflag;	%0-no cloudy	
    idelm = 0;      %flag for outputting downwelling fluxes computed using the delta-M scaling approximation
    icos = 0;       %no account for instrumental cosine response (default)
    fprintf(fileID, '%20i%30i%33i%2i%5i%4i%1i%4i%1i\n', iaer, iatm, iscat, istrm, iout, imca, icld, idelm, icos);

    % record 1.2.1
    %juldat = day(day_time,'dayofyear');    %Julian day associated with calculation (1-365/366 starting January 1).
    fprintf(fileID, '%15i%10.4f\n', juldat, sza); 

    % record 1.4
    iemis = 1	;	%surface emissivity (0-1.0,1-same emissivity,2-different)
    ireflect = 0;	%reflected radiance is equal at all angles
    semiss = 1. - albedo;	%surface emissivity
    fprintf(fileID, '%12i%3i%5.3f\n', iemis, ireflect, semiss); 

    % record 2.1
    iform = 0;		%column amount format flag
    n = nlayers;	%maximum 200
    nmol = 7;		%maximum 35
    fprintf(fileID, '%2i%3i%5i\n', iform, n, nmol);
    % record 2.1.1
    fprintf(fileID, '%10.4f%10.4f%31.3f%7.2f%15.3f%7.2f\n', pavg(1), tavg(1), pz1(1), tz1(1), pz1(2), tz1(2)); 
    % record 2.1.2
    fprintf(fileID, '%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e\n', wkl(1,1), wkl(2,1), wkl(3,1), wkl(4,1), wkl(5,1), wkl(6,1), wkl(7,1), wbrodl(1));
    % record 2.1.2
    for ii=2:n 
        fprintf(fileID, '%10.4f%10.4f%53.3f%7.2f\n', pavg(ii), tavg(ii), pz1(ii+1), tz1(ii+1));
        fprintf(fileID, '%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e%10.3e\n', wkl(1,ii), wkl(2,ii), wkl(3,ii), wkl(4,ii), wkl(5,ii), wkl(6,ii), wkl(7,ii), wbrodl(ii)); 
    end
    
    fprintf(fileID, '%s', '%%%%%');
end
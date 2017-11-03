function rrtmg_lw_input(cflag, nlayers, pavg, tavg, pz1, tz1, wkl, wbrodl)
% make RRTMG LW input
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename = 'INPUT_RRTM';
    fileID=fopen(filename, 'wt');

    % record 1.1
    slist = '$ ATMOSPHERE PROFILE';
    fprintf(fileID, '%s\n', slist); 

    % record 1.2
    iaer = 0;		%flag for aerosols (0,10)
    iatm = 0;		%flag for RRTATM (0,1->yes)
    ixsect = 0;	%flag for cross-sections(0,1)
    numangs = 0;	%only option, a angle
    iout = 0;		%-1 no output% 0 for 10-3250% n from band n% 99 17 spectral bands
    idrv = 0;		%flag for upward flux to temp change in surface
    imca = cflag;		%flag for McICA of sub-grid cloud fraction
    icld = cflag;		%0-no cloudy
    fprintf(fileID, '%20i%30i%20i%15i%5i%2i%2i%1i\n', iaer, iatm, ixsect, numangs, iout, idrv, imca, icld); 

    % record 1.4
    tbound = -99.9; 	%surface temp(mls)
    iemis = 1	;	%surface emissivity (0-1.0,1-same emissivity,2-different)
    ireflect = 0;	%
    semis = 0.96;	%surface emissivity
    fprintf(fileID, '%10.3f%2i%3i%5.3f\n', tbound, iemis, ireflect, semis);   

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
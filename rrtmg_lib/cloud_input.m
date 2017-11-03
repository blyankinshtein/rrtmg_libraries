function cloud_input(cc, clwc, ciwc, rie, rle, pz1, wkl)
% make cloud input for RRTNG_LW
    cfile = 'IN_CLD_RRTM';
    fileID=fopen(cfile,'wt');
    %record C1.1
    inflag = 2;
    iceflag = 2;
    liqflag = 1;
    fprintf(fileID, '%5i%5i%5i\n', inflag, iceflag, liqflag);
    %record C1.2
    indyc = find(cc > 0);
    lay = indyc;
    n = length(indyc);
    cldfrac = cc(indyc);
    fracice = ciwc(indyc)./(ciwc(indyc)+clwc(indyc));
    effradliq = rle(indyc);
    effradice = rie(indyc);
    effradice(effradice < 5) = 5;
    effradice(effradice > 131) = 131;
    effradliq(effradliq < 2.5) = 2.5;
    effradliq(effradliq > 60) = 60;
    dp = pz1(1:length(pz1) - 1) - pz1(2:length(pz1));
    g = 9.8;
    cwp = 1e2 * 1e3 * (ciwc(indyc) + clwc(indyc)) .* dp(indyc) ./ g ./ (1 + wkl(1, indyc) + ciwc(indyc) + clwc(indyc));

    for i=1:n
        fprintf(fileID, '%5i%10.5f%10.5f%10.5f%10.5f%10.5f\n', lay(i), cldfrac(i), cwp(i), fracice(i), effradice(i), effradliq(i));
    end 

    testchar = '%';
    fprintf(fileID,'%s',testchar);
end
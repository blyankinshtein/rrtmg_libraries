function [pz, tz, pavg, tavg, wkl_new, cc_new, clwc_new, ciwc_new, rie_new, rle_new] = form_input(p, t, p_s, t_s, wkl, cc, clwc, ciwc, rie, rle)
    pavg = p;
    tavg = t;  
    
    n_to_cut = length(find(pavg > p_s));

    pavg = pavg(n_to_cut+1: length(pavg));
    tavg = tavg(n_to_cut+1: length(tavg));
    wkl_new = wkl(:, n_to_cut+1: size(wkl, 2));
    for varname = {'cc', 'clwc', 'ciwc', 'rie', 'rle'}
        eval([varname{1}, '_new = ', varname{1}, '(n_to_cut+1: size(', varname{1},', 2));']);
    end
    pz = [p_s, (pavg(1:length(pavg)-1)+pavg(2:length(pavg)))./2, 0.5];
    tz = [t_s, interp1(log(pavg), tavg, log(pz(2:length(pz))), 'linear', 'extrap')];
end
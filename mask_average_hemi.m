folder = '/media/veronica/DATAPART2/Data_MNI/reconstructions_sAE/';
mask_list={};
for i = 1:10 %pat_idxs
    Path = [folder 'Vero_050820_5c_haxial_sAE-10boot-' char(string(i-1)) '/'];
    im=fullfile(Path, 'ab_mask.nii');

    if (exist(im, 'file')~=0)
        mask_list{end+1,1} = strcat(im, ',1');
    else
        disp(im);
    end
end

spm_jobman('initcfg');

matlabbatch{1}.spm.util.imcalc.input = mask_list;
matlabbatch{1}.spm.util.imcalc.output = 'Mask_sum';
matlabbatch{1}.spm.util.imcalc.outdir = {folder};
matlabbatch{1}.spm.util.imcalc.expression = 'median(X)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{1}.spm.util.imcalc.options.mask = -1;
matlabbatch{1}.spm.util.imcalc.options.interp = 0;

spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
clear matlabbatch



%%

pat_L = [1,4,5,9,11,15,20,25,29,51,52,54,57,59,69,70,76,77,79,81,86,94,97,103,107,108,109,111,113,115,116,118,119,120,121,122,123,125,126,128]+130;
pat_R = [3,5,6,8,12,13,16,18,19,22,24,26,29,30,31,37,53,56,57,58,60,63,66,68,75,76,78,80,101,113,114,115,117,118,120,123,124]+1;
pat_idxs = [pat_L,pat_R];

for m = 1:10
    Path = ['/media/veronica/DATAPART2/Data_MNIcenter/reconstructions_sAE/Vero_231020_5c_haxial_sAE-10boot-' char(string(m-1)) '/'];
    
%     Subj_dir = dir([Path 'Patients/' '*']);
%     Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));
%     
%     pat_list={};
%     for i = 1:size(Subj_dir,1) %1:size(Subj_dir,1) %pat_idxs %
%         im=fullfile(Subj_dir(i,1).folder, Subj_dir(i,1).name);
%         
%         if (exist(im, 'file')~=0)
%             pat_list{end+1,1} = strcat(im, ',1');
%         else
%             disp(Subj_dir(i,1).name);
%         end
%     end
%     
%     spm_jobman('initcfg');
%     
%     matlabbatch{1}.spm.util.imcalc.input = pat_list;
%     matlabbatch{1}.spm.util.imcalc.output = 'Pat_median';
%     matlabbatch{1}.spm.util.imcalc.outdir = {Path};
%     matlabbatch{1}.spm.util.imcalc.expression = 'median(X)';
%     matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
%     matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
%     matlabbatch{1}.spm.util.imcalc.options.mask = -1;
%     matlabbatch{1}.spm.util.imcalc.options.interp = 0;
%     
%     spm('defaults', 'FMRI');
%     spm_jobman('run', matlabbatch);
%     clear matlabbatch

    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.util.imcalc.input = {
                                        [Path 'Con_median.nii,1']
                                        [Path 'Pat_median.nii,1']
                                        };
    matlabbatch{1}.spm.util.imcalc.output = 'diff_m';
    matlabbatch{1}.spm.util.imcalc.outdir = {Path};
    matlabbatch{1}.spm.util.imcalc.expression = 'i2-i1';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 0;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
    clear matlabbatch
end



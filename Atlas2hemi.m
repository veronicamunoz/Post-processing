clear all

%Path = '/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Controls/';
Path = '/media/veronica/DATAPART2/DTI_PPMI/Processed/Patients_48months/';
Path2 = '/media/veronica/DATAPART2/DTI_PPMI/DTI_MRtrix_hemi/Patients_48months/';

cd(Path)
Subjects_dir= dir([ Path '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir

for i = 1:size(Subjects_dir,1) 
    def = fullfile(Path, Subjects_dir(i,1).name, 'iy_dtifit_S0.nii');
%     def = fullfile(Path, Subjects_dir(i,1).name, 'iy_dtifit_MD.nii');
%     if (exist(fullfile(Path, Subjects_dir(i,1).name, 'iy_rdtiAnat.nii'),'file')~=0)
%         def=fullfile(Path, Subjects_dir(i,1).name, 'iy_rdtiAnat.nii');
%     end

    if (exist(def, 'file')~=0) && (exist(fullfile(Path2, ['l_' Subjects_dir(i,1).name]), 'dir')~=0)
        disp(['Processing ' Subjects_dir(i,1).name]); 

        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.defs.comp{1}.def = {def};
        matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
                                                           '/home/veronica/Donnees/JHU_labels_hemi_R.nii'
                                                           '/home/veronica/Donnees/nifti_diff/labels_Neuromorphometrics_hemi_R.nii'
                                                           };
        matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {fullfile(Path2, ['r_' Subjects_dir(i,1).name])};
        matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
        matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
        matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
        matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = '';
        spm('defaults', 'FMRI');
        spm_jobman('run', matlabbatch);
        clear matlabbatch
    
        mask_info = niftiinfo(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_R.nii'));
        mask = niftiread(mask_info);
        mask_info.ImageSize(1:2)=[64,112];
        niftiwrite(mask(12:75,1:112,:), fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_R.nii'), mask_info);
       
        mask_info = niftiinfo(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_R.nii'));
        mask = niftiread(mask_info);
        mask_info.ImageSize(1:2)=[64,112];
        niftiwrite(mask(12:75,1:112,:), fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_R.nii'), mask_info);

        movefile(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_R.nii'),fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'JHU_labels.nii'))
        movefile(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_R.nii'),fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'GM_labels.nii'))

        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.defs.comp{1}.def = {def};
        matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
                                                           '/home/veronica/Donnees/JHU_labels_hemi_L.nii'
                                                           '/home/veronica/Donnees/nifti_diff/labels_Neuromorphometrics_hemi_L.nii'
                                                           };
        matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {fullfile(Path2, ['l_' Subjects_dir(i,1).name])};
        matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
        matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
        matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
        matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = '';
        spm('defaults', 'FMRI');
        spm_jobman('run', matlabbatch);
        clear matlabbatch

        mask_info = niftiinfo(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_L.nii'));
        mask = niftiread(mask_info);
        mask = flip(mask,1);
        mask_info.ImageSize(1:2)=[64,112];
        niftiwrite(mask(12:75,1:112,:), fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_L.nii'), mask_info);
       
        mask_info = niftiinfo(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_L.nii'));
        mask = niftiread(mask_info);
        mask = flip(mask,1);
        mask_info.ImageSize(1:2)=[64,112];
        niftiwrite(mask(12:75,1:112,:), fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_L.nii'), mask_info);

        movefile(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wJHU_labels_hemi_L.nii'),fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'JHU_labels.nii'))
        movefile(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wlabels_Neuromorphometrics_hemi_L.nii'),fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'GM_labels.nii'))

    else
        disp("Missing something");

    end
    %end
end
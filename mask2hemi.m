clear all

Path = '/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Patients/';
Path2 = '/media/veronica/DATAPART2/DTI_PPMI/DTI_MRtrix_hemi/Patients/';

cd(Path)
Subjects_dir= dir([ Path '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir

for i = 1:size(Subjects_dir,1) 
    def = fullfile(Path, Subjects_dir(i,1).name, 'iy_dtifit_MD.nii');
    if (exist(fullfile(Path, Subjects_dir(i,1).name, 'iy_rdtiAnat.nii'),'file')~=0)
        def=fullfile(Path, Subjects_dir(i,1).name, 'iy_rdtiAnat.nii');
    end

    if (exist(def, 'file')~=0) && (exist(fullfile(Path2, ['l_' Subjects_dir(i,1).name]), 'dir')~=0)
        disp(['Processing ' Subjects_dir(i,1).name]); 

        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.defs.comp{1}.def = {def};
        matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_sAE/mask_sAE.nii'
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_sVAE/mask_sVAE.nii'
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_dVAE/mask_dVAE.nii'
                                                           };
        matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {fullfile(Path2, ['r_' Subjects_dir(i,1).name])};
        matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
        matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
        matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
        matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = '';
        spm('defaults', 'FMRI');
        spm_jobman('run', matlabbatch);
        clear matlabbatch
        
        mask_info = niftiinfo(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sAE.nii'));
        mask_info.ImageSize(1:2)=[64,112];

        sAE_mask = niftiread(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sAE.nii'));
        sVAE_mask = niftiread(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sVAE.nii'));
        dVAE_mask = niftiread(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_dVAE.nii'));

        niftiwrite(sAE_mask(12:75,1:112,:), fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sAE.nii'), mask_info);
        niftiwrite(sVAE_mask(12:75,1:112,:), fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sVAE.nii'), mask_info);
        niftiwrite(dVAE_mask(12:75,1:112,:), fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_dVAE.nii'), mask_info);
        
        movefile(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sAE.nii'),fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'mask_sAE.nii'))
        movefile(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_sVAE.nii'),fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'mask_sVAE.nii'))
        movefile(fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'wmask_dVAE.nii'),fullfile(Path2, ['r_' Subjects_dir(i,1).name], 'mask_dVAE.nii'))
        
        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.defs.comp{1}.def = {def};
        matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_sAE/mask_sAEl.nii'
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_sVAE/mask_sVAEl.nii'
                                                           '/media/veronica/DATAPART2/Data_Hemi/reconstructions_dVAE/mask_dVAEl.nii'
                                                           };
        matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {fullfile(Path2, ['l_' Subjects_dir(i,1).name])};
        matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
        matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
        matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
        matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = '';
        spm('defaults', 'FMRI');
        spm_jobman('run', matlabbatch);
        clear matlabbatch
        
        mask_info = niftiinfo(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sAEl.nii'));
        mask_info.ImageSize(1:2)=[64,112];

        sAE_mask = niftiread(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sAEl.nii'));
        sVAE_mask = niftiread(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sVAEl.nii'));
        dVAE_mask = niftiread(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_dVAEl.nii'));
        
        sAE_mask = flip(sAE_mask,1);
        sVAE_mask = flip(sVAE_mask,1);
        dVAE_mask = flip(dVAE_mask,1);

        niftiwrite(sAE_mask(12:75,1:112,:), fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sAEl.nii'), mask_info);
        niftiwrite(sVAE_mask(12:75,1:112,:), fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sVAEl.nii'), mask_info);
        niftiwrite(dVAE_mask(12:75,1:112,:), fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_dVAEl.nii'), mask_info);
        
        movefile(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sAEl.nii'),fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'mask_sAE.nii'))
        movefile(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_sVAEl.nii'),fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'mask_sVAE.nii'))
        movefile(fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'wmask_dVAEl.nii'),fullfile(Path2, ['l_' Subjects_dir(i,1).name], 'mask_dVAE.nii'))

    else
        disp("Missing something");

    end
    %end
end

%  im_info = niftiinfo('/media/veronica/DATAPART2/Data_Hemi/reconstructions_dVAE/mask_dVAE.nii');
%  im = niftiread(im_info);
%  im = flip(im,1);
%  niftiwrite(im, '/media/veronica/DATAPART2/Data_Hemi/reconstructions_dVAE/mask_dVAEl.nii', im_info);
% 


   

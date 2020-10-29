clear all
Path='/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Controls/';
hsign=niftiinfo('/home/veronica/Donnees/PPMI/DTI_PPMI/rAnat.nii');
%Path2='/media/veronica/DATAPART2/Signatures_PPMI/Reference_model/Type_Control/Initial_roi_Brain/Dimensions_FA-MD/Model_for_EM_mmsd/ReferenceGroups_1_to_10/2019_03_11_-_15_11_13/Report/';
Path2='/media/veronica/DATAPART2/Signatures_PPMI/Reference_model/Type_Control/Initial_roi_Brain/Dimensions_FA-MD/Model_for_EM_mmsd/ReferenceGroups_1_to_10/2019_03_11_-_15_11_13/Reference_delineation/DelineationGroups_1_to_10/2019_03_13_-_11_59_48/Atypical_model/Type_Control-Patient/AtypicalGroups_1_to_10/2019_03_13_-_11_59_48/Report_post_treatment/';

Subj_dir = dir([Path '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));

for i = 1 :size(Subj_dir,1)
    clust=[Path2 Subj_dir(i,1).name '_clusters.nii'];
    MD=fullfile(Path, Subj_dir(i,1).name, 'dtifit_MD.nii');
    def=fullfile(Path, Subj_dir(i,1).name, 'y_dtifit_MD.nii');
    if (exist(fullfile(Path, Subj_dir(i,1).name, 'y_rdtiAnat.nii'),'file')~=0)
        def=fullfile(Path, Subj_dir(i,1).name, 'y_rdtiAnat.nii');
    end
    
    if (exist(MD,'file')~=0) && (exist(clust,'file')~=0) && (exist(def,'file')~=0)  
        disp(Subj_dir(i,1).name)
        hc=niftiinfo(clust);
        hMD=niftiinfo(MD);
        c=isequal(hc.Transform.T,hMD.Transform.T);
        hc.Transform.T=hMD.Transform.T;
        Vc=niftiread(hc);
        niftiwrite(Vc,clust,hc);
        
        hc=niftiinfo(clust);
        if isequal(hc.Transform.T,hMD.Transform.T)
            clear matlabbatch
            spm_jobman('initcfg');
            matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(Path, Subj_dir(i,1).name, 'y_dtifit_MD.nii')};
            matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {clust};
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'n';
            spm('defaults', 'FMRI');
            spm_jobman('run', matlabbatch);
            clear matlabbatch
        end
    end
end

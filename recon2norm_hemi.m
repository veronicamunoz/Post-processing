clear all

Path = '/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Controls/';
%Path2 = '/media/veronica/DATAPART2/Data_Hemi/reconstructions/Vero_060420_5c1_haxial_sAE/';
hemi_MNI = niftiread('/home/veronica/Donnees/nifti_diff/hemi.nii');

for m = 1:10%!!!
    Path2 = ['/media/veronica/DATAPART2/Data_Hemi/reconstructions_dVAE/Vero_290420_5c_haxial_dVAE-10boot-' char(string(m-1)) '/'];
    mkdir(Path2,'nControls')
    mkdir(Path2,'nControls_hemi')
    disp(Path2)
    
    cd(Path)
    Subjects_dir= dir([ Path '*']);
    Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir

    for i = 1:size(Subjects_dir,1) %[3,5,8,13,18,26,44]%1 : 4 %size(Subjects_dir,1)-1
        r_path = fullfile(Path2,'Controls', ['r_' Subjects_dir(i,1).name, '_m.nii']);
        l_path = fullfile(Path2,'Controls', ['l_' Subjects_dir(i,1).name, '_m.nii']);
        def = fullfile(Path, Subjects_dir(i,1).name, 'y_dtifit_MD.nii');
        hemi_path = fullfile(Path, Subjects_dir(i,1).name, 'defhemi.nii');
        md_path = fullfile(Path, Subjects_dir(i,1).name, 'dtifit_MD.nii');
        if (exist(fullfile(Path, Subjects_dir(i,1).name, 'y_rdtiAnat.nii'),'file')~=0)
            def=fullfile(Path, Subjects_dir(i,1).name, 'y_rdtiAnat.nii');
        end

        if (exist(def, 'file')~=0) && (exist(r_path,'file')~=0) && (exist(l_path,'file')~=0) && (exist(hemi_path,'file')~=0) && (exist(md_path,'file')~=0)
            disp(['Processing ' Subjects_dir(i,1).name]); 

            % Merge right hemi and left hemi into one brain
            r_h = niftiread(r_path);
            l_h = niftiread(l_path);
            hemi = niftiread(hemi_path);
            im_info = niftiinfo(md_path);

            im_r = zeros(im_info.ImageSize);
            im_l = zeros(im_info.ImageSize);
            im_r(12:75,1:112,:) = r_h;
            im_l(12:75,1:112,:) = l_h;

    % imtool(V_ref(:,:,2,1),'DisplayRange',[]); 

            % Flip the left hemispheres back
            im_l = flip(im_l,1);

            % Fill in empty image to reconstruct the brain
            im = im_r;
            im(hemi == 1) = im_l(hemi == 1);

            map_path = fullfile(Path2, 'nControls', strcat(Subjects_dir(i,1).name, '_map.nii'));
            im_info.Filename = map_path;
            niftiwrite(single(im), map_path, im_info);

            % Use deformation champ to deform image into MNI space

            clear matlabbatch
            spm_jobman('initcfg');
            matlabbatch{1}.spm.util.defs.comp{1}.def = {def};
            matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {map_path};
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'n';
            spm('defaults', 'FMRI');
            spm_jobman('run', matlabbatch);
            clear matlabbatch

            % Split normalized images into right and left hemisphere once again
            mni_map_path = fullfile(Path2, 'nControls', strcat('n',Subjects_dir(i,1).name, '_map.nii'));
            mni_info = niftiinfo(mni_map_path);
            r_mni = niftiread(mni_map_path);
            l_mni = niftiread(mni_map_path);
            r_mni(hemi_MNI~=2) = 0;
            l_mni(hemi_MNI~=1) = 0;

            l_mni = flip(l_mni,1);

            niftiwrite(r_mni, fullfile(Path2, 'nControls_hemi', strcat('r_n',Subjects_dir(i,1).name, '.nii')), mni_info);
            niftiwrite(l_mni, fullfile(Path2, 'nControls_hemi', strcat('l_n',Subjects_dir(i,1).name, '.nii')), mni_info);

        else
            disp("Missing something");
        end
    end
end
   

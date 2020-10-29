clear all

Path = '/media/veronica/DATAPART2/ACTEMOVI/Anat/Young/';

cd(Path)
Subjects_dir= dir([ Path '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir

for i = 1:size(Subjects_dir,1) 
    def_dir = dir([Path Subjects_dir(i,1).name '/*T1*' ]);
    if ~isempty(def_dir)
        def = fullfile(def_dir.folder, def_dir.name);
        copyfile(def, fullfile(def_dir.folder, 'Anat.nii'));
        disp(def);
    else
        disp([Subjects_dir(i,1).name 'is empty']);
    end
        
end
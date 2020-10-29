#!/bin/bash

if [ $1 == 'Control' ]
then
	Anat_folder="/media/veronica/DATAPART2/SignaPark/Controls"
elif [ $1 == 'Patient' ]
then
	Anat_folder="/media/veronica/DATAPART2/SignaPark/Patients"
	#Anat_folder="/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Patients"
fi

cd $Anat_folder
#sub_list="$@"
subject="$2"
#for subject in ./*; do 	
	echo $subject
	itksnap \
	-g "$Anat_folder/$subject/rAnat.nii" \
	-o "$Anat_folder/$subject/co_FA.nii" "$Anat_folder/$subject/co_MD.nii" "$Anat_folder/$subject/co_T1map.nii" "$Anat_folder/$subject/co_T2starmap.nii" #\
#	-s "$Anat_folder/$subject/def_PD25-subcortical-complete.nii" \
#	-l "/home/veronica/Donnees/mni_PD25/PD25_completelabels.txt"

	itksnap \
	-g "$Anat_folder/$subject/rAnat.nii" \
	-o "$Anat_folder/$subject/co_pCBF.nii" "$Anat_folder/$subject/co_rCBF.nii" "$Anat_folder/$subject/co_rCBV.nii" "$Anat_folder/$subject/co_MTT.nii" #\
#	-s "$Anat_folder/$subject/def_PD25-subcortical-complete.nii" \
#	-l "/home/veronica/Donnees/mni_PD25/PD25_completelabels.txt"
#done



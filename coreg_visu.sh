#!/bin/bash

if [ $2 == 'Control' ]
then
	Anat_folder="/home/veronica/Donnees/Controls/Control_T1/Last"
	DTI_folder="/home/veronica/Donnees/Controls/Control_DTI"
	CBF_folder="/home/veronica/Donnees/Controls/Control_Perf"
elif [ $2 == 'Patient' ]
then
	Anat_folder="/home/veronica/Donnees/Patients/Park_T1"
	DTI_folder="/home/veronica/Donnees/Patients/Park_DTI/Park"
	CBF_folder="/home/veronica/Donnees/Patients/Park_Perf"
fi

subject="$3"
	
case "$1" in 
"all" )

	### --------------T1-CBF-MD-FA--------------------
	itksnap \
		-g "$Anat_folder/$subject/Anat/rAnat.nii" \
		-o "$CBF_folder/$subject/pcasl/r2c3d_CBF.nii" "$DTI_folder/$subject/MRtrix/r2c3d_FA.nii" "$DTI_folder/$subject/MRtrix/r2c3d_MD.nii" #\
		#-s "$Anat_folder/$subject/$atlas_name" \
		#-l "$Anat_folder/$label_name" 
	;;
"dti" )
	### --------------T1-FA-MD-----------------------
	itksnap \
		-g "$Patient_folder/$subject/Anat/rAnat.nii" \
		-o "$DTI_folder/$subject/DTI/r2c3d_FA.nii" "$DTI_folder/$subject/DTI/r2c3d_MD.nii" 
	;;
"cbf" )
	### -------------T1-CBF-------------------------
	itksnap \
		-g "$Patient_folder/$subject/Anat/rAnat.nii" \
		-o "$CBF_folder/$subject/pcasl/r2c3d_CBF.nii" 
	;;
"atlas" )
	### -------------T1-atlas-----------------------
	itksnap \
	-g "$Anat_folder/$subject/Anat/rAnat.nii" \
	-s "$Anat_folder/$subject/$atlas_name" \
	-l "$Anat_folder/$label_name"
	;;
esac


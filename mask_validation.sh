#!/bin/bash
#main_folder="/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_MRtrix/Patients"
#seg_folder="/media/veronica/DATAPART2/Signatures/Signatures_these/BG_PPMI/2020_08_17_-_19_44_07/Reference_delineation/Atypical_model/Report_post_treatment"
clust_ext="_clusters.nii"

main_folder="/media/veronica/DATAPART2/SignaPark/Patients/"
seg_folder="/media/veronica/DATAPART2/Signatures/Signatures_these/Brain_SignaPark/2020_09_21_-_19_43_16/Reference_delineation/DelineationGroups_1_to_10/2020_10_01_-_10_29_45/Atypical_model/Type_Control-Patient/AtypicalGroups_1_to_10/2020_10_01_-_10_29_45/Report_post_treatment/"
#seg_folder="/media/veronica/DATAPART2/Signatures/Signatures_these/Brain_SignaPark/2020_09_21_-_19_43_16/Reference_delineation/DelineationGroups_1_to_10/2020_09_24_-_13_36_52/Atypical_model/Type_Control-Patient/AtypicalGroups_1_to_10/2020_09_24_-_13_36_52/Report_post_treatment/"
#Patient_folder="vmunozra@access1-cp.inrialpes.fr:/services/scratch/mistis/veronica/Data_MNI/Data/nControls_hemi"
#Patient_folder="/media/veronica/DATAPART2/PPMI_Morpho_all/PD"
cd $main_folder

for i in $(ls); do 
	if [ -d $i ]; then
		echo item: $i
		itksnap \
				-g "$main_folder/$i/ssrAnat.nii" \
                                -s "$seg_folder/$i$clust_ext" \
				-l "/media/veronica/DATAPART2/Signatures/Signatures_these/clusters5aty.txt"
                                #-o "$Patient_folder/$i/FA.nii"
				#-s "$Patient_folder/$i/reg.nii" #\

	fi
done

#itksnap \
#		-g "$Control_folder/$subject/$Anat_name" \
#		-s "$Signatures_folder/Initial_roi_$roi/$ref_folder/$ref_time/Report/$subject$clust_ext" \
#		-l "$Patient_folder/brainRefcolors.txt"

#for i in $(ls); do 
#	if [ -d $i ]; then
#		echo item: $i
#		itksnap \
#				-g "$Patient_folder/$i/mri/mwp1Anat.nii" \
#				-o "$Patient_folder/$i/mri/mwp2Anat.nii"
#	fi
#done

#for i in $(ls); do 
#		echo item: $i
#		itksnap \
#				-g "$Patient_folder/n3102.nii" \
#				-o "$Patient_folder/$i"
#done

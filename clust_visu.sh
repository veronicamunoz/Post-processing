#!/bin/bash
#####./clust_visu.sh postaty BG 2018_10_03_-_14_18_42 AA-03

Control_folder="/home/veronica/Donnees/Controls/Control_T1/Last"
Patient_folder="/home/veronica/Donnees/Patients/Park_T1"
#Patient_folder="/home/veronica/Donnees/PPMI/DTI_PPMI/DTI_processed/Patients"

Anat_name="Anat/rAnat.nii"
#Anat_name="dtifit_MD.nii"

DTI_folder="/home/veronica/Donnees/DTIPark/Park"
CBF_folder="/home/veronica/Donnees/PerfusionPark"

atlas_name="def3PD25-subcortical-complete.nii" 
label_name="PD25_completelabels.txt"
#atlas_name="def3Neuromorphometrics_ScalableBrain_seg.nii"
#label_name="labels_Neuromorphometrics.txt"

Signatures_folder="/media/veronica/DATAPART2/Signatures_PPMI/Reference_model/Type_Control"
ref_folder="Dimensions_FA-MD/Model_for_EM_mmsd/ReferenceGroups_1_to_10"
ref_del="Reference_delineation/DelineationGroups_1_to_10"
del_folder="Delineated_data/Patient/Report"
aty_folder="Atypical_model/Type_Control-Patient/AtypicalGroups_1_to_10"
clust_ext="_clusters.nii"

### ---- Colliculus inferieur ----
#roi="CI"
#ref_time="2018_02_27_-_20_31_15"

#### ----------- Brain ------------
#roi="Brain"
#ref_time="2018_04_26_-_14_28_01"
#ref_time2="2018_05_15_-_12_01_38"

#### ----------- BG ------------
#roi="BG"
#ref_time="2018_05_08_-_12_51_06"
#ref_time2="2018_05_14_-_14_22_15"

roi="$2"
ref_time="$3"
subject="$4"
#ref_time2="2018_10_11_-_16_49_16"

case "$1" in 
"refmodel" )

	### --------------Reference Model--------------------
	#subject="AL-05"
	itksnap \
		-g "$Control_folder/$subject/$Anat_name" \
		-s "$Signatures_folder/Initial_roi_$roi/$ref_folder/$ref_time/Report/$subject$clust_ext" #\
#		-l "$Patient_folder/brainRefcolors.txt"
	;;
"refdel" )
	### --------------Reference Delineation--------------
	itksnap \
		-g "$Patient_folder/$subject/$Anat_name" \
		-s "$Signatures_folder/Initial_roi_$roi/$ref_folder/$ref_time/$ref_del/$ref_time/$del_folder/$subject$clust_ext" \
		-l "$Patient_folder/thresh.txt"
	;;
"atymodel" )
	### -------------Atypical Model----------------------
	itksnap \
		-g "$Patient_folder/$subject/$Anat_name" \
		-s "$Signatures_folder/Initial_roi_$roi/$ref_folder/$ref_time/$ref_del/$ref_time/$aty_folder/$ref_time/Report/$subject$clust_ext" \
		-l "$Patient_folder/clusterColorsBrain5.txt"
	;;
"postaty" )
	### ------------Atypical after post-treatment--------
	itksnap \
		-g "$Patient_folder/$subject/$Anat_name" \
		-s "$Signatures_folder/Initial_roi_$roi/$ref_folder/$ref_time/$ref_del/$ref_time/$aty_folder/$ref_time/Report_post_treatment/$subject$clust_ext" \
		-l "$Patient_folder/clust10.txt"
	;;
"postaty2" )
	itksnap \
		-g "$Patient_folder/$subject/$Anat_name" \
		-s "/media/veronica/DATAPART2/Signatures/Signatures_these/BG/2020_08_07_-_14_03_30/Reference_delineation/Atypical_model/Report_post_treatment/$subject$clust_ext" \
                -l "/media/veronica/DATAPART2/Signatures/Signatures_these/BG/clust.txt"
		#-s "/home/veronica/Pictures/2018_10_11_-_16_49_16/Report_post_treatment/$subject$clust_ext" \
		
	;;
esac


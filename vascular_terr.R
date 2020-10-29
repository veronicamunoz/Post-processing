library("pracma")
library("neurobase")
library("oro.nifti")
library("ggplot2")
library("ROCR")

atlasPath <- "/media/veronica/DATAPART2/COVID2/Raw_data/rw2ATTbasedFlowTerritories.nii"
#varPath <- "/media/veronica/DATAPART2/COVID2/Raw_data/rPA0-20200407_151339-3D_pCASL_6mm_i_20200629-133040105.nii"
varPath <- "/media/veronica/DATAPART2/COVID2/Derived_data/PA0_20200407_151339_CBF.nii"
error_c <- vector(mode = "list", length = 3)
names(error_c) <- c("ACA","MCA","PCA")

if (file.exists(varPath)){
  var <- readNIfTI(
    varPath
    , reorient = FALSE
    , read_data = TRUE
  )
  Var<- var@.Data
  Var[is.na(Var)]<-0
  
  atlas <- readNIfTI(
    atlasPath
    , reorient = FALSE
    , read_data = TRUE
  )
  Atlas<- atlas@.Data
  Atlas[is.na(Atlas)]<-0
  Atlas[Var==0]<-0
}


#
library(ggplot2)

A <- data.frame(dens=c(Var[ Atlas %in% c(1,2,3) ], Var[ Atlas %in% c(4,5,6) ], Var[ Atlas %in% c(7,8,9) ]),
                lines= c(rep("ACA",length(Var[ Atlas %in% c(1,2,3) ])),
                         rep("MCA",length(Var[ Atlas %in% c(4,5,6) ])),
                         rep("PCA",length(Var[ Atlas %in% c(7,8,9) ]))
                         )
                )

#Plot.
ggplot(A, aes(x = dens, fill = lines)) + 
  geom_histogram(alpha = 0.5, position = "identity", binwidth = 0.02) +
  ggtitle("CBF histogram") +
  xlab("CBF")
ggplot(A, aes(x = dens, fill = lines)) + 
  geom_density(alpha = 0.5)  +
  ggtitle("CBF density") +
  xlab("CBF")



thresh <- vector(mode = "list", length = 3)
names(thresh) <- c("ACA",'MCA',"PCA")

for ( r in  1:length(thresh)){
  A <- data.frame(dens = Var[ Atlas %in% c(r*3-2,r*3-1,r*3) ])
  p <-ggplot(A, aes(x=dens)) +
    geom_density(alpha = 0.5) +
    ggtitle(paste(" > 95% quantile of controls - |", names(thresh)[r], "|", sep = ""))
  plot(p)
}

par(mfrow=c(3,4))
for ( r in  1:length(thresh)){
  A <- data.frame(dens = c(error2_c[[r]],
                           error2_p[[r]]
  ),
  name = c(rep("Controls", length(error2_c[[r]])),
           rep("Patients", length(error2_p[[r]]))
  )
  )
  qqplot(x = A$dens[A$name=="Controls"],
         y = A$dens[A$name=="Patients"], 
         pch = 20, 
         xlab = "Controls", 
         ylab = "Patients",
         main = names(thresh)[r]
  )
  abline(0,1)
  print(summary(A[A$name=="Controls",]))
  print(summary(A[A$name=="Patients",]))
}

as.matrix(thresh)

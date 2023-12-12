## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rxode2)
setRxThreads(1L)
library(data.table)
setDTthreads(1L)


## ----model--------------------------------------------------------------------
library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)
mod

## ----prespecify---------------------------------------------------------------
mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE,
                 thetaNames=c("lcl", "lvc", "lq", "lvp", "prop.sd"),
                 etaNames=c("eta.cl", "eta.vc", "eta.q","eta.vp"),
                 cmtNames = c("central", "perip"))

mod

## ----prespecifySigma----------------------------------------------------------
mod <- nonmem2rx(system.file("Theopd.ctl", package="nonmem2rx"), save=FALSE)
mod

## ----renameMod----------------------------------------------------------------
mod <- mod %>% rxRename(add.var=eps1)
mod


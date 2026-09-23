## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rxode2)
setRxThreads(1L)
library(data.table)
setDTthreads(1L)

# the ADVAN5/7 matExp() examples below need matrix-exponential support in the
# installed rxode2; skip them gracefully on older versions
.hasMatExp <- exists("indLin", where=asNamespace("rxode2"), inherits=FALSE)


## ----model--------------------------------------------------------------------
library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are running
# an example, we will use one of the built-in examples in `nonmem2rx`
resFile <- system.file("mods/cpt/runODE032.res", package="nonmem2rx")
# You can use a control stream or the listing (.lst or .res) file

mod <- nonmem2rx(resFile, save=FALSE, determineError=FALSE)
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

## ----inputDataPath, eval=FALSE------------------------------------------------
# mod <- nonmem2rx("runs/run1/run1.ctl",
#                  inputData = "../../data.csv")

## ----inputDataFrame-----------------------------------------------------------
# read the data from wherever it really is
d <- read.csv(system.file("mods/cpt/Bolus_2CPT.csv", package="nonmem2rx"))

mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                 lst=".res", save=FALSE, inputData = d)
mod

## ----advan5matexp, eval=.hasMatExp--------------------------------------------
advan5 <- system.file("mods/advan5/advan5.ctl", package="nonmem2rx")

mod <- nonmem2rx(advan5, validate=FALSE, save=FALSE)
mod

## ----advan5ode, eval=.hasMatExp-----------------------------------------------
mod <- nonmem2rx(advan5, validate=FALSE, save=FALSE, matexp=FALSE)
mod


## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----model--------------------------------------------------------------------
library(nonmem2rx)
mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)
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


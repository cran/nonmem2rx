## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)

## ----tol----------------------------------------------------------------------
mod$iwresAtol
mod$iwresRtol
mod$ipredAtol
mod$ipredRtol
mod$predAtol
mod$predAtol

## ----compare------------------------------------------------------------------
head(mod$iwresCompare)

head(mod$ipredCompare)

head(mod$predCompare)

## ----nonmemData---------------------------------------------------------------
head(mod$nonmemData) # with nlme loaded you can also use getData(mod)

## ----plot---------------------------------------------------------------------
plot(mod) # for general plot
# you can also see individual comparisons
plot(mod, log="y", ncol=2, nrow=2,
     xlab="Time (hr)", ylab="Concentrations",
     page=1)

# If you want all pages you could use:
#
plot(mod, log="y", ncol=2, nrow=2,
     xlab="Time (hr)", ylab="Concentrations",
     page=TRUE)


## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(rxode2)
setRxThreads(1L)
library(data.table)
setDTthreads(1L)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)
library(rxode2)

library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)

## ----eventTable---------------------------------------------------------------
ev <- et(amt=120000, ii=12, until=24) %>%
  et(list(c(0, 2), # add observations in windows
          c(4, 6),
          c(8, 12),
          c(14, 18),
          c(20, 26),
          c(28, 32),
          c(32, 36),
          c(36, 44))) %>%
  et(id=1:10)

## ----solve--------------------------------------------------------------------
s <- rxSolve(mod, ev)

## ----plot---------------------------------------------------------------------
library(ggplot2)
plot(s, ipred) +
  ylab("Concentrations")


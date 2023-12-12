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
# its best practice to set the seed for the simulations
set.seed(42)
rxSetSeed(42)

# First we need the location of the nonmem control stream Since we are
# running an example, we will use one of the built-in examples in
# `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file
mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)

## ----eventTable---------------------------------------------------------------
ev <- et(amt=120000, ii=12, until=24) %>%
  et(c(1:6, seq(8, 24, by=2))) %>%
  et(id=1:100)

## ----rxSolve------------------------------------------------------------------
s <- rxSolve(mod, ev, nStud=100)

s

## ----confint------------------------------------------------------------------
sci <- confint(s, parm=c("CENTRAL", "PERI", "sim"))

sci

plot(sci)

plot(sci, log="y")


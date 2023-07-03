## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)
library(rxode2)


# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)

## ----modAuc-------------------------------------------------------------------
modAuc <- mod %>%
  model(d/dt(AUC) <- f, append=TRUE)

modAuc

## ----eventTable---------------------------------------------------------------
ev <- et(amt=120000, ii=12, until=24) %>%
  et(amt=0, ii=12, until=24, cmt="AUC", evid=5) %>% # replace AUC with zero at dosing
  et(c(0, 4, 8, 11.999, 12, 12.01, 14, 20, 23.999, 24, 24.001, 28, 32, 36)) %>%
  et(id=1:10)

## ----solve--------------------------------------------------------------------
s <- rxSolve(modAuc, ev)

## ----plot---------------------------------------------------------------------
library(ggplot2)
plot(s, AUC) +
  ylab("Running AUC")

## ----gatherAuc----------------------------------------------------------------
library(dplyr)
s %>% filter(time %in% c(11.999,  23.999)) %>%
  mutate(time=round(time)) %>%
  select(id, time, AUC)


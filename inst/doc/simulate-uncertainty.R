## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)
library(rxode2)
# its best practice to sed the seed for the simulations
set.seed(42)
rxSetSeed(42)

mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)

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


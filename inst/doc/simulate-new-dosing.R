## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)
library(rxode2)

mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)

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

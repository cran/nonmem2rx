## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nonmem2rx)
library(rxode2)

## ----wbcImport----------------------------------------------------------------
# Since this is an included example, we import the model from the
# `nonmem2rx` package.  This is done by the `system.file()` command:
wbcModel <- system.file("wbc/wbc.lst", package="nonmem2rx")

wbc <- nonmem2rx(wbcModel)

print(wbc)

# note the NONMEM vs rxode2 models validate well. You can see this in
# the validation code:
message(paste(wbc$meta$validation, collapse="\n"))

## ----simCovUncertainty--------------------------------------------------------
sim <- rxSolve(wbc, resample=TRUE, nStud=500)

## ----simCovUncertainty2-------------------------------------------------------
# first create the base event table with the nubmer of individuals
# matching the NONMEM dataset:
ev <- et(amt=410, ii=20*24, until=365*24) %>% # Add dosing 20 days apart for a year
  et(seq(0, 365*24, by=7*24)) %>% # Assume weekly observations
  et(id=seq_along(unique(wbc$nonmemData$ID))) %>% # Match the number of subjects modeled
  as.data.frame # convert to data.frame

# Now create the PK covariates
library(dplyr)
pkCov <- wbc$nonmemData %>%
  filter(!duplicated(ID)) %>% # only get one observation per id
  select(CLI, V1I, V2I) # select the covariates

pkCov$id <- seq_along(pkCov$CLI) # add the covariates per id

# Then merge the PK covariates to the original event table
ev <- merge(pkCov, ev)

# Last simulate with replacement with the new data frame

sim <- rxSolve(wbc, ev, resample=TRUE, nStud=100)

ci <- confint(sim, "y")

plot(ci)

## ----simUncertanty3-----------------------------------------------------------
# first create the base event table with the nubmer of individuals
# matching the NONMEM dataset:
ev <- et(amt=410, ii=20*24, until=365*24) %>% # Add dosing 20 days apart for a year
  et(seq(0, 365*24, by=7*24)) %>% # Assume weekly observations
  et(id=seq(1, max(wbc$nonmemData$ID)*5)) %>% # Match the number of subjects modeled
  as.data.frame # convert to data.frame

# Now create the PK covariates
library(dplyr)

pkCov <- wbc$nonmemData %>%
  filter(!duplicated(ID)) %>% # only get one observation per id
  select(CLI, V1I, V2I) # select the covariates

# expand the covariates by 5

pkCov <- do.call("rbind",
                 lapply(1:5, function(i) {
                   pkCov
                 }))


pkCov$id <- seq_along(pkCov$CLI) # add the covariates per id

# Then merge the PK covariates to the original event table
ev <- merge(pkCov, ev)

# Last simulate with replacement with the new data frame

sim <- rxSolve(wbc, ev, resample=TRUE, nStud=100)

ci <- confint(sim, "y")

plot(ci)


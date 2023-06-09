test_that("plot tests", {
  skip_on_cran()
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))

  expect_error(autoplot(mod), NA)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("first-plot", a)
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-plot", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-logxy", a)
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-plot-gg", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-gg-logxy", a)
  })

  mod <- rxode2::rxUiDecompress(mod)
  class(mod) <- c("nonmem2rx", "rxUi")

  assign("ipredCompare", NULL, envir=mod)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("first-pred-plot", a)
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-pred-plot", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-logxy", a)
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("second-pred-plot-gg", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-gg-logxy", a)
  })

  assign("predCompare", NULL, envir=mod)

  expect_warning(plot(mod))

})

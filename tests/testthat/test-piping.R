.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("piping works", {
    skip_on_cran()

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res",
                    keep=NULL)

    expect_true(inherits(f, "nonmem2rx"))
    expect_false(is.null(f$nonmemData))
    expect_true(!is.null(f$dfSub))

    f2 <- f %>% ini(eta1 ~ 0.1)
    expect_true(inherits(f2, "nonmem2rx"))
    expect_false(is.null(f2$nonmemData))
    expect_true(is.null(f2$dfSub))

    f2 <- f %>% model(cl <- exp(theta1))
    expect_true(inherits(f2, "nonmem2rx"))
    expect_false(is.null(f2$nonmemData))
    expect_true(is.null(f2$dfSub))

    f2 <- f %>% ini(eta1=fixed)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))

    f2 <- f %>% rxRename(eta.v=eta2)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))

    f2 <- f %>% dplyr::rename(eta.v=eta2)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))



  })
})

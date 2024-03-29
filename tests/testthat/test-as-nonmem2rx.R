test_that("as.nonmem2rx", {
  skip_on_cran()

  mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                   determineError=FALSE, lst=".res", save=FALSE)

  mod2 <-function() {
    ini({
      lcl <- 1.37034036528946
      lvc <- 4.19814911033061
      lq <- 1.38003493562413
      lvp <- 3.87657341967489
      RSV <- c(0, 0.196446108190896, 1)
      eta.cl ~ 0.101251418415006
      eta.v ~ 0.0993872449483344
      eta.q ~ 0.101302674763154
      eta.v2 ~ 0.0730497519364148
    })
    model({
      cmt(CENTRAL)
      cmt(PERI)
      cl <- exp(lcl + eta.cl)
      v <- exp(lvc + eta.v)
      q <- exp(lq + eta.q)
      v2 <- exp(lvp + eta.v2)
      v1 <- v
      scale1 <- v
      k21 <- q/v2
      k12 <- q/v
      d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
      d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
      f <- CENTRAL/scale1
      f ~ prop(RSV)
    })
  }

  new <- as.nonmem2rx(mod2, mod)
  expect_false(is.null(new$ipredAtol))
  expect_false(is.null(new$predAtol))


  mod2 <-function() {
    ini({
      lcl <- 1.37034036528946
      lvc <- 4.19814911033061
      lq <- 1.38003493562413
      lvp <- 3.87657341967489
      RSV <- c(0, 0.196446108190896, 1)
      eta.cl ~ 0.101251418415006
      eta.v ~ 0.0993872449483344
      eta.q ~ 0.101302674763154
      eta.v2 ~ 0.07
    })
    model({
      cmt(CENTRAL)
      cmt(PERI)
      cl <- exp(lcl + eta.cl)
      v <- exp(lvc + eta.v)
      q <- exp(lq + eta.q)
      v2 <- exp(lvp + eta.v2)
      v1 <- v
      scale1 <- v
      k21 <- q/v2
      k12 <- q/v
      d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
      d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
      f <- CENTRAL/scale1
      f ~ prop(RSV)
    })
  }

  expect_error(as.nonmem2rx(mod2, mod), "eta translation")

  mod2 <-function() {
    ini({
      lcl <- 1.37
      lvc <- 4.19814911033061
      lq <- 1.38003493562413
      lvp <- 3.87657341967489
      RSV <- c(0, 0.196446108190896, 1)
      eta.cl ~ 0.101251418415006
      eta.v ~ 0.0993872449483344
      eta.q ~ 0.101302674763154
      eta.v2 ~ 0.0730497519364148
    })
    model({
      cmt(CENTRAL)
      cmt(PERI)
      cl <- exp(lcl + eta.cl)
      v <- exp(lvc + eta.v)
      q <- exp(lq + eta.q)
      v2 <- exp(lvp + eta.v2)
      v1 <- v
      scale1 <- v
      k21 <- q/v2
      k12 <- q/v
      d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
      d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
      f <- CENTRAL/scale1
      f ~ prop(RSV)
    })
  }

  expect_warning(as.nonmem2rx(mod2, mod), "initial estimate")

})

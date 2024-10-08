test_that("test omega", {

  .o <- function(omega, eq="no", len=0, reset=TRUE, unintFixed=TRUE) {
    withr::with_options(list(lotri.plusNames=TRUE), {
      .Call(`_nonmem2rx_setRecord`, "$OMEGA")
      if (reset) {
        .clearNonmem2rx()
        .Call(`_nonmem2rx_omeganum_reset`)
      }
      lapply(omega, function(o) {
        .Call(`_nonmem2rx_trans_omega`, o, "eta", as.integer(unintFixed))
      })
      expect_equal(.nonmem2rx$ini, eq)
      expect_length(.nonmem2rx$etaLabel, len)
      expect_length(.nonmem2rx$etaComment, len)
      expect_length(.nonmem2rx$etaNonmemLabel, len)
    })
  }

  .o("1", "eta1 ~ 1", 1)
  .o("(1 fix)", "eta1 ~ fix(1)", 1)
  .o("(fix 1)", "eta1 ~ fix(1)", 1)

  .o(c("BLOCK(3) 6. .005 .3 .0002 .006 .4 fix",
       "BLOCK(3) 6. .005 .3 .0002 .006 .4",
       "BLOCK SAME",
       "BLOCK(2) 6. .005 .3",
       "BLOCK SAME",
       "BLOCK(2) SAME"),
     c("eta1 + eta2 + eta3 ~ fix(6., .005, .3, .0002, .006, .4)",
       "eta4 + eta5 + eta6 ~ c(6., .005, .3, .0002, .006, .4)",
       "eta7 + eta8 + eta9 ~ fix(6., .005, .3, .0002, .006, .4)",
       "eta10 + eta11 ~ c(6., .005, .3)",
       "eta12 + eta13 ~ fix(6., .005, .3)",
       "eta14 + eta15 ~ fix(6., .005, .3)"),
     15)

  expect_error(.o(c("BLOCK(3) 6. .005 .3 .0002 .006 .4 fix",
       "BLOCK(3) 6. .005 .3 .0002 .006 .4",
       "BLOCK SAME",
       "BLOCK(2) 6. .005 .3",
       "BLOCK SAME",
       "BLOCK(2) SAME",
       "BLOCK(3) SAME"),
     c("eta1 + eta2 + eta3 ~ fix(6., .005, .3, .0002, .006, .4)",
       "eta4 + eta5 + eta6 ~ c(6., .005, .3, .0002, .006, .4)",
       "eta7 + eta8 + eta9 ~ fix(6., .005, .3, .0002, .006, .4)",
       "eta10 + eta11 ~ c(6., .005, .3)",
       "eta12 + eta13 ~ fix(6., .005, .3)",
       "eta14 + eta15 ~ fix(6., .005, .3)",
       ""),
     15), "BLOCK")

  expect_error(.o("BLOCK SAME"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 (.4)"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 .4 .4"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 (fix .4)"))

  expect_warning(.o("DIAGONAL(1) 1", "eta1 ~ 1", 1))

  .o(" BLOCK(6)\n 0.1\n0.01 0.1\n(0.01)x2 0.1\n(0.01)x3 0.1\n(0.01)x4 0.1\n(0.01)x5 0.1",
     "eta1 + eta2 + eta3 + eta4 + eta5 + eta6 ~ c(0.1, 0.01, 0.1, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.01, 0.1)", 6)

  .o("(0.01)x3 0.1",c("eta1 ~ 0.01", "eta2 ~ 0.01", "eta3 ~ 0.01", "eta4 ~ 0.1"), 4)

  .o("(0.01 FIX)x3 0.1",c("eta1 ~ fix(0.01)", "eta2 ~ fix(0.01)", "eta3 ~ fix(0.01)", "eta4 ~ 0.1"), 4)

  .o("(FIX 0.01)x3 0.1",c("eta1 ~ fix(0.01)", "eta2 ~ fix(0.01)", "eta3 ~ fix(0.01)", "eta4 ~ 0.1"), 4)


  .o("BLOCK(2) 6. .005 .3",
     "eta1 + eta2 ~ c(6., .005, .3)", 2)

  .o(c("BLOCK(2) 6. .005 .3",
       "BLOCK SAME(2)"),
     c("eta1 + eta2 ~ c(6., .005, .3)",
       "eta3 + eta4 ~ fix(6., .005, .3)",
       "eta5 + eta6 ~ fix(6., .005, .3)"), 6)

  .o(c("BLOCK(2) 6. .005 .3",
       "BLOCK SAME(2)",
       "BLOCK(2) SAME(3)"),
     c("eta1 + eta2 ~ c(6., .005, .3)",
       "eta3 + eta4 ~ fix(6., .005, .3)",
       "eta5 + eta6 ~ fix(6., .005, .3)",
       "eta7 + eta8 ~ fix(6., .005, .3)",
       "eta9 + eta10 ~ fix(6., .005, .3)",
       "eta11 + eta12 ~ fix(6., .005, .3)"), 12)

  .o("BLOCK(3) FIXED VALUES(0.09,0.0)",
     c("eta1 ~ fix(0.09)",
       "eta2 ~ fix(0.09)",
       "eta3 ~ fix(0.09)"), 3)

  .o("BLOCK(3) FIXED VALUES(0.09,0.0001)",
     "eta1 + eta2 + eta3 ~ fix(0.09, 1e-04, 0.09, 1e-04, 1e-04, 0.09)",
     3)

  .o("BLOCK(3) VALUES(0.09,0.0) FIXED",
     c("eta1 ~ fix(0.09)",
       "eta2 ~ fix(0.09)",
       "eta3 ~ fix(0.09)"), 3)

  .o("BLOCK(3) VALUES(0.09,0.0001) FIXED",
     "eta1 + eta2 + eta3 ~ fix(0.09, 1e-04, 0.09, 1e-04, 1e-04, 0.09)",
     3)

  .o("BLOCK(6) VALUES(0.1,0.01)",
     "eta1 + eta2 + eta3 + eta4 + eta5 + eta6 ~ c(0.1, 0.01, 0.1, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.01, 0.1)", 6)

  .o(c("BLOCK(6) VALUES(0.1,0.01)",
       "0.02"),
     c("eta1 + eta2 + eta3 + eta4 + eta5 + eta6 ~ c(0.1, 0.01, 0.1, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.1, 0.01, 0.01, 0.01, 0.01, 0.01, 0.1)",
       "eta7 ~ 0.02"), 7)

  # can be anywhere (at least in this parser)
  .o("BLOCK(4)\n ECL=  0.3\n 0.01 EV1=0.35\nEQ=   0.01 0.01 0.54\nEV2=  0.01 0.01 0.01 0.67",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.67)", 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))

  # can be anywhere (at least in this parser)
  expect_warning(.o("BLOCK(4)\n ECL=  0.3\n EVD=0.01 EV1=0.35\nEQ=   0.01 0.01 0.54\nEV2=  0.01 0.01 0.01 0.67",
                    "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.67)", 4),
                 "'EVD' was changed to 'EV1'")

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))


  .o("BLOCK(4)\n ECL=  0.3\nEV1=  0.01 0.35\nEQ=   0.01 0.01 0.54\nEV2=  0.01 0.01 0.01 0.67",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.67)", 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))

  .o("BLOCK(4)\n ECL=  0.3\nEV1=  0.01 0.35\nEQ= (0.01)x2 0.54\nEV2=  (0.01)x3 0.67",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.67)", 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))

  .o("BLOCK(4)\n ECL=  0.3\n0.01 0.35\nEQ= (0.01)x2 0.54\nEV2=  (0.01)x3 0.67",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.67)", 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "", "EQ", "EV2"))

  .o("V1=(0.01)x3 0.1",c("eta1 ~ 0.01", "eta2 ~ 0.01", "eta3 ~ 0.01", "eta4 ~ 0.1"), 4)
  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("V1", "", "", ""))

  .o("BLOCK(3)  KA=6 .005 UNNECESSARILYLONGK=.0002 .3 .006 UNNECESSARILYLONGCL=4",
     "eta1 + eta2 + eta3 ~ c(6, .005, .0002, .3, .006, 4)", 3)
  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("KA", "UNNECESSARILYLONGK", "UNNECESSARILYLONGCL"))

  .o("ECL= 0.3\nEV1= 0.35\nEQ=  0.54\nEV2= 0.67",
     c("eta1 ~ 0.3", "eta2 ~ 0.35", "eta3 ~ 0.54", "eta4 ~ 0.67"), 4)
  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))


  .o("BLOCK(4)\n ECL=  0.3\nEV1=  0.01 0.35\nEQ= (0.01)x2 0.54\nEV2=  (0.01)x4",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.3, 0.01, 0.35, 0.01, 0.01, 0.54, 0.01, 0.01, 0.01, 0.01)", 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL", "EV1", "EQ", "EV2"))

  .o("BLOCK(4) NAMES(ECL2,EV12,EQ2,EV22) VALUES(0.03,0.01)",
     "eta1 + eta2 + eta3 + eta4 ~ c(0.03, 0.01, 0.03, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.03)", 4)

  .o("BLOCK(4) FIXED NAMES(ECL2,EV12,EQ2,EV22) VALUES(0.03,0.01)",
     "eta1 + eta2 + eta3 + eta4 ~ fix(0.03, 0.01, 0.03, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.03)", 4)

  .o("BLOCK(4) NAMES(ECL2,EV12,EQ2,EV22) FIXED VALUES(0.03,0.01)",
     "eta1 + eta2 + eta3 + eta4 ~ fix(0.03, 0.01, 0.03, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.03)", 4)

  .o("BLOCK(4) NAMES(ECL2,EV12,EQ2,EV22) VALUES(0.03,0.01) FIXED",
     "eta1 + eta2 + eta3 + eta4 ~ fix(0.03, 0.01, 0.03, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.03)", 4)

  .o("BLOCK(4) NAMES(ECL2,EV12,EQ2,EV22) VALUES(0.03,0) FIXED",
     c("eta1 ~ fix(0.03)",
       "eta2 ~ fix(0.03)",
       "eta3 ~ fix(0.03)",
       "eta4 ~ fix(0.03)"), 4)

  expect_equal(.nonmem2rx$etaNonmemLabel,
               c("ECL2", "EV12", "EQ2", "EV22"))

  .o("(1 UNINT)", "eta1 ~ fix(1)", 1)
  .o("(1 UNINT)", "eta1 ~ fix(1)", 1)

  .o("BLOCK(2) UNINT 0.1\n0.01 0.1",
     "eta1 + eta2 ~ fix(0.1, 0.01, 0.1)", 2)

  .o("(UNINT 1)", "eta1 ~ 1", 1, unintFixed=FALSE)
  .o("(1 UNINT)", "eta1 ~ 1", 1, unintFixed=FALSE)
  .o("(1 UNINT)", "eta1 ~ 1", 1, unintFixed=FALSE)

  .o("BLOCK(2) UNINT 0.1\n0.01 0.1",
     "eta1 + eta2 ~ c(0.1, 0.01, 0.1)", 2, unintFixed=FALSE)

  .o("(UNINT 1)", "eta1 ~ 1", 1, , unintFixed=FALSE)

  expect_warning(expect_warning(.o("(0, 1) (0, 2, 3)", c("eta1 ~ 1", "eta2 ~ 2"), 2), "ignored"), "ignored")

  expect_error(.o("garbage"))



})

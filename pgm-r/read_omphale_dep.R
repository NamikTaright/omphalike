# Lecture des données Omphale avec projection par département
library(readr)
library(openxlsx)
library(dplyr, warn.conflicts = F)

datinit <- readxl::read_excel("../../Projections/2013-2050/projections_scenario_central.xls",
                              sheet = "Population_DEP",
                              skip = 6)

liste_dep <- c("75", "92", "93", "94", "78", "95", "77", "91")
a <- t(datinit %>% filter(code_Departements %in% liste_dep) %>% select(-c(code_Departements, libelle_Departements)))
a <- ts(a, start = c(2013), end = c(2050), frequency = 1)
colnames(a) <- liste_dep
a <- as.data.frame(a)
a <- cbind.data.frame(an = seq(2013,2050,1), a)

slidefunc <- function(df = a, var, by){
  df <- DataCombine::slide(a, var, NewVar = paste0(var, "_", as.character(13+by)), slideBy = by)
  return(df)
}

by_x <- 17
a <- slidefunc(a, var = "75", by = by_x)
a <- slidefunc(a, var = "92", by = by_x)
a <- slidefunc(a, var = "93", by = by_x)
a <- slidefunc(a, var = "94", by = by_x)
a <- slidefunc(a, var = "78", by = by_x)
a <- slidefunc(a, var = "95", by = by_x)
a <- slidefunc(a, var = "77", by = by_x)
a <- slidefunc(a, var = "91", by = by_x)
# liste_dep %>% purrr::map_df(~ slidefunc(df = a))

readr::write_rds(a, "references/omphale_13_50.rds")


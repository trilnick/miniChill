## ----setup, include = FALSE----------------------------------------------
rm(list = ls())
library(miniChill)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----excel_compare-------------------------------------------------------
original <- read.csv(system.file("extdata", "dynamic_model_example_sheet.csv", package = "miniChill"), skip = 9, stringsAsFactors = FALSE)

colnames(original)[3] <- "TempC"
compare_df <- data.frame(excel_portions = original$Portions)
compare_df$func_portions <- NA

# see if chill portions are the same for the whole vector
for(i in 1:dim(compare_df)[1]){
  compare_df$func_portions[i] <- chill_func(original$TempC[1:i])
}

# table differences
compare_df$same = apply(compare_df, 1, function(x) x[1] == x[2])
table(compare_df$same)


## ----slowfast------------------------------------------------------------
Chill_Calc <- function(temp) {
  # transform temperatures to kelvin and make data frame
  data <- as.data.frame(temp+273)
  # initial calculations
  colnames(data) <- c("temp")
  data$ftmprt <- 1.6 * 277 * (data$temp - 277) / data$temp
  data$st <- exp(data$ftmprt)
  data$xi <- data$st/(1 + data$st)
  data$xs <- (139500 / 2567000000000000000)*exp((12888.8 - 4153.5) / data$temp)
  data$ak1 <- 2567000000000000000 * exp(-12888.8 / data$temp)
  
  #add two "empty" columns in the beginning
  data=rbind(c(288, 16.93, 22471935.51, 1, 0.81, 0.09),
             c(285, 12.44, 252887.94, 1, 1.11, 0.06 ),
             data)
  
  data$inter_S <- 0
  data$inter_E <- 0
  data$delt <- 0
  data$portions <- 0
  data$inter_E[1] <- data$xs[1]*(data$xs[1] - data$inter_S[1]) * exp(-data$ak1[1])
  for (i in c(2:length(temp))) {
    data$inter_S[i] <- ifelse(data$inter_E[i - 1] < 1,
                              data$inter_E[i - 1],
                              data$inter_E[i - 1] * (1-data$xi[i - 1]))
    data$inter_E[i] <- data$xs[i] - (data$xs[i] - data$inter_S[i]) * exp(-data$ak1[i])
    data$delt[i] <- ifelse(data$inter_E[i] < 1,
                           0,
                           data$inter_E[i] * data$xi[i])
    data$portions[i] <- data$portions[i - 1] + data$delt[i]
  }
  
  return(floor(data$portions[length(temp)]))
}

## ----compare2------------------------------------------------------------
# make a longer temperature vector (more realistic)
temp_vec <- rep(original$TempC, 10)

# R implementation
system.time(sapply(1:10, function(x, vec) Chill_Calc(vec), vec = temp_vec))
# miniChill implementation
system.time(sapply(1:10, function(x, vec) chill_func(vec), vec = temp_vec))



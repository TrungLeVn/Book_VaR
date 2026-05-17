install.packages(c("quantmod", "dplyr", "zoo", "lubridate"))
library(quantmod)
library(dplyr)
library(lubridate)
library(zoo)

# Lấy dữ liệu giá dầu WTI (daily)
getSymbols("DCOILWTICO", src = "FRED")

oil_price <- DCOILWTICO
colnames(oil_price) <- "price"

# Loại bỏ missing
oil_price <- na.omit(oil_price)
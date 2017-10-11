# Load packages
library(jsonlite)
library(zoo)
library(TTR)


# Store trade history in disk in CSV format
if(!file.exists("trades.csv")){
  trades <- data.frame(sym=character(),
                       amount=double(),
                       unitPrice=double(),
                       quoteCurrency=character(),
                       date=character(),
                       remark=character(),
                       total=double(),
                       stringsAsFactors=FALSE)
  write.csv(x = trades, file = "trades.csv", sep = ",", row.names = FALSE)
} else {
  trades <- read.csv(file = "trades.csv", header = TRUE, sep = ",")
}

addTrade <- function(sym, amount, unitPrice, quoteCurrency = "BTC", date = Sys.Date(), remark=NA) {
  newTrade <- data.frame(sym, amount, unitPrice, quoteCurrency, date, remark, total = amount * unitPrice)
  # Enter positive value for `amount` when recording buys,
  # negate amount for sales
  trades <- rbind(trades, newTrade)
  assign(x = "trades", value = trades, envir = globalenv())
  write.csv(x = trades, file = "trades.csv", sep = ",", row.names = FALSE)
}


## addTrade() examples; add a few in order for the later commands to work
addTrade("ETH", 10, 0.06)
addTrade("ETH", -5, 0.065)
addTrade("ETH", 5, 0.061)

addTrade("XMR", 10, 0.019)

addTrade("NEO", 25, 0.006)
addTrade("NEO", -5, 0.0064)

addTrade("BNB", 500, 0.00030)
addTrade("WTC", 100, 0.00150)
addTrade("QTUM", 50, 0.0025)
addTrade("LINK", 500, 0.000085)


portfolio <- aggregate(amount ~ sym, trades, function(x) sum(as.numeric(x)))

portfolioHist <- list() # For storing historical data
for(i in 1:length(portfolio$sym)) {
  # Fetch current prices and store them in `all_price` variable
  ith_price <- fromJSON(paste0("https://min-api.cryptocompare.com/data/price?fsym=",
                               as.character(portfolio$sym)[i], "&tsyms=BTC", collapse = ""))
  # quote price tsyms=BTC can be replaced with USD, etc.
  portfolio$price[i] <- ith_price[[1]]
  portfolio$total[i] <- portfolio$amount[i] * portfolio$price[i]
  ### Create time series zoo object for Technical Analysis using TTR package
  histohour <- fromJSON(paste0("https://min-api.cryptocompare.com/data/histohour?fsym=",
                               as.character(portfolio$sym)[i], "&tsym=BTC&limit=1440", collapse = ""))
  # Replace "histohour" in API URL with "histominute" and "histoday" for minute and daily data
  ohlc <- read.zoo(histohour$Data)[, c(4, 2, 3, 1, 5, 6)] # Open, High, Low, Close
  portfolioHist[[i]] <- ohlc
  names(portfolioHist)[i] <- as.character(portfolio$sym)[i]
}


head(portfolio)
head(portfolioHist)
# Get BTC price in USD
btc_usd <- fromJSON("https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD")[[1]]


# Usage of data
sum(portfolio$total) * btc_usd
# Technical analysis with TTR package

autoplot.zoo(RSI(price = portfolioHist$XMR$close, n = 14))
tail(MACD(x = portfolioHist$XMR$close))

autoplot.zoo(RSI(price = portfolioHist$ETH$close, n = 14))
tail(MACD(x = portfolioHist$ETH$close))

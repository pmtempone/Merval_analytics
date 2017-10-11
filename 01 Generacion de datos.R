# Time Series Plotting
library(ggplot2)
library(xts)
library(dygraphs)
library(quantmod)

#listado de acciones para seguir: ferrum,havanna,pampa energia,acindar, byma,andes energy

getQuote("GGAL;BMA", what=yahooQF(c("Bid","Ask","Last Trade (Price Only)")))



plot(GOOG)



getSymbols('BCBA:HAVA',src='google')
getSymbols('BCBA:FERR',src='google')
getSymbols('BCBA:PAMP',src='google')
getSymbols('BCBA:BYMA',src='google')


plot(`BCBA:HAVA`[,4],main="HAVANNA")

plot(`BCBA:FERR`[,4],main="FERRUM")
plot(`BCBA:PAMP`[,4],main="PAMPA")
plot(`BCBA:BYMA`[,4],main="BYMA")


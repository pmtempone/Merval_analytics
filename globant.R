# Time Series Plotting
library(ggplot2)
library(xts)
library(dygraphs)
library(quantmod)

options(scipen = 999)

#listado de acciones para seguir: ferrum,havanna,pampa energia,acindar, byma,andes energy

getQuote("GLOB", what=yahooQF(c("Bid","Ask","Last Trade (Price Only)")))

getSymbols('GLOB',src='yahoo')


plot(GLOB[,4],main='Globant')

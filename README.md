# splGoldenDeathX

_Welcome to the SPL Golden Crossing Dashboard!_

**Abstract** Binomial event.

**Hypothesis**: Discern whether the trend is truly your friend.

**Mission**: utilize Machine Learning & Fintech analytics to vette the ASX for compelling Small Cap Biotech trading opportunities.

**Methodology**: This backtest trading mechanism is based upon the Golden Cross and Death Cross technical indicator(s). These trends exist under the following conditions:

---

- For the Golden Cross, either of these two parameters must be true:

  - EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200 or

  - SMA.020 > SMA.050 & SMA.050 > SMA.100 & SMA.100 > SMA.200

- Once all of either of these two conditions are met, a trading position is established the following day wherein:  

  - 10,000 shares are purchased at the open price.

- The position is held until one of the conditions are false. Then the trade is closed the next day.

  - 10,000 shares are sold at the opening price.

---

---

- Conversely for a Death Cross to occur, either one of these conditions have to occur

  - EMA.020 <= EMA.050 & EMA.050 <= EMA.100 & EMA.100 <= EMA.200 or

  - SMA.020 <= SMA.050 & SMA.050 <= SMA.100 & SMA.100 <= SMA.200

- Once all of either of these two conditions are met, a trading position is established the following day.  

  - 10,000 shares are sold short at the opening price.

- The position is held until one of the conditions are false. Then the trade is closed the next day wherein:

  - 10,000 shares are purchased at the open price to close the position.

---

---

- In regard to the No Cross indicator, it transpires when neither the Golden Cross or Death Cross are active.

- In this case, a trade is established on the day either the Golden Cross or Death Cross have been closed thereby

  - 10,000 shares are purchased at the open price.

- If either a Golden Cross or Death Cross is initiated , a trade is established on that day whereby

  - 10,000 shares are sold at the opening price.

---

---

- In any of these strategies, the currency used is the US Dollar and Transcation Fees are assumed to be $0.

---

**Objective**: The purpose of this dashboard is twofold.

1. To provide a glimpse of Starpharma's performance circa 2002-01-02.
2. To examine the Golden Cross, Death Cross and No Cross Trading Strategies to discern their profitability.

**Design**: This site is developed using a reactive framework thereby allowing a dynamic interaction with any of the input variables. Therefore, whenever the date is updated the corresponding entries will be dynamically updated as well.

**Software**: The dashboard was developed in R V 3.6.3 using RStudio 1.2.5042 as the IDE

**Libraries**:

1. quantstrat 0.9.1739

```
This version of quantstrat includes the following packages, among others:
```

a. blotter 0.9.1741
b. quantmod 0.4-5
c. TTR 0.23-1

**Layout**: The dashboard is divided into two sections.

- 1.0 The first section provides a summary of Starpharma's performance and historical returns.
  - 1.1 The performance portion of the dashboard provides:
    - 1.1.1.0 Visual Boxes are dynamically displayed by date range:
      - 1.1.1.1 Number of calendar days,  
      - 1.1.1.2 Annualized return.
      - 1.1.1.3 Cumulative return.
      - 1.1.1.4 Number of trade days.
    - 1.1.2.1 Stock price table with a filter provided to help winnow the columns to a more granular level.
      - 1.1.2.1.a Date.
      - 1.1.2.1.b Open Price.
      - 1.1.2.1.c High Price.
      - 1.1.2.1.d Low Price.
      - 1.1.2.1.e Close Price.
      - 1.1.2.1.f Volume.
      - 1.1.2.1.g ema 20 day price.
      - 1.1.2.1.h ema 50 day price.
      - 1.1.2.1.i ema 100 day price.
      - 1.1.2.1.j ema 200 day price.
      - 1.1.2.1.k sma 20 day price.
      - 1.1.2.1.l sma 50 day price.
      - 1.1.2.1.m sma 100 day price.
      - 1.1.2.1.n sma 200 day price.
    - 1.1.3.1 Candlestick chart detailing the historical stock prices.
    - 1.1.3.2 Histogram of the closing price.
  - 1.2 The second section analyzes Startpharma's historical returns circa 2001.
    - 1.2.1.0 Within this partitiion, each of the date-sensitive charts can be further segmented into 1 month, 3
        month, 6 month, YTD, 1 year and cumulative time frames. A date range can be entered as well.
    - 1.2.1.1 Daily Returns.
    - 1.2.1.2 Weekly Returns.
    - 1.2.1.3 Monthly Returns.
    - 1.2.1.4 Quarterly Returns.
    - 1.2.1.5 Annual Returns.
    - 1.2.1.6 Growth of $1 invested
    - 1.2.1.7 Chaikan Money Flow..
- 2.0 The second part delves into the different trends starting with an overall trading history along with the
  results and continuing with a section highlighting each trend.
  - 2.1 The Trend Summary is subdivided into the following sections:
    - 2.1.1.0 Visual Boxes are bifurcated by moving average type, i.e. Exponential or Simple.
      - 2.1.1.1 Trend:
        - 2.1.1.1.a EMA current trend.
        - 2.1.1.1.b SMA current trend.
      - 2.1.1.2 ROI:
        - 2.1.1.2.a EMA ROI.
        - 2.1.1.2.b SMA ROI.
      - 2.1.1.3 Trade Days:
        - 2.1.1.3.a EMA Trade Days.
        - 2.1.1.3.b EMA Trade Days.  
    - 2.1.2.0 Tab bar comprised of the following modules:
      - 2.1.2.1 Trend Summary Table provides a trend synopsis which includes
        - 2.1.2.1.a Type of indicator: Exponential or Simple
        - 2.1.2.1.b Category Name: DeathX, GoldenX and NoX
        - 2.1.2.1.c SubCategory Name: Defines the sequence number of the category.
        - 2.1.2.1.d Start Date: date that the trend started
        - 2.1.2.1.e Start Open: Market Opening price when the trend is initially purchased.
        - 2.1.2.1.f End Date: date that the trend ended
        - 2.1.2.1.g End Open: Market Opening price to close the position the day after the trend is finished.
        - 2.1.2.1.h Return: The trend's return on investment.
        - 2.1.2.1.i Net.Trading.PL: The profit/loss dollar amount of the position.
        - 2.1.2.1.j Trade Days: The number of trading days of the trend.
        - 2.1.2.1.k Calendar Days: How many calendar days did the position last.
      - 2.1.2.2 Composite Trade Stats: This tables examines each trends profitablilty factor.
      - 2.1.2.3 EMA Trend Return Distribution: Boxplot of the returns for EMA trend.
      - 2.1.2.4 SMA Trend Return Distribution: Boxplot of the returns for SMA trend.
      - 2.1.2.5 Composite Returns: Boxplot of the composite returns by combining the EMA & SMA results.
      - 2.1.2.6 Returns by Moving Average Type: Boxplot of the returns broken down by each individual trend.
      - 2.1.2.7 Composite Trade Days: Boxplot of the number of trade days by combining the EMA & SMA results.
      - 2.1.2.8 Trade Days by Moving Average Type: Boxplot of the trade days broken down by each individual trend.
    - 2.1.3.0 The bottom third of the panel displays:  
      - 2.1.3.1 Composite Trend Return Distribution
      - 2.1.3.2 Composite Trend Returns Annualized  
      - 2.1.3.3 Composite Trade Days per Trend.
  - 2.2 The Golden Cross section is divided into these three parts:
    - 2.2.1.0 Visual Boxes are dynamically controlled by the date range and the moving average type selected:
      - 2.2.1.1 Trend and Moving Average Type
      - 2.2.1.2 Annual Return.
      - 2.2.1.3 Cumulative Return.
      - 2.2.1.4 Number of Days
        - 2.2.1.4.a Calendar Days.
        - 2.2.1.4.b Trade Days.
    - 2.2.2.0 In the second section there is a tab bar consisting of the following elements:
      - 2.2.2.1 Price & Transaction Chart: a three-panel chart of time series charts that contains prices and
        transactions in the top panel, the resulting position in the second, and a cumulative profit-loss line chart
        in the third.
      - 2.2.2.2 Golden Crossing Table: A filtered summery of each one of the Golden Cross entities listing the:
        - 2.2.2.2.a indicator; EMA or SMA.
        - 2.2.2.2.b Category Name, i.e., Deathx, GoldenX or No X.
        - 2.2.2.2.c Sub-Category; the occurrence number of the category.
        - 2.2.2.2.d Trend Start Date.
        - 2.2.2.2.e When a trend is triggered, the next day's open the position purchase price.
        - 2.2.2.2.f Trend End Date.
        - 2.2.2.2.g When a trend is completed, the next day's open price to close the position.
        - 2.2.2.2.h Trend's ROI.
        - 2.2.2.2.i Trend's Profit/Loss amount.
        - 2.2.2.2.j Number of trade days of the trend.
        - 2.2.2.2.k Number of trade days of the trend.
    - 2.2.3.0 In the bottom portion, there are two vizualizations:
      - 2.2.3.1 GoldenX Return: displays a Return on Investment histogram along with a boxplot of the outliers.
      - 2.2.3.2 GoldenX Trade Days: displays a number of trade days histogram along with a boxplot of the outliers.
  - 2.3 The Death Cross section is divided into these three parts:
    - 2.3.1.0 Visual Boxes are dynamically controlled by the date range and the moving average type selected:
      - 2.3.1.1 Trend and Moving Average Type
      - 2.3.1.2 Annual Return.
      - 2.3.1.3 Cumulative Return.
      - 2.3.1.4 Number of Days
        - 2.3.1.4.a Calendar days.
        - 2.3.1.4.b Trade days.
    - 2.3.2.0 In the second section there is a tab bar consisting of the following elements:
      - 2.3.2.1 Price & Transaction Chart: a three-panel chart of time series charts that contains prices and
        transactions in the top panel, the resulting position in the second, and a cumulative profit-loss line chart
        in the third.
      - 2.3.2.2 Death Crossing Table: A filtered summery of each one of the Death Cross entities listing the:
        - 2.3.2.2.a indicator; EMA or SMA.
        - 2.3.2.2.b Category Name, i.e., Deathx, DeathX or No X.
        - 2.3.2.2.c Sub-Category; the occurrence number of the category.
        - 2.3.2.2.d Trend Start Date.
        - 2.3.2.2.e When a trend is triggered, the next day's open the position purchase price.
        - 2.3.2.2.f Trend End Date.
        - 2.3.2.2.g When a trend is completed, the next day's open price to close the position.
        - 2.3.2.2.h Trend's ROI.
        - 2.3.2.2.i Trend's Profit/Loss amount.
        - 2.3.2.2.j Number of trade days of the trend.
        - 2.3.2.2.k Number of trade days of the trend.
    - 2.3.3.0 In the bottom portion, there are two vizualizations:
      - 2.3.3.1 DeathX Return: displays a Return on Investment histogram along with a boxplot of the outliers.
      - 2.3.3.2 DeathX Trade Days: displays a number of trade days histogram along with a boxplot of the outliers.
  - 2.4 The No Cross section is divided into these three parts:
    - 2.4.1.0 Visual Boxes are dynamically controlled by the date range and the moving average type selected:
      - 2.4.1.1 Trend and Moving Average Type.
      - 2.4.1.2 Annual Return.
      - 2.4.1.3 Cumulative Return.
      - 2.4.1.4 Number of Days.
        - 2.4.1.1.a Calendar days.
        - 2.4.1.1.b Trade days.
    - 2.4.2.0 In the second section there is a tab bar consisting of the following elements:
      - 2.4.2.1 Price & Transaction Chart: a three-panel chart of time series charts that contains prices and
        transactions in the top panel, the resulting position in the second, and a cumulative profit-loss line chart
        in the third.
      - 2.4.2.2 No Crossing Table: A filtered summery of each one of the No Cross entities listing the:
        - 2.4.2.2.a indicator; EMA or SMA.
        - 2.4.2.2.b Category Name, i.e., Nox, NoX or No X.
        - 2.4.2.2.c Sub-Category; the occurrence number of the category.
        - 2.4.2.2.d Trend Start Date.
        - 2.4.2.2.e When a trend is triggered, the next day's open the position purchase price.
        - 2.4.2.2.f Trend End Date.
        - 2.4.2.2.g When a trend is completed, the next day's open price to close the position.
        - 2.4.2.2.h Trend's ROI.
        - 2.4.2.2.i Trend's Profit/Loss amount.
        - 2.4.2.2.j Number of trade days of the trend.
        - 2.4.2.2.k Number of trade days of the trend.
    - 2.4.3.0 In the bottom portion, there are two vizualizations:
      - 2.4.3.1 NoX Return: displays a Return on Investment histogram along with a boxplot of the outliers.
      - 2.4.3.2 NoX Trade Days: displays a number of trade days histogram along with a boxplot of the outliers.  
  
## Conclusion: My Opinion only and does not constitute investment advice

The two major uptrends in 2011 and 2017 commenced at the beginning of a fiscal year .
DeathX: Final capitulation portends far worse things to come but not in SPL's case.

## Caveat

As a side note, to formulate the Crossing Trading Systems, the annualized return and ROI formulas are based upon the 20, 50, 100- and 200-day moving averages. Hence any dates selected with a start date less than 200 trading days prior to today, i.e., in the range from  `` `r head(tail(index(xtsEMA),200),1)` `` to `` `r Sys.Date()` `` will generate an error. I am currently working on a solution.

If you have any questions, or would like to provide feedback please: [email me](mailto:utexas80@gmail.com)

Thank you for your time and consideration. I hope that you enjoy the site.

## RISKS ASSOCIATED WITH TRADING THE STOCK MARKET

All investments involve risk, and the past performance of a security, industry, sector, market, financial product, trading strategy, or individual’s trading does not guarantee future results or returns. Investors are fully responsible for any investment decisions they make. Such decisions should be based solely on an evaluation of their financial circumstances, investment objectives, risk tolerance, and liquidity needs.

Any opinions, news, research, analyses, prices, or other information offered is provided as general market commentary, and does not constitute investment advice. I will not accept liability for any loss or damage, including without limitation any loss of profit, which may arise directly or indirectly from use of or reliance on such information.

---

- For more details about me, see [Glen C. Falk's website](http://glencfalk.rbind.io) or my [LinkedIn Profile](http://www.linkedin.com/in/glenfalk) or [Github Repository](https://github.com/UTexas80/splGoldenDeathX)

---

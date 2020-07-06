# splGoldenDeathX

Welcome to the SPL Golden Crossing Dashboard!

Hypothesis: Discern whether the trend is truly your friend.

Mission: utilize Machine Learning & Fintech analytics to vette the ASX for compelling Small Cap Biotech trading opportunities.

Objective: The purpose of this dashboard is twofold.

1. To provide a glimpse of Starpharma's performance circa 2002-01-02.
2. To examine the Golden Cross, Death Cross and No Cross Trading Strategies to discern their profitability.

Design: This site is developed using a reactive framework thereby allowing a dynamic interaction with any of the input variables. Therefore, whenever the date is updated the corresponding entries will be dynamically updated as
well.

Layout: The dashboard is divided into two sections.

- The first section provides a summary of Starpharma's performance and historical returns.
  - The performance portion of the dashboard provides:
    - The number of Calendar days, annualized return, ROI and trade days are dynamically displayed by date.
      - A table of OHLC prices along with the Simple and Exponential 20, 50, 100 and 200 moving averages.
        - A filter is provided for each one of these components to help winnow down to a more granular level.
      - A candlestick chart detailing the historical stock prices.
      - A histogram of the closing price.
    - The second section analyzes Startpharma's historical returns circa 2001.
      -Within this partitiion, Daily, Weekly, Monthly, Quarterly, and Annual charts are displayed.
      - Each of these can be further segmented into 1 month, 3 month, 6 month, Year-to-Date, 1 year and Cumulative
          time frames.
      - In addition, a growth of $1 invested and Chaikan Money Flow chart are included.
  - The second part delves into the different trends starting with an overall trading history and results and
    continuing with a section highlighting each trend.
    - The Trend Summary is subdivided into the following sections:
      - Visual Boxes are bifurcated by moving average type, i.e. Exponential or Simple.
        - The current trend, ROI and number of trade days are headligned.
      - A tab bar is included with these features:
        - Trend Summary Table provides a trend synopsis which includes
          - type of indicator: Exponential or Simple
          - Category Name: DeathX, GoldenX and NoX
          - SubCategory Name: Defines the sequence number of the category.
          - Start Date: date that the trend started
          - Start Open: Market Opening price when the trend is initially purchased.
          - End Date: date that the trend ended
          - End Open: Market Opening price to close the position the day after the trend is finished.
          - Return: The trend's return on investment.
          - Net.Trading.PL: The profit/loss dollar amount of the position.
          - Trade Days: The number of trading days of the trend.
          - Calendar Days: How many calendar days did the position last.
        - Composite Trade Stats: This tables examine each trends profitablilty factors.
        - EMA Trend Return Distribution
        - SMA Trend Return Distribution
        - Composite Returns
        - Returns by Moving Average Type
        - Composite Trade Days and
        - Trade Days by Moving Average Type
      - In the bottom section a Composite Trend Return Distribution, Trend Returns Annualized and a distribution by
        Trades Days per Trend are provided..
    - The Golden Cross section is preceded with information relating to

## Conclusion

The two major uptrends commenced at the beginning of a fiscal year [2011, 2017]
Caveat: As a side note, to formulate the Crossing Trading Systems, the annualized return and ROI formulas are based upon the 20, 50, 100- and 200-day moving averages. Hence any dates selected with a start date less than 200 trading days prior to today, i.e., in the range from  `` `r head(tail(index(xtsEMA),200),1)` `` to `` `r Sys.Date()` `` will generate an error. I am currently working on a solution.

If you have any questions, or would like to provide feedback please: [email me](mailto:utexas80@gmail.com)

Thank you for your time and consideration. I hope that you enjoy the site.

RISKS ASSOCIATED WITH TRADING THE STOCK MARKET

All investments involve risk, and the past performance of a security, industry, sector, market, financial product, trading strategy, or individual’s trading does not guarantee future results or returns. Investors are fully responsible for any investment decisions they make. Such decisions should be based solely on an evaluation of their financial circumstances, investment objectives, risk tolerance, and liquidity needs.

Any opinions, news, research, analyses, prices, or other information offered is provided as general market commentary, and does not constitute investment advice. I will not accept liability for any loss or damage, including without limitation any loss of profit, which may arise directly or indirectly from use of or reliance on such information.

For more details about me, see <http://glencfalk.rbind.io>

# splGoldenDeathX

Welcome to the SPL Golden Crossing Dashboard!

Mission: utilize Machine Learning & Fintech analytics to vette the ASX for compelling Small Cap Biotech risk adverse trading opportunities.

Objective: The purpose of this dashboard is twofold.

1. To provide a glimpse of Starpharma's performance circa 2002-01-02.
2. To examine the Golden Cross, Death Cross and No Cross Trading Strategies to discern their viability.

This site is developed using a reactive framework thereby allowing a dynamic interaction with any of the input variables. Therefore, whenever the date is updated the corresponding entries will be dynamically updated as well.

As a side note, to formulate the Crossing Trading Systems, the annualized return and ROI formulas are based upon the 20, 50, 100- and 200-day moving averages. Hence any dates selected with a start date less than 200 trading days prior to today, i.e., in the range from  `` `r head(tail(index(xtsEMA),200),1)` `` to `` `r Sys.Date()` `` will generate an error. I am currently working on a solution.

If you have any questions, or would like to provide feedback please: [email me](mailto:utexas80@gmail.com)

Thank you for your time and consideration. I hope that you enjoy the site.

RISKS ASSOCIATED WITH TRADING THE STOCK MARKET

All investments involve risk, and the past performance of a security, industry, sector, market, financial product, trading strategy, or individual’s trading does not guarantee future results or returns. Investors are fully responsible for any investment decisions they make. Such decisions should be based solely on an evaluation of their financial circumstances, investment objectives, risk tolerance, and liquidity needs.

Any opinions, news, research, analyses, prices, or other information offered is provided as general market commentary, and does not constitute investment advice. I will not accept liability for any loss or damage, including without limitation any loss of profit, which may arise directly or indirectly from use of or reliance on such information.

For more details about me, see http://glencfalk.rbind.io

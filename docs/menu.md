Here you can store any documentation that you've written about your analysis.
When pushing the project to GitHub you can use this directory as the root for a
GitHub Pages website for the project. For more information see
https://github.com/blog/2289-publishing-with-github-pages-now-as-easy-as-1-2-3

| FlexDashboard | Level 01 | Level 02           |  Level 03 | Level 04           | Type   | Description           | Sub Description    |
|---------------|----------|--------------------|-----------|--------------------|------- |-----------------------|--------------------|
|               | 1.0      | Performance        |           |                    |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  1.0.0    | Sidebar            |        |                       |                    |
|               |          |                    |           | 1.0.0.1            | input  | Date Range            | params$dateStart   |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|------------------- |
|               |          |                    |  1.1.0    | Summary            |        |                       |                    |
|               |          |                    |           | 1.1.1.0            | vbox   | Value Box             |                    |
|               |          |                    |           | 1.1.1.1            | vbox   | Calendar Days         | price()            |
|               |          |                    |           | 1.1.1.2            | vbox   | Annualized Return     | price() calculated |
|               |          |                    |           | 1.1.1.3            | vbox   | Cumulative Return     | price() calculated |
|               |          |                    |           | 1.1.1.4            | vbox   | Trade Days            | price() ndays      |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 1.1.2.1            | table  | Stock Price Table     | price()            |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 1.1.3.1            |  viz   | Stock Price Chart     | price()            |
|               |          |                    |           | 1.1.3.2            |  viz   | Histogram             | price()            |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  1.2.0    | Returns            |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 1.2.1.1            |  viz   | Daily Returns         | price()            |
|               |          |                    |           | 1.2.1.2            |  viz   | Weekly Returns        | price()            |
|               |          |                    |           | 1.2.1.3            |  viz   | Monthly Returns       | price()            |
|               |          |                    |           | 1.2.1.4            |  viz   | Quarterly Returns     | price()            |
|               |          |                    |           | 1.2.1.5            |  viz   | Annual Returns        | price()            |
|               |          |                    |           | 1.2.1.6            |  viz   | Future Returns        | price()            |
|               |          |                    |           | 1.2.1.7            |  viz   | Chaikan Money Flow    | price()            |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               | 2.0      | Trends             |           |                    |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  2.1.0    | Summary            |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.1.1.0            | vbox   | Value Box             |                    |
|               |          |                    |           | 2.1.1.1.a          | vbox   | Current Trend: EMA    | trend - filter ema |
|               |          |                    |           | 2.1.1.1.b          | vbox   | Current Trend: SMA    | trend - filter sma |
|               |          |                    |           | 2.1.1.2.a          | vbox   | ROI: EMA              | trend - filter ema |
|               |          |                    |           | 2.1.1.2.b          | vbox   | ROI: SMA              | trend - filter sma |
|               |          |                    |           | 2.1.1.3.a          | vbox   | Trade Days: EMA       | trend - filter ema |
|               |          |                    |           | 2.1.1.3.b          | vbox   | Trade Days: SMA       | trend - filter sma |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.1.2.0            | tBar   | Tab Bar               |                    |
|               |          |                    |           | 2.1.2.1            | DT     | Trend Summary Table   | trend              |
|               |          |                    |           | 2.1.2.2            | DT     | Composite Trade Stats | dt_trade_stats     |
|               |          |                    |           | 2.1.2.3            | boxplot| Trend Return Dist: EMA| trendReturns       |
|               |          |                    |           | 2.1.2.4            | boxplot| Trend Return Dist: SMA| trendReturns       |
|               |          |                    |           | 2.1.2.5            | boxplot| Composite Returns     | trend              |
|               |          |                    |           | 2.1.2.6            | boxplot| Returns by MA Type    | trend variation    |
|               |          |                    |           | 2.1.2.7            | boxplot| Composite Trade Days  | trend variation    |
|               |          |                    |           | 2.1.2.8            | boxplot| Trade Days by MA Type | trend variation    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.1.3.1            |ggploty |Composite Tred Ret Dist| trend              |
|               |          |                    |           | 2.1.3.2            |plot_ly |Trend Ret Annualized   |trendRetsAnnualized |
|               |          |                    |           | 2.1.3.3            |plot_ly |Trend Trade Days Dist  | trendSummaryGroup  |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  2.2.0    | Golden Cross       |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.2.0.1            | Sidebar| input - dateRange2.2  | params$dateStart   |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.2.1.0            | vbox   | Value Box             |                    |
|               |          |                    |           | 2.2.1.1            | vbox   | Trend Name            | trendReturnsDaily  |
|               |          |                    |           | 2.2.1.2            | vbox   | Annualized Return     | trendReturnsDaily  |
|               |          |                    |           | 2.2.1.3            | vbox   | Cumulative Return     | trendReturnsDaily  |
|               |          |                    |           | 2.2.1.4.a          | vbox   | Calendar Days         | input$dateRange2.2 |
|               |          |                    |           | 2.2.1.4.b          | vbox   | Trade Days            | trendReturnsDaily  |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.2.2.1            | .Posn  | Price/Transaction     |blotter:getPortfolio|
|               |          |                    |           | 2.2.2.2            | DT     | Golden Crossing table | trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.2.3.1            |hist/bar| ROI with Outliers     | trend              |
|               |          |                    |           | 2.2.3.2            |hist/bar|Trade Day with Outliers| trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  2.3.0    | Death Cross        |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.3.0.1            | Sidebar| input - dateRange2.2  | params$dateStart   |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.3.1.0            | vbox   | Value Box             |                    |
|               |          |                    |           | 2.3.1.1            | vbox   | Trend Name            | trendReturnsDaily  |
|               |          |                    |           | 2.3.1.2            | vbox   | Annualized Return     | trendReturnsDaily  |
|               |          |                    |           | 2.3.1.3            | vbox   | Cumulative Return     | trendReturnsDaily  |
|               |          |                    |           | 2.3.1.4.a          | vbox   | Calendar Days         | input$dateRange2.3 |
|               |          |                    |           | 2.3.1.4.b          | vbox   | Trade Days            | trendReturnsDaily  |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.3.2.1            | .Posn  | Price/Transaction     |blotter:getPortfolio|
|               |          |                    |           | 2.3.2.2            | DT     | Death Crossing table  | trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.3.3.1            |hist/bar| ROI with Outliers     | trend              |
|               |          |                    |           | 2.3.3.2            |hist/bar|Trade Day with Outliers| trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |  2.4.0    | No Cross           |        |                       |                    |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.4.0.1            | Sidebar| input - dateRange2.2  | params$dateStart   |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.4.1.0            | vbox   | Value Box             |                    |
|               |          |                    |           | 2.4.1.1            | vbox   | Trend Name            | trendReturnsDaily  |
|               |          |                    |           | 2.4.1.2            | vbox   | Annualized Return     | trendReturnsDaily  |
|               |          |                    |           | 2.4.1.3            | vbox   | Cumulative Return     | trendReturnsDaily  |
|               |          |                    |           | 2.4.1.4.a          | vbox   | Calendar Days         | input$dateRange2.4 |
|               |          |                    |           | 2.4.1.4.b          | vbox   | Trade Days            | trendReturnsDaily  |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.4.2.1            | .Posn  | Price/Transaction     |blotter:getPortfolio|
|               |          |                    |           | 2.4.2.2            | DT     | No Crossing table     | trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
|               |          |                    |           | 2.4.3.1            |hist/bar| ROI with Outliers     | trend              |
|               |          |                    |           | 2.4.3.2            |hist/bar|Trade Day with Outliers| trend              |
|---------------|----------|--------------------|-----------|--------------------|--------|-----------------------|--------------------|
| F U T U R E   | 3.0      | Technical Analysis |           |                    |        |                       |                    |
|               |          |                    |  3.1.0    | Technical Analysis |        |                       |                    |
|               |          |                    |           | 3.1.0.1            | Sidebar| input                 | Date Range         |
|               |          |                    |           | 3.1.1.1            |  vbox  | Gauge                 | test               |
|               |          |                    |           | 3.1.1.2            |  vbox  | Gauge                 | test               |
|               |          |                    |           | 3.1.1.3            |  vbox  | Gauge                 | Cumulative Return  |
|               |          |                    |           | 3.1.2.1            | table  | Stock Price           |                    |
|               |          |                    |           | 3.1.3.a            |  viz   | Time-Series           |                    |
|               |          |                    |           | 3.1.3.b            |  viz   | Time-Series           |                    |
|               |          |                    |           | 3.1.3.c            |  viz   | Time-Series           |                    |
|               |          |                    |           |                    |        |                       |                    |
|               |          |                    |           |                    |        |                       |                    |
|               | 4.0      | Forecast           |           |                    |        |                       |                    |
|               |          |                    |  4.1.0    | Forecast           |        |                       |                    |
|               |          |                    |           | 4.1.1.1            |        |                       |                    |
|               |          |                    |           | 4.1.2.1            |        |                       |                    |
|               |          |                    |           |                    |        |                       |                    |
|               | 5.0      | BackTesting        |           |                    |        |                       |                    |
|               |          |                    |  5.1.0    | BackTesting01      |        |                       |                    |
|               |          |                    |           | 5.1.1.1            | table  | ma                    |                    |
|               |          |                    |  5.2.0    | BackTesting02      |        |                       |                    |
|               |          |                    |           | 5.2.1.1            |        |                       |                    |
|               |          |                    |           |                    |        |                       |                    |
|               | 6.0      | WordCloud          |           |                    |        |                       |                    |
|               |          |                    |  6.1.0    | WordCloud01        |        |                       |                    |
|               |          |                    |           | 6.1.1.1            | table  | returnsByCategory     |                    |
|               |          |                    |  6.2.0    | WordCloud02        |        |                       |                    |
|               |          |                    |           | 6.2.1.a            | table  | dtEMA                 |                    |
|               |          |                    |           | 6.2.1.b            | table  | trend                 |                    |

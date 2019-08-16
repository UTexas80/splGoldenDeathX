#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30), # slider indput
            selectInput("dataset", 
                        label = "Dataset", 
                        choices = ls("package:datasets")
                        ) # selectInput
        ), # sidebarPanel

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           verbatimTextOutput("summary"),
           tableOutput("table")
        ) # mainPanel
    ) # sidebarLayout
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    dataset <- reactive({
        get(input$dataset, "package:datasets", inherits = FALSE)
    }) # dataset
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    }) # output$distPlot
    
    output$summary <- renderPrint({
        summary(dataset())
    }) # output$summary
    
    output$table <- renderTable({
        dataset()
    }) # output$table
    
    
    
} # server

# Run the application 
shinyApp(ui = ui, server = server)

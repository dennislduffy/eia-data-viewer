#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("function-files/elec-source.R", local = TRUE)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        #removed for qc testing. 
        # sidebarPanel(
        #   selectInput("year1", "Select Baseline Year", choice = unique(elec_gen()$year), 
        #               selected = "2001"), 
        #   selectInput("year2", "Select Comparison Year", choice = unique(elec_gen()$year), 
        #               selected = "2020")
        # ),
        mainPanel(
            plotOutput("elec_monthly"),
            #downloadButton(outputId = "plot_download", label = "Download Graph")#,
            DT::dataTableOutput("elec_monthly_table")
        )
    )
)

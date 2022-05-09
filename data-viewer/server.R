#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("function-files/elec-source.R", local = TRUE) #creates data and plot for elec gen by source
source("function-files/download-plot.R", local = TRUE) #function for download handler to work
source("function-files/elec-monthly.R", local = TRUE) #creates data and plot for elec gen by source


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
#Render Electricity Generation Plot
  
  p1 <- reactive({
    monthly_gen()
  })
  
  output$elec_monthly <- renderPlot(p1())
  
  output$elec_monthly_table <- DT::renderDataTable(elec_monthly(), 
                                                   server = FALSE,
                                                   extensions = c("Buttons"),
                                                   options = list(
                                                     dom = 'Bfrtip',
                                                     buttons = 
                                                       list(
                                                         list(
                                                           extend = 'csv',
                                                           buttons = c('csv'),
                                                           exportOptions = list(
                                                             modifiers = list(page = "all")
                                                           )
                                                         ))))
  
  #output$plot_download <- download_plot(p1)
#   
#     p1 <- reactive({
#       elec_gen_bar_plot(input$year1, input$year2)
#     })
#     
#     output$elec_gen_source <- renderPlot(p1())
#     
#     output$plot_download <- download_plot(p1)
#     
# # Render Electricity Generation Data --------------------------------------
# 
#     output$elec_gen_table <- DT::renderDataTable(elec_gen(),
#                                                  extensions = "Buttons",
#                                                  options = list(
#                                                      paging = TRUE,
#                                                      searching = TRUE,
#                                                      fixedColumns = TRUE,
#                                                      autoWidth = TRUE,
#                                                      ordering = TRUE,
#                                                      dom = 'Bfrtip',
#                                                      buttons = c('csv', 'excel'),
#                                                      pageLength = 10
#                                                      ),
#                                                  class = "display"
#                                                  )
# #     
})

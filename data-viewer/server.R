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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
#Render Electricity Generation Plot
  
    output$elec_gen_source <- renderPlot({
      elec_gen_bar_plot(input$year1, input$year2)
      })
    
    elec_gen_bar_plot_download <- reactive({
      elec_gen_bar_plot(input$year1, input$year2)
    })
    
    output$plot_download <- download_plot(elec_gen_bar_plot_download)
    
# Render Electricity Generation Data --------------------------------------

    output$elec_gen_table <- DT::renderDataTable(elec_gen(), 
                                                 extensions = "Buttons",  
                                                 options = list(
                                                     paging = TRUE,
                                                     searching = TRUE,
                                                     fixedColumns = TRUE,
                                                     autoWidth = TRUE,
                                                     ordering = TRUE,
                                                     dom = 'Bfrtip',
                                                     buttons = c('csv', 'excel'), 
                                                     pageLength = 10
                                                     ),
                                                 class = "display"
                                                 )
    
    # output$elec_gen_bar_download <- downloadHandler(
    #   
    #   filename = function(){
    #     
    #     "plot.png"
    #     
    #   }, 
    #   
    #   content = function(file){
    #     
    #     ggsave(file, plot = output$testtable, device = "png", height = 8, width = 10)
    #     
    #   }
    #   
    # )
    
    
})

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("function-files/elec-source.R", local = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    elec_gen_table <- elec_gen()
    
    output$elec_gen_table <- DT::renderDataTable(elec_gen_table, 
                                                 extensions = "Buttons",  
                                                 options = list(
                                                 
                                                     paging = TRUE,
                                                     searching = TRUE,
                                                     fixedColumns = TRUE,
                                                     autoWidth = TRUE,
                                                     ordering = TRUE,
                                                     dom = 'Bfrtip',
                                                     buttons = c('copy', 'csv', 'excel')
                                                     
                                                     ),
                                                 class = "display"
                                                 )
                                                

})

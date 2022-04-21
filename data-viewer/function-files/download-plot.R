#define function to download plots on server side of data-viewer app  

download_plot <- function(plotname){
  
  downloadHandler(
    
    filename = function(){
      
      "plot.png"
      
    }, 
    
    content = function(file){
      
      ggsave(file, plot = plotname(), device = "png", height = 8, width = 10)
      
    }
    
  )

}

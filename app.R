#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# load data for the app
load("results/appdata.RData")
coord_sf <- readRDS("data/coord_sf.rds")
functions <- readRDS("results/functions.rds")

mapplot <- functions$mapplot
seedplot<- functions$seedplot
references <- functions$references
taxanomic <- functions$taxanomic
habitat <- functions$habitat
metanalize <- functions$metanalize

#Create the species list 
spp <- dat1 %>% select(accepted_binomial) %>% arrange(accepted_binomial) %>% pull(accepted_binomial) %>% unique %>% as.character

#Center title and logo
tags$head(
  tags$style(
    HTML("
   .center-image {
     display: flex;
     justify-content: center;
     align-items: center;
   }
   .right-title {
     text-align: right;
     margin-top: 2000px;
   }
   .app-container {
    margin-left: 2000px;
  }
 ")
  )
)

#Start the app  
ui <- fluidPage(
  tags$div(class = "app-container",

#Add logo
fluidRow(
  div(class = "right-image",
                   tags$img(src = "MedGermDB_LOGOS.png", height = "200px", width = "500px"),
              column(
         width = 3,
         # Content of the first column
       )))),

    #Add title
    fluidRow(
            column(
              width = 12,
              div(class = "right-title",
                  titlePanel("a Germination Database for Mediterranean plants", windowTitle = "a Germination Database for Mediterranean plants"),
             # )
            ))),
    
    #Sidebar to choose species to display
    selectizeInput("spp", label = "Species", choices = spp, selected = spp[1]),
    
     fluidRow(
       column(width = 12,
              plotOutput("plot_map", width = "800px", height = "400px"))),  # Add your actual figure output here
    
    mainPanel(plotOutput("plot_germination"), #Mean germination proportions
              br(),  # Add a line break to create space between elements
              tags$div(
                style = "text-align: center; font-size: 16px; font-weight: bold; margin-bottom: 10px;",
                "Taxonomic information"),
              tableOutput("taxa"),
              tags$div(
                style = "text-align: center; font-size: 16px; font-weight: bold; margin-bottom: 10px;",
                "EUNIS HABITAT INFORMATION"),
              tableOutput("habitats"),
              tableOutput("table"), #To define: 1. References 2.Taxonomic info 3. Number of records 
                        
    # Add Bookmark Button
    bookmarkButton()
      )
    )
 
 # Define server
 server <- function(input, output) {
   
   output$plot_map <- renderPlot({
     # filter by species
     x <- coord_sf %>%
       filter(coord_sf$accepted_binomial == input$spp)
          # draw the map for the species
     mapplot(coord_sf = x)
   })
   
   output$plot_germination <- renderPlot({
     # filter by species
     y <- Germination %>%
       filter(Germination$species == input$spp)
          # draw the germination plot for the species
     seedplot(Germination = y)
   })
   
   output$taxa <- renderTable({
     taxanomic(taxa.file, input$spp)
   })
   
   output$habitats <- renderTable({
     habitat(habitat.file, input$spp)
   })
   
   output$table <- renderTable({
     references(dat1, input$spp)
   })
}
 
# Run the application 
shinyApp(ui = ui, server = server)



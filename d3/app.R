library(igraph)
library(networkD3)
library(dplyr)
library(htmlwidgets)
library(ggplot2)
library(jsonlite)
library(shiny)

mydata <- read.csv('/Users/xchen/Library/CloudStorage/OneDrive-RMI/Desktop/_storefront/oneobj/node_water.csv')
df <- data.frame(mydata, stringAsFactors = FALSE)
nodes_csv <- data.frame(name = unique(unlist(mydata)), stringsAsFactors = FALSE)
nodes_csv$id <- 0:(nrow(nodes_csv) - 1)

edges_csv <- df %>%
  left_join(nodes_csv, by = c("source" = "name")) %>%
  select(-source) %>%
  rename(source = id) %>%
  left_join(nodes_csv, by = c("target" = "name")) %>%
  select(-target) %>%
  rename(target = id)


edges_csv$width <- 1
nodes_csv$group <- ifelse(grepl("NODE", nodes_csv$name),"tigers", "lions")
ColourScale <- 'd3.scaleOrdinal()
            .domain(["lions", "tigers"])
           .range(["#FF6900", "#694489"]);'
# runExample("01_hello")
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    mainPanel(
      h1("Header 1"),
      forceNetworkOutput(outputId = "myplot")
    )
  )
)
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  # output$distPlot <- renderPlot({
  #   
  #   x    <- faithful$waiting
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   hist(x, breaks = bins, col = "#007bc2", border = "white",
  #        xlab = "Waiting time to next eruption (in mins)",
  #        main = "Histogram of waiting times")
  #   
  # })
  # define the data for the plot


  # output the networkD3 plot
  output$myplot <- renderForceNetwork({
    forceNetwork(
      Links = edges_csv,
      Nodes = nodes_csv,
      Source = "source",
      Target = "target",
      NodeID ="name",
      Group = "group",
      Value = "width",
      opacity = 0.9,
      zoom = TRUE,
      opacityNoHover = 1,
      arrows = TRUE,
      colourScale = JS(ColourScale)
    )
  })
  # src <- c("A", "B", "C")
  # target <- c("B", "C", "D")
  # networkData <- data.frame(src, target)
  # 
  # output$myplot <- renderSimpleNetwork({
  #   simpleNetwork(networkData)
  # })

}
shinyApp(ui = ui, server = server)

network <- forceNetwork(
  Links = edges_csv,
  Nodes = nodes_csv,
  Source = "source",
  Target = "target",
  NodeID ="name",
  Group = "group",
  Value = "width",
  opacity = 0.9,
  zoom = TRUE,
  opacityNoHover = 1,
  arrows = TRUE,
  colourScale = JS(ColourScale)
)

saveWidget(network, "mynetwork.html", selfcontained=TRUE)
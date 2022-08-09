library(shiny)
library(dplyr)
library(tidyverse)
library(shinythemes)
starwars_UI = function(id) {
  navbarPage(
    "Star Wars",
    tabPanel("Character Wiki", 
             sidebarPanel(
               selectInput(NS(id,"character_name"),"Select Character Name",choices = starwars$name)
             ),
             mainPanel(
               tableOutput(NS(id,"appearance_data")),
               tableOutput(NS(id,"films_data")),
               tableOutput(NS(id,"vehicles_data")),
               tableOutput(NS(id,"starships_data"))
             )
             
    ),
    tabPanel("Species Wiki",
             sidebarPanel(
               selectInput(NS(id,"numeric_variable"), "Select A Numerical Variable to Look Up ", choices = colnames(select(starwars,c(height,mass)))),
               selectInput(NS(id,"species_name"), "Select Species", choices = starwars$species),
               selectInput(NS(id,"category_name"),"Select A  Variable to Look Up ", choices = c("height","mass","hair_color","skin_color",
                                                                                                "eye_color","birth_year","sex","gender",
                                                                                                "homeworld"))
             ),
             mainPanel(
               plotOutput(NS(id,"bar_plot")),
               plotOutput(NS(id,"scatter_plot"))
             ))
  )
}

character_wikiServer = function(id) {
  moduleServer(id,function(input,output,session) {
    starwars_df = as.data.frame(starwars)
    characters = select(starwars_df,name)
    starwars_df = select(starwars_df, - name)
    starwars_df = as.data.frame(t(starwars_df))
    colnames(starwars_df) = characters$name
    
    appearance = starwars_df[1:10, ]
    output$appearance_data = renderTable({select(appearance,input$character_name)}, rownames = TRUE)
    
    output$films_data = renderTable({starwars_df["films",input$character_name]})
    output$vehicles_data = renderTable({starwars_df["vehicles",input$character_name]})
    output$starships_data = renderTable({starwars_df["starships",input$character_name]})
  })
}

species_wikiServer = function(id) {
  moduleServer(id,function(input,output,session) {
    starwars = as.data.frame(starwars)
    output$bar_plot = renderPlot({
      starwars %>% ggplot(aes(fill=species, y=species, x = starwars[[input$numeric_variable]])) + 
        geom_boxplot() +
        geom_jitter(color="purple",size=0.2, alpha= 10) +
        labs(x = input$numeric_variable)
    })
    output$scatter_plot = renderPlot({
      starwars = filter(starwars, species == input$species_name)
      starwars  %>% 
        ggplot(aes(x = starwars[[input$category_name]] ,y = name)) +
        geom_point(color = "red") +
        labs(x = input$category_name)
    })
  })
}

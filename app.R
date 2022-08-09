source("starwarswiki_modules.R")

ui = fluidPage(
  theme= shinytheme("yeti"),
  starwars_UI("sw")
)
server= function(input,output,session) {
  character_wikiServer("sw")
  species_wikiServer("sw")
}

shinyApp(ui, server)


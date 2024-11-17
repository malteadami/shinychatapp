library(shiny)
library(shinychat)
library(elmer)
library(bslib)


source("modules/chatbox.R")


# Chats
tabs <- c("chat1"=1,"chat2"=2)

# App Main Script
ui <- page_navbar(
  title = tags$span(
    "ShinyChatApp",
    actionButton(
      "addtab",
      label = NULL,
      icon = icon("plus"),
      style = "width:30px;height:30px;padding:0px"
    )
  ), 
  navset_tab(id = "tabs")
)


server <- function(input, output, session) {
  
  # Init chatbox ui
  lapply(names(tabs), function(tb){
    nav_insert(
      id="tabs", target = NULL, select = TRUE,
      nav_panel(tb, chatbox_ui(tb), style="height:100%;")
    )
  })
  
  # Init chatbox servers
  lapply(names(tabs), function(tb){chatbox_server(tb)})
  
  
  # Init reactive values
  sdat <- reactiveValues(
    tabs=tabs
  )
  
  # Add new chat tab
  observeEvent(input$addtab, {
    
    newtab <- max(sdat$tabs)+1
    tb <- names(newtab) <- paste0("Chat",newtab)
    
    # Insert new ui
    nav_insert(
      id="tabs", target = NULL, select = TRUE,
      nav_panel(tb, chatbox_ui(tb))
    )
    
    # Init new server
    chatbox_server(tb)
    
    # Update reactive values
    sdat$tabs <- c(sdat$tabs, newtab)
    
  }, ignoreInit = T)
  
  
}

shinyApp(ui, server)

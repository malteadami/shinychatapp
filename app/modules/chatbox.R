# Chatbox Ui Module
chatbox_ui <- function(id) {
  ns <- NS(id)
  page_sidebar(
    sidebar = sidebar(
      selectInput(ns("model"),"Model", c("gpt-4o-mini", "gpt-4o")),
      textAreaInput(ns("sprompt"),"Systemprompt","You are a helpful bot")
    ),
    fillable_mobile=T,
    card(
      card_header(id),
      card_body(
        chat_ui(ns("chat")),
        height = 600
        )

    )
  )
}

# Chatbox Server Module
chatbox_server <- function(id, system_prompt = "") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    chat <- reactiveVal(NULL)
    
    # Init/update openai model
    observeEvent(input$model,{
      chat(elmer::chat_openai(
        system_prompt =input$sprompt,
        model = input$model))
    })
    
    # Update system prompt
    observeEvent(input$sprompt,{
      chat()$set_system_prompt(input$sprompt)
    })
    
    # Send message and receive the reply stream
    observeEvent(input$chat_user_input, {
      stream <- chat()$stream_async(input$chat_user_input)
      chat_append(ns("chat"), stream)
    }, ignoreInit = T)
    
    
    
  })
}
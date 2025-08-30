library(shiny)
library(httr)
library(jsonlite)
library(ggplot2)
library(shinyjs)

api_url <- "http://python-app:8000/predict"

LABELS <- list(
  ES = list(
    title = "Docker DS Emoji Classifier 🐳✨",
    desc = "¡Convierte mensajes en emociones y emojis usando Python + R en Docker!",
    howto = HTML('<b>¿Cómo funciona?</b><br>1. Escribe una frase (español o inglés).<br>2. Haz clic en <b>Predecir 🔮</b>.<br>3. ¡Mira el emoji y la confianza!'),
    input = "Tu mensaje:",
    button = "Predecir 🔮",
    help = "Ejemplos: ‘odio esto’, ‘me duermo’, ‘party time!’, ‘amo docker’.",
    pred = "Resultado de la predicción",
    conf = "Probabilidades por emoción",
    table_label = "Emoción",
    table_emoji = "Emoji",
    table_conf = "Confianza",
    error = "No se pudo conectar al modelo. Intenta de nuevo.",
    footer = "Hecho con ❤️ en Python, R y Docker Compose • Demo para Data Scientists 🧑‍💻"
  ),
  EN = list(
    title = "Docker DS Emoji Classifier 🐳✨",
    desc = "Turn messages into emotions and emojis using Python + R in Docker!",
    howto = HTML('<b>How does it work?</b><br>1. Type a phrase (English or Spanish).<br>2. Click <b>Predict 🔮</b>.<br>3. See the emoji and prediction confidence!'),
    input = "Your message:",
    button = "Predict 🔮",
    help = "Examples: ‘i hate bugs’, ‘need a nap’, ‘party time!’, ‘love docker’.",
    pred = "Prediction result",
    conf = "Class probabilities",
    table_label = "Label",
    table_emoji = "Emoji",
    table_conf = "Confidence",
    error = "Could not connect to model. Please try again.",
    footer = "Made with ❤️ in Python, R and Docker Compose • Demo for Data Scientists 🧑‍💻"
  )
)

ui <- fluidPage(
  useShinyjs(),
  tags$head(tags$style(HTML('
    body { background: linear-gradient(120deg, #f3e6fa 0%, #e9d0f7 100%); font-family: "Segoe UI", Arial, sans-serif; }
    .emoji { font-size: 90px; text-align: center; margin: 10px 0 20px 0; opacity: 0; transition: opacity 0.7s; }
    .emoji.visible { opacity: 1; }
    .brand { font-weight: 700; letter-spacing: 0.5px; color: #a21caf; font-size: 2.3em; margin-bottom: 10px; }
    .desc { color: #7c3aed; font-size: 1.15em; margin-bottom: 18px; }
    .panel { background: #fff; border-radius: 14px; box-shadow: 0 2px 16px #a21caf22; padding: 25px 30px; margin-bottom: 15px; }
    .howto { background: #f3e8ff; border-left: 5px solid #a21caf; padding: 14px; border-radius: 8px; margin-bottom: 20px; }
    .footer { color: #a78bfa; font-size: 0.97em; margin-top: 25px; text-align: center; }
    .shiny-input-container { margin-bottom: 15px; }
    .btn-primary { background: #a21caf; border: none; font-weight: 600; color: #fff; }
    .btn-primary:hover { background: #7c3aed; }
    .lang-toggle { margin-bottom: 20px; }
    .error-msg { color: #be185d; font-weight: 600; margin: 12px 0; text-align: center; }
    .bar-label { font-size: 1.1em; }
  '))),
  div(class = "brand", textOutput("title")),
  div(class = "desc", textOutput("desc")),
  div(class = "howto", htmlOutput("howto")),
  fluidRow(
    column(3, div(class = "lang-toggle", radioButtons("lang", NULL, c("Español" = "ES", "English" = "EN"), inline = TRUE, selected = "ES"))),
    column(9)
  ),
  sidebarLayout(
    sidebarPanel(class = "panel",
      textAreaInput("text", label = NULL, placeholder = "Ej: Me encanta programar / I love Docker!", rows = 4),
      actionButton("go", label = "Predecir 🔮", class = "btn-primary"),
      br(),
      helpText(textOutput("help")),
      textOutput("error_msg")
    ),
    mainPanel(class = "panel",
      div(class = "emoji", uiOutput("emoji_out")),
      h4(textOutput("pred_label")),
      tableOutput("pred_table"),
      br(),
      h4(textOutput("conf_label")),
      plotOutput("conf_plot", height = "230px"),
      br(),
      div(class = "footer", textOutput("footer"))
    )
  )
)

server <- function(input, output, session) {
  lang <- reactiveVal("ES")
  observeEvent(input$lang, lang(input$lang))

  pred <- reactiveVal(list(prediction = list(label = NA, emoji = NA, confidence = NA), alternatives = NULL, message = NULL, error = FALSE))
  emoji_class <- reactiveVal("emoji")

  observeEvent(input$go, {
    txt <- trimws(input$text)
    if (nchar(txt) == 0) {
      pred(list(prediction = list(label = NA, emoji = NA, confidence = NA), alternatives = NULL, message = NULL, error = FALSE))
      emoji_class("emoji")
      return()
    }
    res <- try({
      r <- POST(api_url, body = list(text = txt), encode = "json", timeout(6))
      stop_for_status(r)
      content(r, as = "text", encoding = "UTF-8")
    }, silent = TRUE)
    if (inherits(res, "try-error")) {
      pred(list(prediction = list(label = NA, emoji = "❌", confidence = NA), alternatives = NULL, message = NULL, error = TRUE))
      emoji_class("emoji visible")
      return()
    }
    js <- fromJSON(res)
    pred(list(prediction = js$prediction, alternatives = js$alternatives, message = js$message, error = FALSE))
    emoji_class("emoji")
    shinyjs::delay(10, emoji_class("emoji visible"))
  })

  observeEvent(input$lang, {
    # Reset fade-in when changing language
    emoji_class("emoji")
    shinyjs::delay(10, emoji_class("emoji visible"))
  })

  output$title <- renderText({ LABELS[[lang()]]$title })
  output$desc <- renderText({ LABELS[[lang()]]$desc })
  output$howto <- renderUI({ LABELS[[lang()]]$howto })
  output$help <- renderText({ LABELS[[lang()]]$help })
  output$pred_label <- renderText({ LABELS[[lang()]]$pred })
  output$conf_label <- renderText({ LABELS[[lang()]]$conf })
  output$footer <- renderText({ LABELS[[lang()]]$footer })
  output$error_msg <- renderText({
    p <- pred()
    if (!is.null(p$error) && p$error) LABELS[[lang()]]$error else ""
  })

  output$emoji_out <- renderUI({
    p <- pred()
    cl <- emoji_class()
    tags$span(class = cl, {
      if (is.null(p$prediction$emoji) || is.na(p$prediction$emoji)) "🤔" else p$prediction$emoji
    })
  })

  output$pred_table <- renderTable({
    p <- pred()
    if (is.null(p$prediction$label) || is.na(p$prediction$label)) return(NULL)
    setNames(
      data.frame(
        p$prediction$label,
        p$prediction$emoji,
        round(p$prediction$confidence, 3),
        check.names = FALSE
      ),
      c(LABELS[[lang()]]$table_label,
        LABELS[[lang()]]$table_emoji,
        LABELS[[lang()]]$table_conf)
    )
  })

  output$conf_plot <- renderPlot({
    p <- pred()
    if (is.null(p$alternatives) || length(p$alternatives) == 0) return(NULL)
    alt <- p$alternatives
    if (!is.list(alt[[1]])) alt <- list(alt)  # Forzar lista de listas si solo hay una alternativa
    df <- data.frame(
      label = sapply(alt, function(x) paste0(x$label, " ", x$emoji)),
      confidence = sapply(alt, function(x) x$confidence)
    )
    ggplot(df, aes(x = reorder(label, confidence), y = confidence, fill = confidence)) +
      geom_col(width = 0.7, show.legend = FALSE) +
      coord_flip() +
      scale_fill_gradient(low = "#ede9fe", high = "#a21caf") +
      ylim(0, 1) +
      labs(x = NULL, y = NULL) +
      theme_minimal(base_size = 15) +
      theme(axis.text.x = element_text(size = 13), axis.text.y = element_text(size = 15, face = "bold"))
  })
}

shinyApp(ui, server)

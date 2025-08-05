library(shiny)
library(shinythemes)
library(rsconnect)


# Define UI for the Shiny App
ui <- fluidPage(
  theme = shinytheme("flatly"),
  h2("Kalkulator Uji Hipotesis", style = "
  font-family : 'Lobster';
  color : Dark blue
  "),
  tags$head(
    tags$style(
      ".header {
                   text-align: center;
                   font-size: 32px;
                   font-weight: bold;
                   color: #FFFFFF;
                   background-color: #337AB7;
                   padding: 15px;
                   margin-bottom: 30px;
                   }",
      ".navbar {
          width: 100%;
          margin-left: 0%;
          margin-right: 0%;
      }"
    ),
    tags$link(rel="stylesheet",type="text/css",href="bootstrap.min.css")
  ),
  navbarPage("",
             tabPanel("Home",
                      h1("Uji Hipotesis Satu Populasi"),
                      h4("Uji hipotesis satu populasi yang tersedia dalam kalkulator ini meliputi uji T, uji Z untuk proporsi dan uji Z untuk mean"),
                      h3("1. Uji T"),
                      h4("Uji ini diperuntukkan untuk melihat rata-rata dari suatu data. Uji T digunakan apabila jumlah sampel dalam data kurang dari 30"),
                      h3("2. Uji Z untuk proporsi"),
                      h4("Uji ini diperuntukkan untuk melihat proporsi dari suatu data menggunakan uji Z"),
                      h3("3. Uji Z untuk Mean"),
                      h4("Uji ini diperuntukkan untuk melihat rata-rata dari suatu data. Uji Z digunakan apabila jumlah data dalam sampel lebih dari 30 data"),
                      br(),
                      h1("Uji Hipotesis Dua Populasi"),
                      h4("Uji hipotesis dua populasi yang tersedia dalam kalkulator ini meliputi Uji Selisih Proporsi, Uji T, Paired T-Test, Uji Z dengan Varians Diketahui dan Uji Z dengan Varians Tidak Diketahui"),
                      h3("1. Uji Selisih Proporsi"),
                      h4("Uji selisih proporsi digunakan untuk melihat selisih proporsi yang terdapat dalam dua populasi"),
                      h3("2. Uji T"),
                      h4("Uji T diperuntukkan untuk melihat rata-rata dalam dua populasi yang mana jumlah data kurang dari 30 data"),
                      h3("3. Paired T-Test"),
                      h4("Paired T-Test digunakan untuk melihat rata-rata dalam pasangan observasi data. Jumlah data pada observasi 1 dan observasi 2 harus berjumlah sama"),
                      h3("4.Uji Z dengan Varians Diketahui"),
                      h4("Uji Z dengan varians diketahui digunakan untuk melihat rata-rata dalam 2 populasi yang mana jumlah data melebihi 30 data dengan syarat varians diketahui pada soal"),
                      h3("5.Uji Z dengan Varians Tidak Diketahui"),
                      h4("Uji Z dengan varians tidak diketahui digunakan untuk melihat rata-rata dalam 2 populasi yang mana jumlah data melebihi 30 data dengan syarat varians tidak diketahui pada soal"),
             ),
             tabPanel("Uji Hipotesis Satu Populasi",
                      sidebarPanel(
                        h3("Hypothesis Testing Calculator"),
                        selectInput("Input_Data", "Input Data?", choices = c("Yes", "No")),
                        selectInput("test_type", "Select Test Type",
                                    choices = c("T-Test", "Z-Test for Proportion", "Z-Test for Mean")),
                        numericInput("significance_level", "Significance Level:", value = 0.05),
                        conditionalPanel(
                          condition = "input.Input_Data == 'Yes'",
                          textInput("data_input", "Input data (separated by comma):"),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'T-Test' && input.Input_Data == 'No'",
                          numericInput("hypothesized_mean", "Hypothesized Mean:", value = 0),
                          numericInput("Xbar", "Xbar:", value = 0),
                          numericInput("S", "Standard Deviation (S):", value = 0),
                          numericInput("n", "Sample (n):", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'Z-Test for Proportion' && input.Input_Data == 'No'",
                          numericInput("ptopi", "Ptopi:", value = 0),
                          numericInput("P0", "P0:", value = 0),
                          numericInput("n", "Sample (n):", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'Z-Test for Mean' && input.Input_Data == 'No'",
                          numericInput("hypothesized_mean", "Hypothesized Mean:", value = 0),
                          numericInput("Xbar", "Xbar:", value = 0),
                          numericInput("Sigma", "Variance (Sigma):", value = 0),
                          numericInput("n", "Sample (n):", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'T-Test' && input.Input_Data == 'Yes'",
                          numericInput("hypothesized_mean", "Hypothesized Mean:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'Z-Test for Proportion' && input.Input_Data == 'Yes'",
                          numericInput("x_prop", "Nilai x untuk proporsi:", value = 0),     
                          numericInput("P0", "P0:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type == 'Z-Test for Mean' && input.Input_Data == 'Yes'",
                          numericInput("hypothesized_mean", "Hypothesized Mean:", value = 0),
                        ),
                        br(),
                        actionButton("calculate", "Calculate")
                      ),
                      mainPanel(
                        h3("Test Results"),
                        tableOutput("test_results")
                      )
             ),
             tabPanel("Uji Hipotesis Dua Populasi",
                      sidebarPanel(
                        h3("Hypothesis Testing Calculator"),
                        selectInput("test_type1", "Select Test Type",
                                    choices = c("Uji Selisih Proporsi","Uji T", "Paired T-Test", "Uji Z dengan Varians Diketahui", "Uji Z dengan Varians Tidak Diketahui")),
                        textInput("data1_input", "Input data 1(separated by comma):"),
                        textInput("data2_input", "Input data 2(separated by comma):"),
                        numericInput("significance_level1", "Significance Level:", value = 0.05),
                        conditionalPanel(
                          condition = "input.test_type1 == 'Uji Selisih Proporsi'",
                          numericInput("x_prop1", "Nilai x_1 untuk proporsi:", value = 0),
                          numericInput("x_prop2", "Nilai x_2 untuk proporsi:", value = 0),
                          numericInput("hypothesized_prop", "Hypothesized Difference Proportion:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type1 == 'Uji T'",
                          numericInput("hypothesized_difmean", "Hypothesized Difference Mean:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type1 == 'Paired T-Test'",
                          numericInput("hypothesized_difmean", "Hypothesized Difference Mean:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type1 == 'Uji Z dengan Varians Diketahui'",
                          numericInput("hypothesized_difmean", "Hypothesized Difference Mean:", value = 0),
                        ),
                        conditionalPanel(
                          condition = "input.test_type1 == 'Uji Z dengan Varians Tidak Diketahui'",
                          numericInput("hypothesized_difmean", "Hypothesized Difference Mean:", value = 0),
                        ),
                        br(),
                        actionButton("calculate2", "Calculate"),
                      ),
                      mainPanel(
                        h3("Test Results"),
                        tableOutput("test_results_2")
                      )
             )
  )
)



# Define server logic for the Shiny App
server <- function(input, output) {
  # Function to perform hypothesis testing for one population
  performOnePopulationTest <- function(test_type, Input_Data, data_input, hypothesized_mean, hypothesized_proportion, Xbar, S, n, Sigma, ptopi, P0, significance_level) {
    # Initialize the data variable
    data <- as.numeric(unlist(strsplit(data_input, ",")))
    # Perform the appropriate test based on test_type
    if (test_type == "T-Test") {
      if (Input_Data == "No") {
        se <- S/sqrt(n)
      } else if (Input_Data == "Yes") {
        Xbar <- mean(data)
        n <- length(data)
        sample_sd <- sd(data)
        se <- sample_sd / sqrt(n)
      }
      # Perform t-test
      test_statistic <- (Xbar - hypothesized_mean) / se
      critical_value <- qt(1 - significance_level, df = n - 1)
      p_value <- pt(test_statistic, df = n - 1, lower.tail = FALSE)
    } else if (test_type == "Z-Test for Proportion") {
      # Perform z-test for proportion
      if (Input_Data == "No") {
        hypothesized_proportion <- P0
        se <- sqrt((hypothesized_proportion*(1-hypothesized_proportion))/(n))
      } else if (Input_Data == "Yes") {
        hypothesized_proportion <- P0
        n <- length(data)
        sample_proportion <- mean(data)
        x<-input$x_prop
        ptopi<- x/n
        se <- sqrt((hypothesized_proportion*(1-hypothesized_proportion))/(n))
      }
      test_statistic <- (ptopi-hypothesized_proportion)/se
      critical_value <- qnorm(1 - significance_level)
      p_value <- 2 * (1 - pnorm(abs(test_statistic)))
    } else if (test_type == "Z-Test for Mean") {
      # Perform z-test for mean
      if (Input_Data == "No") {
        hypothesized_mean <- hypothesized_mean
        se <- Sigma/sqrt(n)
      } else if (Input_Data == "Yes") {
        hypothesized_mean <- hypothesized_mean
        Xbar <- mean(data)
        n <- length(data)
        sample_sd <- sd(data)
        se <- sample_sd / sqrt(n)
      }
      test_statistic <- (Xbar - hypothesized_mean) / se
      critical_value <- qnorm(1 - significance_level)
      p_value <- 2 * (1 - pnorm(abs(test_statistic)))
    }
    
    # Create a data frame to store the test results
    test_results <- data.frame(
      Test_Type = test_type,
      Test_Statistic = test_statistic,
      Critical_Value = critical_value,
      P_Value = p_value,
      Result = ifelse(abs(test_statistic) > critical_value, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    
    return(test_results)
  }
  
  # Function to perform hypothesis testing for two population
  # Function to calculate Z-Test for Variance Known 2pop
  calc_z_2popmean_test <- function(data1,data2, hypothesized_difmean, significance_level1) {
    sample1_mean <- mean(data1)
    sample2_mean <-mean(data2)
    sample1_size <- length(data1)
    sample2_size <-length(data2)
    sample1_sd <- sd(data1)
    sample2_sd <- sd(data2)
    se <- sqrt(((sample1_sd)^2/sample1_size)+((sample2_sd)^2/sample2_size))
    z_statistic <- (sample1_mean - sample2_mean-hypothesized_difmean)/se
    p_value <- 2*pnorm(-abs(z_statistic))
    result1 <- data.frame(
      Test = "Uji Z dengan Varians Diketahui",
      n1 = sample1_size,
      n2 = sample2_size,
      Standard_Error = se,
      Z_Statistic = z_statistic,
      P_Value = p_value,
      significance_level = significance_level1,
      Result = ifelse(p_value < significance_level1, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    return(result1)
  }
  
  # Function to calculate Z-Test for Variance Unknown 2pop
  calc_z_2popmeanuknvar_test <- function(data1,data2, hypothesized_difmean, significance_level1) {
    sample1_mean <- mean(data1)
    sample2_mean <-mean(data2)
    sample1_size <- length(data1)
    sample2_size <-length(data2)
    sample1_sd <- sd(data1)
    sample2_sd <- sd(data2)
    se <- sqrt((sample1_sd/sample1_size)+(sample2_sd/sample2_size))
    z_statistic <- (sample1_mean - sample2_mean-hypothesized_difmean)/se
    p_value <- 2*pnorm(-abs(z_statistic))
    result1 <- data.frame(
      Test = "Uji Z dengan Varians Tidak Diketahui",
      n1 = sample1_size,
      n2 = sample2_size,
      Standard_Error = se,
      Z_Statistic = z_statistic,
      P_Value = p_value,
      significance_level = significance_level1,
      Result = ifelse(p_value < significance_level1, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    return(result1)
  }
  
  # Function to calculate t-Test
  calc_t_2pop_test <- function(data1,data2, hypothesized_difmean, significance_level1) {
    sample1_mean <- mean(data1)
    sample2_mean <- mean(data2)
    sample1_size <- length(data1)
    sample2_size <- length(data2)
    sample1_sd <- sd(data1)
    sample2_sd <- sd(data2)
    var1 <- (sample1_sd)^2
    var2 <- (sample2_sd)^2
    # Handling case where both samples have the same variance or not
    if (var1 == var2) {
      sp <- ((var1*(sample1_size -1))+(var2*(sample2_size - 1))/(sample1_size + sample2_size - 2))
      t_statistic <- (sample1_mean - sample2_mean - hypothesized_difmean) / (sp * sqrt((1/sample1_size) + (1/sample2_size)))
      df <- sample1_size + sample2_size - 2
      p_value <- 2 * pt(-abs(t_statistic), df)
    } else {
      sp_pembilang <- (((var1)/sample1_size)+((var2)/sample2_size))^2
      sp_penyebut <- (((var1/sample1_size)^2)/(sample1_size - 1)) + (((var2/sample2_size)^2)/(sample2_size - 1))
      df <- sp_pembilang / sp_penyebut
      t_statistic <- (sample1_mean - sample2_mean - hypothesized_difmean) / (sqrt(((var2/sample2_size)^2)/(sample2_size - 1)))
      p_value <- 2 * pt(-abs(t_statistic), df)
    }
    
    result1 <- data.frame(
      Test = "Uji T",
      n1 = sample1_size,
      n2 = sample2_size,
      var_1 =  var1,
      var_2 = var2,
      T_Statistic = t_statistic,
      P_Value = p_value,
      significance_level = significance_level1,
      Result = ifelse(p_value < significance_level1, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    return(result1)
  }
  
  # Function to calculate paired-T test
  calc_paired_T_test <- function(data1, data2, hypothesized_difmean, significance_level1) {
    if(length(data1) != length(data2)) {
      message("Error: data1 and data2 must have the same length.")
      stop()
    }
    
    diff <- data1 - data2
    sample1_size <- length(diff)
    sample_mean <- mean(diff)
    sample_sd <- sd(diff)
    se <- sample_sd/sqrt(sample1_size)
    t_statistic <- (sample_mean - hypothesized_difmean)/se
    p_value <- 2 * pt(-abs(t_statistic), df = sample1_size - 1)
    
    result1 <- data.frame(
      Test = "Paired T-Test",
      n = sample1_size,
      Mean_Difference = sample_mean,
      Standard_Error = se,
      T_Statistic = t_statistic,
      P_Value = p_value,
      significance_level = significance_level1,
      Result = ifelse(p_value < significance_level1, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    return(result1)
  }
  
  # Function to calculate Difference proportion population
  calc_2prop <- function(data1, data2, hypothesized_prop, x_prop1, x_prop2, significance_level1) {
    xprop1<-input$x_prop1
    xprop2<-input$x_prop2
    sample1_size <- length(data1)
    sample2_size <-length(data2)
    ptopi1<-xprop1/sample1_size
    ptopi2<-xprop2/sample2_size
    pbar<-((xprop1+xprop2)/(sample1_size+sample2_size))
    se <- sqrt((pbar*(1-pbar))*((1/sample1_size)+(1/sample2_size)))
    z_statistic <- (ptopi1-ptopi2 - hypothesized_prop)/se
    p_value <- 2*pnorm(-abs(z_statistic))
    result1 <- data.frame(
      Test = "Uji Selisih Proporsi",
      n1 = sample1_size,
      n2 = sample2_size,
      x1 = xprop1,
      x2 = xprop2,
      Standard_Error = se,
      Z_Statistic = z_statistic,
      P_Value = p_value,
      significance_level = significance_level1,
      Result = ifelse(p_value < significance_level1, "Reject Null Hypothesis", "Fail to Reject Null Hypothesis")
    )
    return(result1)
  }
  # Function to perform hypothesis testing for two populations
  performTwoPopulationTest <- function(test_type, data1_input, data2_input, hypothesized_difmean, significance_level1) {
    # Initialize the data variables
    data1 <- as.numeric(unlist(strsplit(data1_input, ",")))
    data2 <- as.numeric(unlist(strsplit(data2_input, ",")))
    hypothesized_prop <- input$hypothesized_prop
    
    # Perform the appropriate test based on test_type
    if (test_type == "Uji Selisih Proporsi") {
      test_results1<- calc_2prop(data1, data2, hypothesized_prop, x_prop1, x_prop2, significance_level1)
    } else if (test_type == "Uji T") {
      # Calculate the t-test
      test_results1 <- calc_t_2pop_test(data1, data2, hypothesized_difmean, significance_level1)
    } else if (test_type == "Paired T-Test") {
      # Perform paired T-test
      test_results1 <- calc_paired_T_test(data1, data2, hypothesized_difmean, significance_level1)
    } else if (test_type == "Uji Z dengan Varians Diketahui") {
      # Calculate the Z-Test with known variances
      test_results1 <- calc_z_2popmean_test(data1, data2, hypothesized_difmean, significance_level1)
    } else if (test_type == "Uji Z dengan Varians Tidak Diketahui") {
      # Calculate the Z-Test with unknown variances
      test_results1 <- calc_z_2popmeanuknvar_test(data1, data2, hypothesized_difmean, significance_level1)
    }
    
    return(test_results1)
  }
  # Event handler for the calculate button in the first tab
  observeEvent(input$calculate, {
    test_type <- input$test_type
    Input_Data <- input$Input_Data
    data_input <- input$data_input
    hypothesized_mean <- input$hypothesized_mean
    hypothesized_proportion <- input$ptopi
    Xbar <- input$Xbar
    S <- input$S
    n <- input$n
    Sigma <- input$Sigma
    ptopi <- input$ptopi
    P0 <- input$P0
    significance_level <- input$significance_level
    
    test_results <- performOnePopulationTest(test_type, Input_Data, data_input, hypothesized_mean, hypothesized_proportion, Xbar, S, n, Sigma, ptopi, P0, significance_level)
    
    output$test_results <- renderTable(test_results)
  })
  
  
  #Function to process input data and call the appropriate function
  observeEvent(input$calculate2, {
    test_type1 <- input$test_type1
    data1_input <- input$data1_input
    data2_input <- input$data2_input
    hypothesized_difmean <- input$hypothesized_difmean
    significance_level1 <- input$significance_level1
    
    test_results_2 <- performTwoPopulationTest(test_type1, data1_input, data2_input, hypothesized_difmean, significance_level1)
    
    output$test_results_2 <- renderTable(test_results_2)
  })
}

# Run the Shiny App
shinyApp(ui = ui, server = server)

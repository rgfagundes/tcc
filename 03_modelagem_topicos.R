# carregando pacotes
library(dplyr)
library(tidytext)
library(tidyr)
library(tm)
library(topicmodels)
library(reshape2)


# Criar a matriz de documento-termo
dtm <- tokens |>
  count(cdacordao, word) |>
  cast_dtm(document = cdacordao, term = word, value = n)

# Definir o número de tópicos 
num_topicos <- 3

# Treinar o modelo LDA
lda_model <- LDA(dtm, k = num_topicos, control = list(seed = 1234))

# Extrair os tópicos
topicos <- tidy(lda_model, matrix = "beta")

# Visualizar os top termos para cada tópico
top_termos <- topicos |>
  group_by(topic) |>
  top_n(6, beta) |>
  ungroup() |>
  arrange(topic, -beta)

print(top_termos)

# Visualizar a distribuição de tópicos para os documentos
doc_topicos <- tidy(lda_model, matrix = "gamma")

# Mostrar os primeiros resultados
head(doc_topicos)


doc_topicos_dominantes <- doc_topicos |>
  group_by(document) |>
  top_n(1, gamma) |>
  ungroup() |>
  arrange(as.numeric(document))

colnames(doc_topicos_dominantes)[1] <- "cdacordao"
doc_topicos_dominantes$cdacordao <- as.integer(doc_topicos_dominantes$cdacordao)

print(doc_topicos_dominantes)

# Carregar pacotes
library(dplyr)
library(stringr)
library(tidytext)
library(quanteda)
library(textstem)


# Carregar dataframe
tjsp <- read.csv("dataset_1.csv", header = TRUE, sep = ",")

# Remover linhas com a coluna "julgado" em branco e linhas duplicadas
tjsp_tratado <- tjsp |>
  filter(!is.na(julgado)) |>
  distinct(processo, .keep_all = TRUE)

# Identificar assuntos dos processos e suas respectivas frequências
frequencias <- table(tjsp_tratado$assunto)
frequencias_df <- as.data.frame(frequencias)
colnames(frequencias_df) <- c("Assunto", "Frequência")
View(frequencias_df)

# Assuntos identificados "manualmente" como não relevantes
assuntos <- read.csv("assuntos_remover.csv", sep = ";")$assunto

# Substituir as aspas do assunto "Lavagem"
tjsp_tratado$assunto <- str_replace(
  tjsp_tratado$assunto, 
  '"Lavagem" ou Ocultação de Bens, Direitos ou Valores Oriundos de Corrupção', 
  'Lavagem ou Ocultação de Bens, Direitos ou Valores Oriundos de Corrupção'
)


# Remover assuntos não relevantes
tjsp_tratado <- tjsp_tratado |>
  filter(!assunto %in% assuntos)


# Criar listas com nomes dos relatores, cidades e orgão julgador
nome_relator <- paste(str_to_lower(unique(tjsp_tratado$relator)), collapse = "|")
nome_cidade <- paste(str_to_lower(unique(tjsp_tratado$comarca)), collapse = "|")
nome_orgao <- paste(str_to_lower(unique(tjsp_tratado$orgao_julgador)), collapse = "|")

# Pré-processamento do texto
tjsp_tratado$acordao_tratado <- str_to_lower(tjsp_tratado$julgado)
tjsp_tratado$acordao_tratado <- sub(".*?(acórdão)", " ", tjsp_tratado$acordao_tratado)

tjsp_tratado <- tjsp_tratado |>
  mutate(acordao_tratado = acordao_tratado |>
           str_replace_all("poder judiciário\\s+tribunal de justiça (do estado de são paulo|do estado)?", "")|> # Remover termos que aparecem no cabeçalho das páginas
           str_replace_all("tribunal de justiça\\s+poder judiciário", "") |> # Remover termos que aparecem no cabeçalho das páginas
           str_replace_all("assinatura eletrônica", "") |> # Remover termos da assinatura eletrônica
           str_replace_all("\\n", " ") |> # Remover "\n"
           str_replace_all(nome_relator,"") |> # Remover nome do relator
           str_replace_all(nome_cidade,"") |> # Remover nome da cidade
           str_replace_all(nome_orgao,"") |> # Remover nome do orgão julgador
           str_replace_all("\\b\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{2,4}\\b", " ") |> # Remover datas no formato dd/mm/aaaa
           str_replace_all("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.(com|com\\.br)\\b", " ") |> # Remover e-mails
           str_replace_all("https?://\\S+|www\\.\\S+", " ") |> # Remover URLs
           str_replace_all("[[:punct:]]", " ") |> # Remover pontuação
           str_replace_all("º|ª|°", "") |> # Remover caracteres especiais
           str_replace_all("[0-9]", "") |> # Remover números
           str_replace_all("\\b[A-Za-z]\\b", " ") |> # Remover letras individuais
           str_replace_all("\\s+", " ") |> # Remover espaços em branco extras
           str_squish()) # Remover espaços extras no início e final do texto


# Tokenizar
tokens <- tjsp_tratado |>
  unnest_tokens(word, acordao_tratado)


# Remover 'stopwords'
  # Criar dataframe de stopwords
  stop_w <- tibble(word = stopwords("pt"))
  
  stop_w_adicionais <- c("auto", "acórdão", "decisão", "voto", "relatados", 
                         "comarca", "vistos", "discutidos", "julgamento",
                         "tribunal", "acordam", "participação", "proferir", 
                         "desembargadores", "autos", "justiça", "seguinte", 
                         "presidente", "integra", "conformidade", "relator",
                         "relatório", "art", "artigo", "disse", "havia", 
                         "tendo", "sendo", "dia", "dizer", "ação", "processo",
                         "declaração", "recurso", "processo", "apelação", "fls")
  
  stop_w <- tibble(word = union(stop_w$word, stop_w_adicionais))
  
  tokens <- tokens |>
    anti_join(stop_w)
  
  

# Calcular TF-IDF
tf_idf <- tokens |>
  count(cdacordao, word, sort = TRUE) |> # Contar a frequência das palavras
  bind_tf_idf(word, cdacordao, n) # Calcular TF-IDF


  
  
  
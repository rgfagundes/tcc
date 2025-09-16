# Carregar pacotes
library(remotes)

# Instalar pacotes do GitHub
remotes::install_github("jjesusfilho/tjsp")

library(tjsp)
library(dplyr)


# Definir palavras-chave
busca <- c("abuso OR exploração AND sexual AND infantojuvenil AND internet", 
           "estupro AND virtual", "ameaças AND massacres AND escolas", 
           "estelionato AND fraude AND eletrônica", "extorsão AND cibernético", 
           "furto AND fraude AND eletrônica", 
           "invasão AND dispositivos AND informáticos", 
           "cyberstalking", "cyberbullying", "revenge AND porn", 
           "induzimento OR instigação OR auxílio AND suicídio OR 
           automutilação AND redes AND sociais", "perseguição AND virtual", 
           "phishing", "ransomware", "malware", "spyware", "crime AND cibernético")

##### Extração jurisprudência #####

# Função para realizar a busca e leitura dos processos
baixar_e_ler_tjsp <- function(palavra) {
  diretorio <- "~/tcc/tjsp"
  
  # Criar diretório se não existir
  if (!dir.exists(diretorio)) {
    dir.create(diretorio, recursive = TRUE)
  }
  
  tjsp_baixar_cjsg(livre = palavra, 
                   n = max, 
                   diretorio = diretorio)
  
  cjsg <- tjsp_ler_cjsg(diretorio = diretorio)
  return(cjsg)
}

# Realizar a busca e leitura dos processos
resultados_tjsp <- lapply(busca, baixar_e_ler_tjsp)

# Combinar os resultados em um único dataframe
tj <- do.call(rbind, resultados_tjsp)
View(tj)

# Remover linhas duplicadas 
tj <- tj |>
  distinct(processo, .keep_all = TRUE)


# Novo Data Frame para armazenar os acordãos
tjsp_acordao <- data.frame()

# Diretório para armazenar temporariamentos os pdfs
diretorio = "~/Estatística/tcc/tjsp_acordao"

# Loop para processar cada acordão
for (i in 1:nrow(tj)) {
  
  id <- tj$cdacordao[i]
  
  # Baixar o acordão
  tjsp_baixar_acordaos_cjsg(id, diretorio = diretorio)
  
  # Ler o acordão baixado
  acordao_lido <- tjsp_ler_acordaos_cjsg(
    arquivos = NULL,
    diretorio = diretorio,
    remover_assinatura = TRUE,
    combinar = TRUE
  )
  
  # Combinar o resultado atual com o resultado final
  tjsp_acordao <- rbind(tjsp_acordao, acordao_lido)
  
  # Excluir os arquivos do diretório
  arquivos <- list.files(path = diretorio, full.names = TRUE)
  file.remove(arquivos)
  
}

### Combinar acórdãos com data frame original
tjsp_acordao$cdacordao <- as.integer(tjsp_acordao$cdacordao)
tjsp_completo <- left_join(tj, tjsp_acordao, by = "cdacordao")

### Escrever o dataframe em um arquivo CSV
write.csv(tjsp_completo, file = "tjsp_acordao.csv", row.names = FALSE)





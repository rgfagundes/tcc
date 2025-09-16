# Trabalho de Conclusão de Curso
**Autor:** Ruth Gabriela Marques Fagundes  
**Título:** Modelagem de dados jurídicos: Exploração Estatística e Análise de Crimes Cibernéticos  
**Resumo:**  

<p align="justify">  
A escassez de dados estruturados e acessíveis sobre crimes cibernéticos no Brasil representa um obstáculo para análises quantitativas e para o desenvolvimento de ferramentas de monitoramento. Este trabalho tem como objetivo analisar processos judiciais de segunda instância do Tribunal de Justiça de São Paulo relacionados a crimes cibernéticos, por meio de técnicas estatísticas e de processamento de linguagem natural. Para tanto, foi construída uma base de dados a partir da extração e organização de processos judiciais, submetida a etapas de pré-processamento textual. Em seguida, aplicou-se o método de modelagem de tópicos Latent Dirichlet Allocation (LDA), que permitiu identificar categorias temáticas recorrentes. Também foram testados modelos de classificação supervisionada, comparando representações textuais com TF-IDF e BERTimbau. Os resultados indicaram desempenhos superiores para os modelos baseados em TF-IDF, especialmente para os classificadores XGBoost e LightGBM, que alcançaram acurácia de 0,83 e AUC de 0,90. Esses achados demonstram o potencial do uso combinado de técnicas de mineração de texto e aprendizado de máquina para apoiar a categorização de processos judiciais e contribuir para o entendimento dos crimes cibernéticos no contexto jurídico brasileiro.
</p>

# Sobre o Projeto  
Trabalho desenvolvido no Instituto de Matemática e Estatística (IME) da Universidade Federal de Uberlândia (UFU), como requisito para obtenção do grau de Bacharel em Estatística.

# Estrutura do repositório 
- `01_extracao_dados.R` → coleta e extração dos dados brutos;  
- `02_preprocessamento.R` → limpeza, preparação dos dados e pré-processamento textual;  
- `03_modelagem_topicos.R` → modelagem de tópicos (LDA);  
- `04_classificacao_tfidf.ipynb` → modelos de classificação baseados em representações **TF-IDF**, com avaliação e visualização de resultados;  
- `04_classificacao_bertimbau.ipynb` → modelos de classificação baseados em representações com **BERTimbau**, com avaliação e visualização de resultados;  
- `requirements.txt` → pacotes Python necessários para rodar os notebooks.  


# 🖥️ Cálculo de Modelo de Fundo em Assembly MIPS-32

## 📝 Resumo
Este projeto implementa um programa em **Assembly MIPS-32** para calcular o **modelo de fundo** de uma cena a partir de uma sequência de imagens PGM (P2 - ASCII). O método utiliza a **média temporal dos valores dos pixels** para identificar elementos estáticos da cena, isolando o fundo de objetos em movimento.

---

## ⚙️ Funcionalidades
- Leitura de múltiplos arquivos PGM de entrada.  
- Acumulação dos valores de cada pixel em um buffer de inteiros para evitar overflow.  
- Cálculo da **média de cada pixel** dividindo a soma pelo número total de frames.  
- Criação de um arquivo PGM de saída com o **modelo de fundo** resultante.  
- Modularidade: funções separadas para leitura de frames, cálculo de média e escrita do arquivo de saída.  
- Funções auxiliares para conversão entre **inteiro e string ASCII** e leitura de inteiros do arquivo.  

---

## 🛠️ Como funciona
1. O programa lê uma sequência de imagens PGM.  
2. Para cada pixel, soma os valores correspondentes em todas as imagens.  
3. Após processar todos os frames, calcula a média de cada pixel.  
4. Escreve a imagem resultante (`modelo_fundo.pgm`) com o fundo calculado.  
5. Funções auxiliares gerenciam leitura e escrita de inteiros em ASCII.  

---

## 🎯 Resultados
- Implementação bem-sucedida da **lógica de acumulação e cálculo de média** de pixels.  
- Geração de arquivo PGM com valores médios calculados.  
- Exercício prático sobre **programação em baixo nível**, gestão de memória e pilha, e manipulação de arquivos.  
- Demonstração da complexidade de implementar processamento de imagens em **Assembly MIPS-32**.  

---

## ⚙️ Tecnologias Utilizadas
- **Linguagem:** Assembly MIPS-32  
- **Simulador:** MARS  
- **Formato de Imagem:** PGM 
- **Conceitos:** Manipulação de arquivos, buffers de pixels, média temporal, conversão ASCII, modularização de funções.

---

# Usa uma imagem base do Ubuntu (ou Debian) para ter controle total
FROM ubuntu:22.04

# Instala as dependências: nginx, bash, curl (para baixar ícones, se necessário)
RUN apt-get update && \
    apt-get install -y nginx curl lsb-release procps && \
    apt-get clean

# Cria diretório de trabalho
WORKDIR /app

# Copia o script e o arquivo alunos.txt para o container
COPY gerar_pagina.sh alunos.txt ./

# Torna o script executável
RUN chmod +x gerar_pagina.sh

# Executa o script para gerar o arquivo alunos.html
RUN ./gerar_pagina.sh

# Copia o arquivo alunos.html para o diretório do Nginx
RUN mv alunos.html /var/www/html/index.html

# Exponha a porta padrão do Nginx
EXPOSE 80

# Inicia o Nginx em foreground
CMD ["nginx", "-g", "daemon off;"]

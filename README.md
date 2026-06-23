# Procedimento

git clone sbaron81/unifebe

cd unifebe

docker build -t usuario_github/nome_imagem .

docker run -d -p 8080:80 -d usuario_github/nome_imagem

http://ip_do_linux:8080

docker login

docker push usuario_github/nome_imagem

FEItv - Relatório do Projeto
Projeto da disciplina CCM310 - Arquitetura de Software e Programação Orientada a Objetos
Nome: Matheus da Cunha Cres
1. Introdução
O FEItv é um sistema de CRUD e consulta de vídeos inspirado em plataformas de streaming, mas com foco apenas na organização e no compartilhamento de informações. O projeto foi desenvolvido em Java, com acesso ao banco de dados PostgreSQL e organização em MVC (Model, View e Controller).
O projeto tem as funções de cadastrar usuários, realizar login, buscar vídeos por nome, visualizar as informações dos vídeos encontrados, curtir e descurtir conteúdos e gerenciar listas de reprodução, adicionando ou removendo vídeos de cada lista. 

2. Estrutura do projeto
O projeto foi organizado em pacotes para separar responsabilidades e facilitar a manutenção:
• view: contém as telas em JFrame, como TelaInicial, TelaCadastro, TelaLogin e TelaPrincipal.
• controller: concentra as regras da aplicação e a comunicação entre a interface e o banco.
• dao: faz o acesso ao PostgreSQL e executa as consultas SQL.
• model: guarda as classes de dados, como Usuario, SerieFilme e ListaReproducao.
A classe principal FEITV inicia a aplicação e abre a primeira tela (em resumo, o main). A partir dela, o usuário escolhe entre cadastrar ou entrar no sistema. Depois do login, o sistema abre a tela principal com as funções de busca, reação e listas de reprodução.

3. Banco de dados e SQL
No PostgreSQL, o sistema utiliza tabelas para armazenar os usuários, os vídeos, as listas de reprodução e as reações (curtir/descurtir). A estrutura foi pensada para trabalhar com chaves estrangeiras e manter o vínculo entre os dados.

Script principal do banco de dados:

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha VARCHAR(60) NOT NULL
);

CREATE TABLE videos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('Filme', 'Série')),
    ano INT NOT NULL CHECK (ano BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)::INT),
    categoria VARCHAR(60) NOT NULL,
    detalhe VARCHAR(120) NOT NULL,
    likes INT NOT NULL DEFAULT 0 CHECK (likes >= 0),
    dislikes INT NOT NULL DEFAULT 0 CHECK (dislikes >= 0)
);

CREATE TABLE playlists (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    UNIQUE (usuario_id, nome),
    CONSTRAINT fk_playlists_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE
);

CREATE TABLE playlist_videos (
    playlist_id INT NOT NULL,
    video_id INT NOT NULL,
    PRIMARY KEY (playlist_id, video_id),
    CONSTRAINT fk_playlist_videos_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES playlists(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_playlist_videos_video
        FOREIGN KEY (video_id)
        REFERENCES videos(id)
        ON DELETE CASCADE
);

CREATE TABLE reacoes (
    usuario_id INT NOT NULL,
    video_id INT NOT NULL,
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('L', 'D')),
    PRIMARY KEY (usuario_id, video_id),
    CONSTRAINT fk_reacoes_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reacoes_video
        FOREIGN KEY (video_id)
        REFERENCES videos(id)
        ON DELETE CASCADE
);

INSERT INTO videos (titulo, descricao, tipo, ano, categoria, detalhe, likes, dislikes) VALUES
('Breaking Bad', 'Um professor de química passa a produzir metanfetamina.', 'Série', 2008, 'Drama', '5 temporadas', 0, 0),
('Interstellar', 'Uma equipe viaja pelo espaço para salvar a humanidade.', 'Filme', 2014, 'Ficção Científica', 'Christopher Nolan', 0, 0),
('Stranger Things', 'Um grupo de amigos enfrenta eventos sobrenaturais.', 'Série', 2016, 'Ficção', '4 temporadas', 0, 0),
('The Dark Knight', 'Batman enfrenta o Coringa em Gotham.', 'Filme', 2008, 'Ação', 'DC Comics', 0, 0),
('The Office', 'Comédia sobre o cotidiano de um escritório.', 'Série', 2005, 'Comédia', '9 temporadas', 0, 0),
('Inception', 'Um ladrão invade sonhos para roubar segredos.', 'Filme', 2010, 'Ficção Científica', 'Christopher Nolan', 0, 0),
('Friends', 'Seis amigos vivem situações engraçadas em Nova York.', 'Série', 1994, 'Comédia', '10 temporadas', 0, 0),
('Avengers: Endgame', 'Os heróis restantes enfrentam Thanos pela última vez.', 'Filme', 2019, 'Ação', 'Marvel Studios', 0, 0),
('Black Mirror', 'Série sobre os impactos da tecnologia na sociedade.', 'Série', 2011, 'Drama', 'Antologia', 0, 0),
('Parasite', 'Uma família pobre se infiltra na casa de uma família rica.', 'Filme', 2019, 'Drama', 'Oscar de Melhor Filme', 0, 0),
('Avatar', 'Uma expedição humana entra em conflito com os nativos de Pandora.', 'Filme', 2009, 'Ficção Científica', 'James Cameron', 0, 0),
('The Witcher', 'Um caçador de monstros percorre um continente repleto de perigos.', 'Série', 2019, 'Fantasia', '3 temporadas', 0, 0);



Os inserts iniciais servem para alimentar a tabela de vídeos e permitir testes de busca logo após a criação do banco. Assim, o sistema já abre com conteúdo disponível, sem depender de cadastro manual de todos os vídeos(já que essa funcionalidade só era pra ser feita, caso feito em dupla).

4. Funcionalidades principais
Cadastro de usuário: a tela de cadastro recebe nome, e-mail e senha. O controller valida os dados mais básicos e o DAO grava as informações na tabela usuarios.
Login: o usuário informa e-mail e senha. Se os dados existirem no banco, o sistema libera o acesso à tela principal.
Busca de vídeos: na tela principal, o usuário digita parte do título e o sistema consulta a tabela videos. Os resultados aparecem na lista, e ao selecionar um item os detalhes são mostrados na área de texto.
Curtir e descurtir: cada reação é registrada na tabela reacoes e atualiza os contadores likes e dislikes do vídeo.
Listas de reprodução: o usuário pode criar, renomear e excluir listas, além de adicionar ou remover vídeos de cada lista.

5. Organização do código e funcionamento
A camada de model representa os dados do sistema. Usuario guarda o nome, e-mail, senha e identificador. SerieFilme representa o conteúdo exibido na busca e na lista, enquanto ListaReproducao representa cada coleção criada pelo usuário.
A camada DAO faz a comunicação com o PostgreSQL. Conexao centraliza o acesso ao banco, UsuarioDAO trata os cadastros e autenticação, VideoDAO faz a leitura dos vídeos, ListaReproducaoDAO controla as listas e ReacaoDAO registra curtir e descurtir.
A camada controller fica entre a interface e o banco. Ela organiza as chamadas, trata os erros mais simples e evita que a tela precise lidar diretamente com SQL.
Na camada view, cada janela foi feita em JFrame, seguindo a ideia mostrada em aula. A primeira tela apresenta as opções de cadastrar ou entrar. Depois do login, a tela principal exibe as abas de busca, listas de reprodução e perfil, permitindo o uso do sistema de forma simples e direta.

6. Conclusão
O projeto FEItv reuniu conceitos POO, banco de dados e interface gráfica em uma aplicação única. A separação entre telas, controle, entre outros fatores, ajudaram a manter o código organizado e próximo do conteúdo visto em aula.
Sob esse viés, o sistema entrega para o usuário as funções de: criar conta, entrar, procurar vídeos, reagir aos conteúdos(like e deslike) e montar suas próprias listas de reprodução. O projeto também serviu para praticar o uso de JFrame, JDBC, SQL e MVC em um cenário realista de aplicação.

7. Diagrama do Projeto

 
![alt text](image.png)
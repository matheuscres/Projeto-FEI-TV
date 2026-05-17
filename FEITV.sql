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

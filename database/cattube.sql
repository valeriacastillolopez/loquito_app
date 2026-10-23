CREATE TABLE videos (
    id          SERIAL PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL,
    tag         VARCHAR(30),
    caption     TEXT         NOT NULL,
    hashtags    VARCHAR(200),
    video_url   TEXT         NOT NULL,
    likes       INTEGER      DEFAULT 0,
    comments    INTEGER      DEFAULT 0,
    shares      INTEGER      DEFAULT 0,
    created_at  TIMESTAMP    DEFAULT NOW()
);

INSERT INTO videos (username, tag, caption, hashtags, video_url, likes, comments, shares) VALUES
('@el_loquito_real', 'TEORÍA 1',
 'PRUEBA #47: LAS PALOMAS DE LA PLAZA SON DRONES DEL AYUNTAMIENTO. CUENTEN LOS CABLES.',
 '#DespiertaCentro #NoSonPalomas #Evidencia',
 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
 3400, 812, 210),
('@el_loquito_real', 'TEORÍA 2',
 'LA FUENTE DE LA PLAZA CAMBIA DE COLOR SEGÚN LO QUE PENSAMOS.',
 '#PruebaViva #MenteColectiva',
 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
 1100, 304, 58);
package com.cattube.api;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CatTubeRepository {

    private final JdbcTemplate jdbc;

    public CatTubeRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    // ------------------------------------------------------------- usuarios
    public List<UsuarioDto> listarUsuarios() {
        return jdbc.query(
                "SELECT id_usuario, username, seguidores FROM usuarios ORDER BY id_usuario",
                (rs, i) -> new UsuarioDto(
                        rs.getInt("id_usuario"),
                        rs.getString("username"),
                        rs.getInt("seguidores")));
    }

    public UsuarioDto buscarUsuario(int idUsuario) {
        List<UsuarioDto> r = jdbc.query(
                "SELECT id_usuario, username, seguidores FROM usuarios WHERE id_usuario = ?",
                (rs, i) -> new UsuarioDto(
                        rs.getInt("id_usuario"),
                        rs.getString("username"),
                        rs.getInt("seguidores")),
                idUsuario);
        return r.isEmpty() ? null : r.get(0);
    }

    // ---------------------------------------------------------------- feed
    /** Videos asignados a un usuario, con su progreso individual. */
    public List<FeedVideoDto> feedDe(int idUsuario) {
        String sql = """
                SELECT v.id_video,
                       v.titulo,
                       u.username,
                       v.caption,
                       v.hashtags,
                       v.video_url,
                       v.likes + COALESCE(p.likes_automaticos, 0) AS likes_total,
                       v.vistas,
                       v.comments,
                       v.shares,
                       COALESCE(p.liked, FALSE) AS liked
                FROM jugador_videos jv
                JOIN videos v   ON v.id_video   = jv.id_video
                JOIN usuarios u ON u.id_usuario = jv.id_usuario
                LEFT JOIN progreso_videos p
                       ON p.id_usuario = jv.id_usuario
                      AND p.id_video   = jv.id_video
                WHERE jv.id_usuario = ?
                ORDER BY v.id_video
                """;

        return jdbc.query(sql, (rs, i) -> new FeedVideoDto(
                rs.getInt("id_video"),
                rs.getString("titulo"),
                "TEORÍA " + rs.getInt("id_video"),
                rs.getString("username"),
                rs.getString("caption"),
                rs.getString("hashtags"),
                rs.getString("video_url"),
                rs.getInt("likes_total"),
                rs.getInt("vistas"),
                rs.getInt("comments"),
                rs.getInt("shares"),
                rs.getBoolean("liked")), idUsuario);
    }

    // --------------------------------------------------------- comentarios
    public List<ComentarioDto> comentariosDe(int idVideo) {
        String sql = """
                SELECT c.id_comentario,
                       c.id_usuario,
                       COALESCE(u.username, 'anónimo') AS username,
                       c.texto
                FROM comentarios c
                LEFT JOIN usuarios u ON u.id_usuario = c.id_usuario
                WHERE c.id_video = ?
                ORDER BY c.id_comentario DESC
                """;

        return jdbc.query(sql, (rs, i) -> new ComentarioDto(
                rs.getInt("id_comentario"),
                rs.getInt("id_usuario"),
                rs.getString("username"),
                rs.getString("texto")), idVideo);
    }

    // ESCRITURA ------------------------------------------------------------
    /** Marca o quita el like de un usuario en un video. */
    public void guardarLike(int idUsuario, int idVideo, boolean liked) {
        int filas = jdbc.update(
                "UPDATE progreso_videos SET liked = ? WHERE id_usuario = ? AND id_video = ?",
                liked, idUsuario, idVideo);

        if (filas == 0) { // todavía no había progreso: se crea la fila
            jdbc.update(
                    "INSERT INTO progreso_videos (id_usuario, id_video, liked, vistas, likes_automaticos) "
                            + "VALUES (?, ?, ?, 0, 0)",
                    idUsuario, idVideo, liked);
        }
    }

    // ESCRITURA ------------------------------------------------------------
    public ComentarioDto guardarComentario(int idUsuario, int idVideo, String texto) {
        Integer id = jdbc.queryForObject(
                "INSERT INTO comentarios (id_usuario, id_video, texto) VALUES (?, ?, ?) "
                        + "RETURNING id_comentario",
                Integer.class, idUsuario, idVideo, texto);

        UsuarioDto u = buscarUsuario(idUsuario);
        return new ComentarioDto(
                id == null ? 0 : id,
                idUsuario,
                u == null ? "anónimo" : u.username(),
                texto);
    }
}
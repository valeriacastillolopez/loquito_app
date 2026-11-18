package com.cattube.api;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api")
public class CatTubeController {

    private final CatTubeRepository repo;

    public CatTubeController(CatTubeRepository repo) {
        this.repo = repo;
    }

    @GetMapping("/usuarios")
    public List<UsuarioDto> usuarios() {
        return repo.listarUsuarios();
    }

    @GetMapping("/usuarios/{idUsuario}")
    public UsuarioDto usuario(@PathVariable("idUsuario") int idUsuario) {
        UsuarioDto u = repo.buscarUsuario(idUsuario);
        if (u == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado");
        }
        return u;
    }

    /** Los videos asignados a ese usuario, con su progreso. */
    @GetMapping("/usuarios/{idUsuario}/videos")
    public List<FeedVideoDto> feed(@PathVariable("idUsuario") int idUsuario) {
        return repo.feedDe(idUsuario);
    }

    @GetMapping("/videos/{idVideo}/comentarios")
    public List<ComentarioDto> comentarios(@PathVariable("idVideo") int idVideo) {
        return repo.comentariosDe(idVideo);
    }

    // ESCRITURA (Etapa 3) -----------------------------------------------
    @PutMapping("/usuarios/{idUsuario}/videos/{idVideo}/like")
    public void like(@PathVariable("idUsuario") int idUsuario,
                     @PathVariable("idVideo") int idVideo,
                     @RequestParam("liked") boolean liked) {
        repo.guardarLike(idUsuario, idVideo, liked);
    }

    @PostMapping("/videos/{idVideo}/comentarios")
    public ComentarioDto comentar(@PathVariable("idVideo") int idVideo,
                                  @RequestBody NuevoComentario body) {
        if (body.texto() == null || body.texto().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El comentario está vacío");
        }
        return repo.guardarComentario(body.idUsuario(), idVideo, body.texto().trim());
    }

    public record NuevoComentario(int idUsuario, String texto) {}
}
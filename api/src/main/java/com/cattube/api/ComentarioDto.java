package com.cattube.api;

public record ComentarioDto(int id, int idUsuario, String username, String texto) {}
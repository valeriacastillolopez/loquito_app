package com.cattube.api;

/* Un video del feed, ya combinado con el progreso del usuario*/
public record FeedVideoDto(
        int id,
        String titulo,
        String tag,
        String username,
        String caption,
        String hashtags,
        String videoUrl,
        int likes,
        int vistas,
        int comments,
        int shares,
        boolean liked
) {}
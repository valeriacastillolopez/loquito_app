# Bitácora de versiones

Todos los cambios importantes de **El Loquito ** se registran aquí.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
versionado [SemVer](https://semver.org/lang/es/).


## [0.7.0]
### Actualizacion y correccion
- Se actualiza el nuevo apk con las correcciones y nuevas implementaciones de la app

## [0.7.0]
### Agregado
- Selector de usuario desplegable en el perfil para cambiar el perfil, los videos y los likes sin tocar el código.
- Endpoints de la API
- Comentarios reales leídos desde la base de datos.
- Perfil con el nombre y los seguidores del usuario activo.
### Cambiado
- La API se conecta a la base `loquito` (usuarios, videos, jugador_videos, progreso_videos y comentarios).
- El feed muestra los videos asignados al usuario y su progreso (likes).
- `application.properties.example` actualizado para la base nueva.
### Eliminado
- `Video`, `VideoRepository` y `VideoController`, de la base de prueba anterior.

## [0.6.0]
### Agregado temporalmente
- La app Teorías permite anotar teorías de forma temporal y borrarlas deslizando (opcional y como prueba porque eso se ve desde el juego).

## [0.5.1]
### Corregido
- Las pantallas Mapa del Centro y Radio Libre no mostraban contenido

## [0.5.0]
### Agregado
- Perfil del loquito ficha con foto, sellos de estadísticas y pestañas pruebas y mis reacciones.
- Visor de videos a pantalla completa desde el perfil.
- Ilustración del loquito como foto de perfil y en el feed.
- Barra inferior de CatTube con Inicio y Perfil.

## [0.4.0]
### Agregado
- Like en CatTube, también con doble toque.
- Comentarios con panel y campo para escribir.
- Compartir con panel y opción de copiar enlace.

## [0.3.0]
### Agregado
- APK instalable en teléfonos reales (queda opcional, no está en el mvp).
### Cambiado
- La dirección de la API se configura para emulador, teléfono real o Windows.
- Permisos de internet y tráfico HTTP en Android.

## [0.2.0]
### Agregado
- API REST en Spring Boot con PostgreSQL (`GET /api/videos`).
- Script de base de datos (`database/cattube.sql`).
- Reproducción de video real en CatTube para pruebas de que funcione la reproducción.
- README con las instrucciones de la API.

## [0.1.0]
### Agregado
- Teléfono del loquito: inicio tipo corcho con apps y dock.
- App CatTube con feed vertical deslizable.
- Pantallas decorativas de las demás apps, con botón para volver al inicio.
- Versión a pantalla completa, sin bisel.

[0.7.1]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.7.0.1...HEAD
[0.7.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.5.1...v0.6.0
[0.5.1]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/valeriacastillolopez/loquito_app/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/valeriacastillolopez/loquito_app/releases/tag/v0.1.0
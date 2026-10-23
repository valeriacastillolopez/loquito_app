# loquito
app para integradora, celular del loquito.

## Cómo correr la API
### Requisitos
- PostgreSQL instalado (usuario `postgres`, puerto 5432)
- JDK 17 o 21
- IntelliJ IDEA (o Maven desde la terminal)

### Pasos
1. En pgAdmin, crear una base de datos llamada `cattube`
2. En esa base, abre Query Tool y ejecuta el contenido de `database/cattube.sql`
3. En `api/src/main/resources/`, copia `application.properties.example` como
   `application.properties` y escribe tu contraseña de PostgreSQL.
   Ese archivo está en el `.gitignore` y no se sube al repositorio
4. Ejecuta la clase `ApiApplication` desde IntelliJ
5. Abre puerto 8080 y debe aparecer el JSON con los videos
6. http://localhost:8080/api/videos
7. En `lib/cat_tube/services/video_api.dart` configura la dirección de la API
  Emulador de Android: `10.0.2.2`, en un teléfono real va la IP de la PC en la red WiFi
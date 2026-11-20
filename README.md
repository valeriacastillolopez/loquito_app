# loquito
app para integradora, celular del loquito.

## Cómo correr la API
### Requisitos
- PostgreSQL instalado (usuario `postgres`, puerto 6543)
- JDK 17 o 21
- IntelliJ IDEA (o Maven desde la terminal)

### Pasos
1. Base de datos backend hosteada en Supabase
2. En `api/src/main/resources/application.properties` escribe usuario y contraseña de PostgreSQL.
   Ese archivo está en el `.gitignore` y no se sube al repositorio
3. Ejecuta la clase `ApiApplication` desde IntelliJ
4. En `lib/cat_tube/services/video_api.dart` configura la dirección de la API
  Emulador de Android: `10.0.2.2`, en un teléfono real va la IP de la PC en la red WiFi
5. Ejecutar app

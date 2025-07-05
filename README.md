# App de Sitios Turísticos

**Autor:** Darwin Cachimil

## Descripción
Esta aplicación Flutter permite a los usuarios explorar, publicar y reseñar sitios turísticos. Utiliza Supabase como backend para la autenticación y almacenamiento de datos.

## Características principales
- Registro y autenticación de usuarios (con validación por email)
- Publicación de sitios turísticos con imágenes y descripción
- Visualización de sitios publicados por otros usuarios
- Sistema de reseñas para cada sitio
- Roles de usuario: visitante y publicador
- Actualización automática de la lista de sitios al publicar
- Mensajes claros de éxito o error en acciones importantes

## Tecnologías utilizadas
- Flutter
- Supabase (auth y base de datos)
- Dart

## Instalación y ejecución
1. Clona este repositorio o descarga el código fuente.
2. Instala las dependencias:
   ```
   flutter pub get
   ```
3. Configura tus credenciales de Supabase en el archivo correspondiente (`supabase_service.dart`).
4. Para ejecutar en modo desarrollo:
   ```
   flutter run
   ```
5. Para generar el APK:
   ```
   flutter build apk --release
   ```
   El APK estará en `build/app/outputs/flutter-apk/app-release.apk`.

## APK FUNCIONAL

El archivo APK funcional para instalar y probar la app está disponible en la carpeta `apk/` del proyecto:

- `apk/app-release.apk`



## Notas
- Recuerda validar tu correo después de registrarte.
- Si publicas un sitio, la lista se actualiza automáticamente.
- Si tienes problemas de conexión en Android, asegúrate de tener el permiso de internet en el `AndroidManifest.xml`.

---

> Proyecto realizado por Darwin Cachimil para fines educativos.

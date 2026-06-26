# Catálogo de Planetas — Frontend Flutter Web

Frontend desarrollado en **Flutter Web** que consume un backend **Spring Boot**
para administrar un CRUD de planetas (listar, crear, editar y eliminar).

## Descripción

La aplicación muestra un listado de planetas en una tabla y permite:

- Consultar automáticamente el backend al iniciar la aplicación.
- Crear nuevos planetas.
- Editar planetas existentes.
- Eliminar planetas, con confirmación previa.
- Visualizar indicadores de carga y mensajes de error/éxito mediante `SnackBar`.

## Tecnologías utilizadas

- Flutter 3.x / Flutter Web
- Material Design (Material 3)
- Paquete [`http`](https://pub.dev/packages/http) para el consumo de la API REST
- `StatefulWidget` + `setState` (sin gestores de estado externos)
- GitHub Actions para CI/CD

## Estructura del proyecto

```
lib/
├── main.dart
├── models/
│   └── planeta.dart
├── services/
│   └── planeta_service.dart
├── pages/
│   ├── home_page.dart
│   └── formulario_page.dart
├── widgets/
│   ├── planeta_table.dart
│   └── confirm_delete_dialog.dart
└── utils/
    └── api_constants.dart
```

## Cómo instalar Flutter

1. Descarga el SDK de Flutter desde la página oficial:
   https://docs.flutter.dev/get-started/install
2. Agrega `flutter/bin` a la variable de entorno `PATH`.
3. Verifica la instalación con:

   ```bash
   flutter doctor
   ```

4. Asegúrate de tener habilitado el soporte web:

   ```bash
   flutter config --enable-web
   ```

## Instalación de dependencias del proyecto

Dentro de la carpeta del proyecto, ejecuta:

```bash
flutter pub get
```

## Ejecutar la aplicación en modo desarrollo

```bash
flutter run -d chrome
```

Esto abrirá la aplicación en Google Chrome, consumiendo el backend configurado
en `lib/utils/api_constants.dart`.

> **Importante:** el backend Spring Boot debe estar corriendo (por defecto en
> `http://localhost:8080`) para que la aplicación pueda listar, crear, editar
> y eliminar planetas correctamente.

## Configuración de la URL del backend (desarrollo → producción)

Toda la aplicación obtiene la URL del backend **exclusivamente** desde un único
archivo:

```
lib/utils/api_constants.dart
```

```dart
class ApiConstants {
  static const String baseUrl = "http://localhost:8080/api";
  static const String planetasEndpoint = "$baseUrl/planetas";
}
```

Para pasar de desarrollo a producción, **solo es necesario cambiar el valor de
`baseUrl`** en este archivo. Por ejemplo:

- Desarrollo:
  ```dart
  static const String baseUrl = "http://localhost:8080/api";
  ```

- Producción:
  ```dart
  static const String baseUrl = "https://mi-backend.onrender.com/api";
  ```

Ningún otro archivo del proyecto debe contener la URL del backend escrita de
forma manual; todos los servicios usan `ApiConstants.baseUrl` /
`ApiConstants.planetasEndpoint`.

## Cómo generar la build de producción

```bash
flutter build web
```

Los archivos generados quedarán disponibles en la carpeta:

```
build/web/
```

Estos archivos pueden desplegarse en cualquier servicio de hosting estático
(GitHub Pages, Netlify, Firebase Hosting, Render, etc.).

## Pruebas

```bash
flutter test
```

## Análisis estático

```bash
flutter analyze
```

## Integración continua

El proyecto incluye un workflow de GitHub Actions (`.github/workflows/flutter.yml`)
que, en cada `push`, instala Flutter, ejecuta `flutter pub get`,
`flutter analyze`, `flutter test`, genera el build web (`flutter build web`)
y publica automáticamente el resultado en GitHub Pages.

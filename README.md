# Hola Mundo Flutter App

Una aplicación de ejemplo en Flutter.

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente en tu máquina:

*   **Flutter SDK**: [Instrucciones de instalación](https://flutter.dev/docs/get-started/install)
*   **IDE**:
    *   [Android Studio](https://developer.android.com/studio) (recomendado para desarrollo Android)
    *   [VS Code](https://code.visualstudio.com/) con el plugin de Flutter (recomendado para desarrollo general)
*   **Dispositivo o Emulador**:
    *   Un dispositivo Android o iOS conectado y configurado para desarrollo.
    *   Un emulador de Android o simulador de iOS.
    *   Un navegador web (para desarrollo web).
    *   Soporte para escritorio (Linux, macOS, Windows) si planeas ejecutar la aplicación en esas plataformas.

## Primeros Pasos

Sigue estos pasos para obtener una copia del proyecto en tu máquina local y ejecutarlo para desarrollo y pruebas.

### 1. Clonar el Repositorio

Abre tu terminal o línea de comandos y ejecuta el siguiente comando para clonar el repositorio:

```bash
git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
cd TU_REPOSITORIO
```
**Nota**: Reemplaza `https://github.com/TU_USUARIO/TU_REPOSITORIO.git` con la URL real de tu repositorio de GitHub y `TU_REPOSITORIO` con el nombre de tu carpeta de proyecto.

### 2. Instalar Dependencias

Una vez que estés en el directorio del proyecto, instala todas las dependencias necesarias:

```bash
flutter pub get
```

### 3. Ejecutar la Aplicación

Asegúrate de tener un dispositivo conectado o un emulador/simulador en ejecución. Puedes verificar los dispositivos disponibles con:

```bash
flutter devices
```

Luego, ejecuta la aplicación en el dispositivo o emulador de tu elección:

```bash
flutter run
```

Si deseas ejecutarlo en una plataforma específica (por ejemplo, web o escritorio):

```bash
flutter run -d chrome   # Para ejecutar en el navegador Chrome
flutter run -d windows  # Para ejecutar en Windows (si está configurado)
flutter run -d linux    # Para ejecutar en Linux (si está configurado)
flutter run -d macos    # Para ejecutar en macOS (si está configurado)
```

### 4. Ejecutar Pruebas

Para ejecutar las pruebas unitarias y de widgets del proyecto:

```bash
flutter test
```

## Estructura del Proyecto

*   `lib/`: Contiene el código fuente de la aplicación.
    *   `main.dart`: El punto de entrada de la aplicación.
    *   `models/`: Definiciones de modelos de datos.
    *   `screens/`: Implementación de las diferentes pantallas de la UI.
    *   `services/`: Lógica de negocio y servicios (ej. base de datos, API).
    *   `widgets/`: Componentes de UI reutilizables.
*   `android/`: Archivos específicos de la plataforma Android.
*   `ios/`: Archivos específicos de la plataforma iOS.
*   `web/`: Archivos específicos de la plataforma Web.
*   `test/`: Pruebas unitarias y de widgets.
*   `pubspec.yaml`: Archivo de configuración del proyecto y gestión de dependencias.

---
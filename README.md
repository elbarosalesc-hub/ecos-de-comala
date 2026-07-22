# Ecos de Comala

Juego educativo interactivo basado en *Pedro Páramo*, preparado para Cloudflare Workers y D1.

## Configuración en Cloudflare

1. Crear una base D1 llamada `ecos-de-comala-db`.
2. Copiar su identificador.
3. En la configuración de compilación del Worker agregar la variable
   `CLOUDFLARE_D1_DATABASE_ID` con ese identificador.
4. Comando de compilación: `npm run build`.
5. Comando de despliegue: `npm run deploy`.

La aplicación crea automáticamente las tablas necesarias al recibir la primera solicitud.

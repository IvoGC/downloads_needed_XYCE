# Script para la instalación de Xyce en paralelo

## Descripción

Este repositorio cuenta con un script automatiza el proceso de instalación de **Xyce**, un simulador de circuitos de alto rendimiento desarrollado por Sandia National Laboratories, configurado para una instalación en modo paralelo. Se utiliza para realizar simulaciones de circuitos eléctricos y electrónicos de gran escala en múltiples núcleos o nodos de un clúster de computación. Además, el script instala las bibliotecas y dependencias necesarias para compilar **Trilinos** (la biblioteca de soporte de Xyce) y luego compilar **Xyce** con soporte para **MPI** (Message Passing Interface).

## Funcionalidad del Script

El script realiza los siguientes pasos:

1. **Preparación del entorno**: 
   - Crea un directorio donde se almacenarán las bibliotecas, el código fuente y las compilaciones.
   
2. **Descarga de los códigos fuente**:
   - Descarga los archivos comprimidos de los repositorios oficiales de **Xyce** y **Trilinos**, o permite usar un repositorio que contiene ambos archivos.

3. **Instalación de dependencias**:
   - Instala todas las bibliotecas y paquetes necesarios para compilar y ejecutar **Xyce** en paralelo, como compiladores, herramientas de construcción y bibliotecas numéricas.

4. **Instalación de **Trilinos**:
   - Descarga y compila la versión específica de **Trilinos** que es compatible con **Xyce** para su uso en simulaciones paralelas.

5. **Compilación de **Xyce**:
   - Configura y compila **Xyce** para su instalación en paralelo, con soporte para bibliotecas avanzadas y MPI.

6. **Impresión de un mensaje de éxito**:
   - Al finalizar, imprime un mensaje en la consola indicando que la instalación se ha completado con éxito.

## Requisitos y Ejecutar el Script

- **Permisos de administrador** (`sudo`).
- **Descargar codigos fuente** :
  Se debe contar con los codigos fuente decargados manualmente o dejar que el script los instale automaticamente.
- **Permisos de ejecución** del script:
  ```bash
  chmod +x script_parallel.sh
- **Ejecutar el script**:
  ```bash
   ./script_parallel.sh

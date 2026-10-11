# Pix-Puzzle — Revisión y propuestas de mejora

Documento de trabajo para aplicar mejoras poco a poco. No implica implementar todas las propuestas ni cambiar las reglas del juego.

## Alcance y estado de la revisión

Se revisaron los modelos, repositorio, Bloc/Cubit, pantallas, widget de tablero, pruebas, catálogo de niveles y las cuatro capturas de móvil disponibles. Antes de redactar este documento se volvió a consultar el código y el [sistema de diseño](design-system/pix-puzzle/MASTER.md).

Las capturas observadas durante la primera revisión no reflejan todas las mejoras que ahora contiene el código. Para describir el comportamiento actual se prioriza el código; conviene actualizar las capturas antes de valorar visualmente la nueva versión.

- Catálogo inspeccionado: **60 niveles**, repartidos en 14 fáciles, 26 medios y 20 difíciles.
- Tableros de entre **4×4 y 15×15**, sin códigos duplicados en la comprobación realizada.
- En la primera revisión, `flutter test` pasó sus **3 pruebas** y `flutter analyze` terminó sin incidencias. Son resultados de esa revisión, no una nueva validación de los cambios posteriores.
- No se ejecutó una sesión manual completa en dispositivos ni se reprodujeron fallos de almacenamiento. No se ha demostrado la resolubilidad de todos los niveles.
- Este documento añade únicamente propuestas; no modifica la aplicación.

### Cómo leer las propuestas

- **Confirmado:** visible en las capturas revisadas o directamente en el código actual.
- **Riesgo:** existe una ruta de código o una limitación que podría producir el problema; falta reproducirlo.
- **Opcional:** ampliación del producto, no un defecto.
- **P1:** priorizar por comprensión, jugabilidad o conservación del progreso. **P2:** siguiente ronda. **P3:** mantenimiento o mejora opcional.
- Esfuerzo relativo: **bajo**, cambio localizado; **medio**, afecta varios componentes; **alto**, requiere diseñar una interacción o persistencia nueva y validarla. No son estimaciones de calendario.

## Mejoras ya incorporadas

No es necesario volver a implementar estas propuestas de la revisión inicial:

| Mejora | Estado actual | Qué queda por comprobar |
|---|---|---|
| Etiquetas de los tableros | Existen `Target`, `Board` y `Stamp`. | Comprensión por nuevos jugadores y coherencia de idioma. |
| Diálogo de victoria legible | Texto breve, acciones con etiquetas y `Next` como botón principal. | Último nivel, tamaños pequeños y texto ampliado. |
| Reintento de carga | La pantalla de error ofrece `Retry`. | Recuperación de datos corruptos y mensajes comprensibles. |
| Tema compartido | Colores y estilos centralizados en `pix_theme.dart`. | Contraste real y adaptación a preferencias de accesibilidad. |
| Estado completado | Icono con etiqueta semántica y texto `Done`. | Resumen del progreso por dificultad. |
| Controles del juego | Tooltips e icono de reinicio más apropiado; tamaño mínimo de acciones definido en el tema. | Interacción accesible con las casillas, no solo con los botones. |

## 1. Navegación, contenido y aprendizaje

### UX-01 — Recuperar ancho en la lista de niveles

**Confirmado · P1 · Esfuerzo medio**

- **Evidencia:** [HomePage](pix_puzzle/lib/features/home/home_page.dart) mantiene una columna lateral con botones de 104 puntos, además de márgenes. Cada fila añade dos miniaturas antes del nombre. Las capturas iniciales muestran el espacio reducido disponible para el contenido.
- **Impacto:** nombres comprimidos; la elipsis actual evita múltiples líneas, pero no hace más reconocibles los niveles.
- **Propuesta:** mover la dificultad a un selector superior en móvil y dar a la lista todo el ancho. Reservar la disposición lateral para pantallas anchas. Si falta espacio, reducir la información secundaria antes que el nombre.
- **Comprobación:** lista legible a 320, 390 y 430 puntos de ancho, con niveles completados y texto ampliado; selección de dificultad visible y anunciada por accesibilidad.

### UX-02 — Separar nombres visibles e identificadores internos

**Confirmado · P1 · Esfuerzo bajo**

- **Evidencia:** inicio y juego muestran `level.name`, con valores como `1_001_super_facil` y sufijos provisionales `name`.
- **Impacto:** el usuario ve nombres de datos internos, a veces truncados.
- **Propuesta:** mostrar un número de nivel legible y un título solo cuando sea significativo; por ejemplo, «Nivel 1 · Primeros pasos». Mantener `code` y los nombres internos al hacer una primera mejora de presentación.
- **Comprobación:** ningún título visible contiene prefijos técnicos o `name`; niveles sin título tienen una alternativa limpia. Orden y progreso siguen siendo los mismos.

### UX-03 — Explicar la inversión de casillas

**Confirmado · P1 · Esfuerzo medio**

- **Evidencia:** las etiquetas actuales identifican los elementos, pero no hay una explicación interactiva de la regla XOR.
- **Impacto:** un jugador puede interpretar el sello como una herramienta que solo pinta, sin entender por qué también borra.
- **Propuesta:** una introducción breve y repetible desde Ayuda: «Cada toque invierte las casillas del sello. Dos aplicaciones sobre una casilla se cancelan». Mostrar un ejemplo de superposición y otro en un borde.
- **Comprobación:** se puede consultar y cerrar la ayuda sin alterar la partida. El ejemplo reproduce exactamente las reglas de `Level`.

### UX-04 — Mostrar el avance por dificultad

**Opcional · P2 · Esfuerzo bajo**

- **Evidencia:** ya se marca cada nivel terminado, pero no hay resumen del grupo.
- **Propuesta:** añadir «3 de 14 completados» y una acción para abrir el primer nivel pendiente del grupo. No bloquear niveles que hoy están disponibles.
- **Comprobación:** el contador se actualiza al completar, no aumenta al repetir un nivel y contempla el grupo completado.

### UX-05 — Unificar el idioma

**Confirmado · P2 · Esfuerzo medio**

- **Evidencia:** botones y mensajes están en inglés, mientras algunos nombres del catálogo están en español.
- **Propuesta:** elegir un idioma coherente para la interfaz; si se quiere ofrecer español e inglés, centralizar y localizar las cadenas, incluidos tooltips, errores y etiquetas accesibles.
- **Comprobación:** no quedan mezclas involuntarias; textos largos no ocultan controles y los identificadores persistidos no dependen del idioma.

## 2. Juego, distribución e interacción

### GAME-01 — Hacer utilizables los tableros grandes

**Confirmado en dimensiones; usabilidad pendiente de prueba · P1 · Esfuerzo alto**

- **Evidencia:** [GamePage](pix_puzzle/lib/features/game/game_page.dart) limita el tamaño solicitado a 280 puntos en móvil. Un tablero de 15×15 dispone como máximo de unos 18,7 puntos por casilla con ese límite, antes de posibles restricciones adicionales.
- **Impacto:** precisión táctil reducida en los niveles grandes.
- **Propuesta:** dar prioridad al tablero jugable, aprovechar el ancho y ofrecer ampliación con desplazamiento para los tableros densos. Mantener objetivo y sello consultables. Diseñar junto con GAME-03 para que mover o ampliar no coloque sellos.
- **Comprobación:** jugar los dos niveles de 15×15 en un móvil real; alcanzar las esquinas, mover la vista y ampliar sin jugadas accidentales.

### GAME-02 — Calcular el espacio real disponible

**Riesgo por inspección · P1 · Esfuerzo medio**

- **Evidencia:** la fórmula del tamaño no descuenta todos los elementos actuales: paneles con padding, etiquetas, separación y columna de herramientas. La composición mantiene los tableros apilados incluso en pantallas anchas.
- **Impacto:** posibles desbordamientos, restricciones de tamaño inesperadas o aprovechamiento pobre en horizontal y con texto grande.
- **Propuesta:** calcular el tablero desde las restricciones de su propio contenedor, incluir zonas seguras y usar una disposición distinta cuando ancho y alto lo permitan. Evitar tamaños mínimos que superen el espacio disponible.
- **Comprobación:** móvil pequeño, horizontal, tablet, web redimensionable y texto al 200 % sin errores de layout; las coordenadas pulsadas coinciden con las casillas dibujadas.

### GAME-03 — Confirmar la jugada al completar el toque

**Confirmado · P1 · Esfuerzo medio**

- **Evidencia:** [BoardGrid](pix_puzzle/lib/widgets/board_grid.dart) llama al callback desde `onTapDown`.
- **Impacto:** la jugada puede ocurrir antes de que termine el gesto; es especialmente relevante si se añade desplazamiento o zoom.
- **Propuesta:** aplicar el sello cuando se confirme un toque válido; reservar el contacto inicial para una posible previsualización. Usar las dimensiones reales del área dibujada para transformar coordenadas.
- **Comprobación:** toque simple genera una jugada; cancelar, arrastrar o pellizcar no genera ninguna. Validar bordes y coordenadas asimétricas, no solo el centro.

### GAME-04 — Evitar perder el tablero con un reinicio accidental

**Confirmado · P2 · Esfuerzo bajo/medio**

- **Evidencia:** `ResetPressed` reemplaza el estado y elimina el historial inmediatamente.
- **Propuesta:** pedir confirmación cuando haya jugadas; no interrumpir cuando el tablero ya esté vacío. Como alternativa futura, permitir deshacer el reinicio completo.
- **Comprobación:** cancelar conserva exactamente tablero e historial; confirmar limpia ambos. No confundir reiniciar una partida con borrar niveles completados.

### GAME-05 — Tratar explícitamente el final de dificultad

**Confirmado · P2 · Esfuerzo bajo**

- **Evidencia:** [CompleteDialog](pix_puzzle/lib/features/game/complete_dialog.dart) siempre ofrece `Next`; cuando `nextLevel` devuelve `null`, la pantalla vuelve al inicio.
- **Propuesta:** sustituir esa acción por «Volver a niveles» cuando no haya siguiente y explicar que se ha llegado al final del grupo. Solo decir «Dificultad completada» si todos sus niveles están terminados.
- **Comprobación:** último nivel con y sin niveles anteriores pendientes; navegación normal al siguiente en los demás casos.

### GAME-06 — Mejorar la respuesta visual sin distraer

**Opcional · P3 · Esfuerzo medio**

- **Evidencia:** el tablero representa el relleno, pero no visualiza los centros seleccionados ni el efecto anticipado del sello.
- **Propuesta:** explorar una previsualización del área afectada o una indicación discreta del último toque. Si se muestran centros seleccionados, diferenciarlos del relleno que determina la solución.
- **Comprobación:** los indicadores no tapan el patrón, no se interpretan como casillas adicionales y respetan la preferencia de reducir animaciones. Mantener la respuesta de la jugada inmediata, conforme al sistema de diseño.

## 3. Accesibilidad

### A11Y-01 — Poder operar el tablero sin apuntar con precisión

**Confirmado · P1 · Esfuerzo alto**

- **Evidencia:** `BoardGrid` permite una etiqueta semántica global opcional, pero no expone acciones por casilla ni navegación por teclado. Las instancias principales no proporcionan esa etiqueta global.
- **Impacto:** describir el tablero como un único botón no permite jugarlo mediante lector de pantalla.
- **Propuesta:** ofrecer navegación por filas y columnas, estado de cada casilla y activación accesible. En web, añadir foco visible, flechas y Enter/Espacio. Describir también el objetivo y el sello de forma consultable.
- **Comprobación:** completar un nivel sencillo con teclado y revisar el flujo con VoiceOver/TalkBack. Evitar anunciar todo el tablero tras cada toque.

### A11Y-02 — Verificar contraste y ampliación del texto

**Pendiente de validación · P2 · Esfuerzo medio**

- **Evidencia:** existen tokens de color y controles de tamaño mínimo, pero no se ha medido el contraste de todas las combinaciones ni probado el escalado de texto.
- **Propuesta:** comprobar especialmente `Done`, texto secundario, líneas de cuadrícula, estados deshabilitados y foco. Conservar texto/iconos además del color para comunicar estados.
- **Comprobación:** medir las combinaciones utilizadas y revisar texto al 200 % en inicio, juego y victoria; controles visibles y accionables.

## 4. Progreso, errores y persistencia

### DATA-01 — No bloquear la victoria si falla el guardado

**Riesgo por inspección · P1 · Esfuerzo medio**

- **Evidencia:** `_handleComplete` activa `_dialogOpen` y espera a `markDone` antes de abrir el diálogo. No captura errores ni libera el indicador con `finally`. El repositorio ignora el resultado booleano de `setString`.
- **Impacto:** si la escritura lanza una excepción, puede no aparecer la victoria y quedar activado el bloqueo local del diálogo. Si se informa un resultado fallido sin excepción, puede pasar inadvertido.
- **Propuesta:** separar la victoria del resultado de persistencia; liberar siempre el bloqueo, gestionar el resultado de escritura y ofrecer reintento sin exigir repetir el nivel. Distinguir progreso en memoria de progreso confirmado en almacenamiento.
- **Comprobación:** simular escritura correcta, resultado fallido y excepción; la victoria sigue siendo accesible, no se duplica el diálogo y el reintento conserva lo logrado.

### DATA-02 — Recuperarse de progreso local corrupto

**Riesgo por inspección · P1 · Esfuerzo medio**

- **Evidencia:** [LevelsRepository](pix_puzzle/lib/data/repositories/levels_repository.dart) decodifica y convierte directamente el JSON de preferencias. Un fallo se propaga hasta la carga del catálogo. El botón `Retry` vuelve a leer los mismos datos.
- **Propuesta:** distinguir fallo de catálogo y fallo de progreso. Validar el formato guardado, recuperar entradas válidas cuando sea posible y permitir acceder al catálogo con un aviso comprensible. No borrar silenciosamente datos que podrían recuperarse.
- **Comprobación:** preferencias vacías, JSON roto, tipo incorrecto, códigos desconocidos y datos válidos; no confundir error con ausencia de niveles.

### DATA-03 — Reanudar partidas en curso

**Opcional · P2 · Esfuerzo alto**

- **Evidencia:** solo se persisten códigos completados y `GameBloc` abre cada nivel mediante `forPlay()`, que crea un tablero vacío.
- **Propuesta:** guardar partida e historial de deshacer y ofrecer «Continuar». Usar `code` como identidad y una versión de formato. Elegir un alcance pequeño para empezar: una partida activa global.
- **Comprobación:** salir y entrar, cerrar y abrir la app, deshacer tras reanudar, reiniciar y completar; una partida incompatible no impide acceder a los niveles.

### DATA-04 — Presentar errores comprensibles

**Confirmado · P2 · Esfuerzo bajo**

- **Evidencia:** `LevelsCubit.load` utiliza `e.toString()` como mensaje mostrado al usuario.
- **Propuesta:** mostrar un mensaje breve y accionable, dejando el detalle técnico en diagnóstico. Mantener el reintento ya existente y distinguir carga fallida de catálogo vacío.
- **Comprobación:** un recurso ausente o JSON inválido muestra una explicación legible y permite reintentar cuando la causa se resuelve.

## 5. Modelo, datos y mantenimiento

### CODE-01 — Proteger la forma del catálogo

**Riesgo de futuras ediciones · P2 · Esfuerzo medio**

- **Evidencia:** `Level.fromJson` realiza conversiones directas; cálculo y dibujo asumen tableros cuadrados y sello de 3×3.
- **Propuesta:** validar dimensiones, tipos, códigos únicos y sello al cargar o mediante una comprobación del catálogo. Informar del nivel concreto que contiene un error.
- **Comprobación:** datos válidos y ejemplos con columnas ausentes, dimensiones inconsistentes o sello incorrecto; error localizable en lugar de una excepción de índice durante el juego.

### CODE-02 — Separar orden y dificultad del nombre

**Confirmado como acoplamiento · P3 · Esfuerzo medio**

- **Evidencia:** el repositorio ordena por `name` y filtra dificultad por prefijos como `1_`. La búsqueda del siguiente depende de esos grupos.
- **Propuesta:** a corto plazo, cambiar solo el nombre visible (UX-02). Si el catálogo crece, introducir metadatos explícitos de dificultad y orden, con compatibilidad para los datos actuales.
- **Comprobación:** cambiar un título o idioma no mueve un nivel de grupo, altera su sucesor ni pierde progreso.

### CODE-03 — Reforzar la inmutabilidad sin reescribir la arquitectura

**Riesgo de mantenimiento · P3 · Esfuerzo medio**

- **Evidencia:** las celdas son inmutables, pero las listas anidadas de `Level` siguen siendo mutables y públicas. `shouldRepaint` compara las referencias de las tablas.
- **Impacto:** una futura mutación directa podría saltarse las expectativas de Equatable y del repintado. No se ha observado ese fallo en las operaciones actuales, que clonan las tablas.
- **Propuesta:** documentar y proteger la inmutabilidad de las colecciones; conservar las reglas en `Level` y los ejes `[x][y]`.
- **Comprobación:** una jugada no modifica estados anteriores ni el nivel base; una modificación legítima se emite y repinta.

### CODE-04 — Optimizar solo si se detecta lentitud

**Opcional · P3 · Esfuerzo medio**

- **Evidencia:** cada toque clona tablas y recalcula el relleno recorriendo el tablero; no hay mediciones que demuestren un problema de rendimiento.
- **Propuesta:** medir primero los niveles de 15×15. Solo si es necesario, aplicar incrementalmente el XOR del sello manteniendo el resultado equivalente al recálculo completo.
- **Comprobación:** comparar resultados en secuencias de toques, bordes y deshacer; medir en dispositivo antes y después. Evitar añadir complejidad por una ganancia no demostrada.

### DOC-01 — Mantener documentación y capturas útiles

**Confirmado en la revisión inicial · P3 · Esfuerzo bajo**

- **Evidencia:** el README de la app consultado inicialmente era el generado por Flutter; las capturas iniciales difieren del código actual. El sistema de diseño describe celdas negras/blancas, mientras el código usa el token de tinta `#1A1A1A` para las llenas.
- **Propuesta:** documentar reglas, ejecución, pruebas y toma de capturas. Actualizar capturas al cambiar la interfaz y aclarar si «negro» significa tinta del tema o negro puro.
- **Comprobación:** una persona nueva puede arrancar el proyecto y comparar las pantallas actuales con ejemplos representativos, incluido un nivel grande y la victoria.

## 6. Pruebas que aportarían más valor

Las pruebas revisadas cubren una solución con sello de una casilla, alternar dos veces una selección y un toque en el tablero. Son una base, pero no demuestran el flujo completo.

| Área | Casos propuestos | Qué protegen |
|---|---|---|
| XOR | Superposición, doble toque, bordes, esquinas y sello asimétrico. | Inversión, recorte del sello y ejes `[x][y]`. |
| Inmutabilidad | Conservar referencias a estados anteriores tras jugadas y reinicios. | Evitar cambios retroactivos. |
| GameBloc | Toque válido/inválido, deshacer vacío y múltiple, reinicio, victoria y nuevo nivel. | Transiciones y bloqueo de jugadas tras completar. |
| Repositorio | Carga, persistencia, lectura posterior, datos corruptos, fallo de escritura y último nivel. | Conservación del progreso y recuperación. |
| Interfaz | Coordenada exacta fuera de la diagonal, gesto cancelado, botones deshabilitados y victoria. | Errores que la prueba actual del centro no detectaría. |
| Distribución | Móvil estrecho, horizontal, tablet, texto grande y nivel 15×15. | Desbordamientos y acceso a los controles. |
| Accesibilidad | Foco, nombres y acciones por casilla; prueba manual con lector. | Posibilidad real de jugar sin interacción táctil precisa. |
| Catálogo | Forma de todas las tablas, códigos únicos y agrupación. | Errores al editar los niveles. |

La resolubilidad de todo el catálogo sería una comprobación adicional útil si se dispone de soluciones de referencia o se añade un verificador. No debe darse por demostrada por validar la estructura del JSON.

## 7. Orden sugerido para trabajar poco a poco

Cada punto puede convertirse en una tarea independiente. Es una orientación, no un compromiso de implementación.

1. **Cambios pequeños y visibles:** nombres legibles (UX-02), mensajes de error (DATA-04) y final de dificultad (GAME-05).
2. **Proteger el progreso:** errores de guardado (DATA-01), progreso corrupto (DATA-02) y confirmación de reinicio (GAME-04), con pruebas de esas rutas.
3. **Mejorar el espacio:** selector superior (UX-01) y cálculo real del layout (GAME-02); actualizar capturas.
4. **Facilitar aprender y jugar:** ayuda XOR (UX-03), semántica/teclado (A11Y-01) y revisión de contraste/texto (A11Y-02).
5. **Interacción avanzada:** confirmar gestos (GAME-03) y ampliación para tableros grandes (GAME-01), probadas juntas.
6. **Comodidad y mantenimiento:** reanudar (DATA-03), resumen de avance (UX-04), idioma (UX-05), validación del catálogo y documentación.

Mantener la arquitectura actual de modelos, repositorio y Bloc/Cubit. No hace falta una reescritura para abordar estas mejoras. Conservar las reglas XOR, los índices `[x][y]` y la identidad de los niveles; cualquier cambio en esas áreas debe acompañarse de pruebas específicas.

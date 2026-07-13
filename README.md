# Hogar360: Descripción General del Proyecto

**Hogar360** es una aplicación móvil multiplataforma diseñada para ser la herramienta definitiva de gestión, remodelación y organización del hogar. Su objetivo es centralizar en una sola "súper-app" todas las necesidades matemáticas y espaciales que surgen al modificar una casa, eliminando la frustración de comprar materiales equivocados o muebles que no caben.

Con una interfaz visual amigable basada en la paleta de colores *"Spring Meadow"* (tonos cálidos, limpios y accesibles), la aplicación permite a los usuarios llevar el control técnico de su casa en el bolsillo.

---

## 🛠️ ¿Qué hace la aplicación? (Módulos Principales)

Toda la aplicación gira en torno a un concepto central: el usuario registra las habitaciones de su casa una sola vez, y a partir de ahí, la app utiliza esas medidas para automatizar cualquier cálculo.

### 1. Mis Espacios (El Registro Base)

Es el corazón de la app. El usuario crea su "Sala", "Cocina" o "Dormitorio" ingresando las medidas reales (largo, ancho y alto). Además, la app le permite registrar "huecos" como puertas y ventanas para que los cálculos futuros sean exactos.

### 2. Calculadora de Remodelación (Acabados)

Una vez que el espacio está registrado, la app resuelve las dudas de construcción al instante mediante fórmulas matemáticas automatizadas:

* **Pisos y Cerámicos:** Seleccionas el tamaño de la mayólica (ej. 60x60 cm) y la app calcula el área del piso, añade automáticamente un porcentaje de merma (para recortes o roturas) y te dice exactamente cuántas cajas necesitas comprar.
* **Pintura:** La app calcula los metros cuadrados de las paredes (restando automáticamente el espacio de las puertas y ventanas) y te indica cuántos galones de pintura necesitas según las capas que desees darle.

### 3. Validador de Espacios y Muebles (Organización)

Resuelve el problema de saber si un electrodoméstico o mueble nuevo va a entrar en la casa. El usuario ingresa las medidas del mueble que vio en la tienda, y la app cruza esos datos con las dimensiones de la habitación. Mediante un plano 2D interactivo, muestra visualmente si el mueble cabe, si bloquea el paso o si tapa algún elemento clave.

### 4. La FerreLista (Presupuesto y Compras)

Cada cálculo de material que el usuario aprueba se convierte en una lista de compras inteligente. La app no solo anota la cantidad de mayólicas o pintura, sino que te sugiere los materiales secundarios (pegamento, fragua, rodillos, cinta de pintor). Esta lista se puede exportar en PDF o enviar por WhatsApp directamente al vendedor de la ferretería.

---

## 💻 Stack Tecnológico Integrado

Para lograr esta experiencia fluida y rápida, **Hogar360** utiliza una arquitectura moderna:

* **Frontend (Móvil):** Desarrollado en **Flutter** para garantizar una experiencia rápida, interactiva (con visualizaciones 2D de los espacios) y disponible tanto para iOS como para Android.
* **Backend (API REST):** Un motor lógico que recibe las dimensiones, procesa las fórmulas de construcción y devuelve los resultados exactos para no sobrecargar el teléfono del usuario.
* **Base de Datos (MongoDB):** Utiliza una estructura **NoSQL** flexible. Esto es clave porque permite guardar la casa entera de un usuario (con todas sus habitaciones, muebles de distintos tamaños y proyectos de pintura) en un solo documento JSON dinámico, haciendo que la app cargue la información de manera inmediata.
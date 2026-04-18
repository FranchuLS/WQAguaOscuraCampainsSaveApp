# WQ Aguaoscura Campaigns Save App

Aplicación hecha en Flutter para gestionar campañas simultáneas de **Warhammer Quest: Aguaoscura**. Pensada para grupos que juegan varias campañas en paralelo y necesitan guardar el progreso de cada una por separado.

---

## Estado actual del proyecto

> ⚠️ **Versión en desarrollo**
>
> Actualmente solo está implementado el **Acto 1** de la campaña.
> Los actos 2 y 3 se añadirán en futuras versiones.

---

## ¿Qué hace la app?

* Crear varias campañas independientes.
* Guardar héroes y su progreso.
* Gestionar heridas y estados.
* Registrar equipo, habilidades y recompensas.
* Generar y seguir los niveles del acto actual.
* Marcar niveles como superados o descartados.
* Avanzar de acto cuando se complete el jefe final.
* Mantener varias mesas de juego activas al mismo tiempo.

---

## Cómo se usa

### 1. Crear una campaña

Desde la pantalla principal pulsa **Nueva** y escribe el nombre de la campaña.

### 2. Héroes automáticos

Al crear una campaña se añaden automáticamente los héroes disponibles actualmente:

* Bren Tylis
* Drolf Cabezahierro
* Edmark Valoran
* Inara Sion

### 3. Gestionar héroes

En la pantalla de detalle de campaña puedes:

* Ver todos los héroes
* Editar heridas
* Cambiar estado (OK / Vulnerable)
* Añadir recompensas
* Añadir equipo
* Añadir habilidades
* Añadir estados persistentes

### 4. Jugar niveles

Usa **Ver siguientes niveles** para ver los escenarios actuales del acto.

* Se muestran 2 niveles por ronda.
* Eliges uno.
* El otro se descarta automáticamente.
* Tras completar las rondas aparece el jefe final.

### 5. Consultar historial

Puedes revisar:

* Niveles superados
* Niveles descartados
* Todos los niveles generados

---

## Importante: esto NO sustituye al juego

Esta aplicación **no incluye reglas, cartas, tablero, miniaturas, enemigos ni contenido jugable oficial**.

Solo sirve como herramienta para guardar y gestionar el progreso de una campaña.

👉 Para jugar necesitas el juego físico original **Warhammer Quest: Aguaoscura**.

---

## Organización del proyecto

```text
lib/
├── models/        # Modelos de datos (campañas, héroes, niveles)
├── services/      # Hive, carga de JSON, lógica de negocio
├── screens/       # Pantallas principales
├── widgets/       # Componentes reutilizables UI
└── main.dart      # Entrada principal de la app

assets/
├── images/        # Fondos, iconos, retratos
└── templates/     # JSON de héroes y niveles por acto
```

---

## Tecnologías usadas

* Flutter
* Dart
* Hive
* Material Design

---

## Futuras mejoras

* Acto 2
* Acto 3
* Más héroes jugables
* Exportar / importar campañas
* Copias de seguridad
* Mejoras visuales y animaciones
* Web y móvil optimizado

---

## Licencia

Proyecto fan-made sin afiliación oficial con Games Workshop.

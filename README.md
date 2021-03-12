#  Ninja Dash

------------
### ¿Que es?

Ninja dash es una propuesta de solucion creada por alumnos del Tecnologico de Monterrey Campus Puebla al reto planteado por Intel en su programa FPGA University Program, el cual consiste en el prototipaje de un **Soft-Processor** denomido GUMNUT en un FPGA capaz de leer el valor de un acelerometro(ADXL345) y controlar el movieminerto de un objeto movil de un videojuego que se encuentre corriendo en el ordenador .

------------

> Nota: Para este reto se utilizo una tarjeta de desarrollo de FPGAs DE10-Lite basado en un FPGA de la familia Max de Intel la cual requiere comunicarse el ordenador vía comunicación serial.

------------

### Herramientas
- **Processing** *(Desarrollo del videojuego)*
- **Arduino-Processing** *(Tratamiento de los datos recibidos mediante la comucion serial antes de ser enviados a Proccesing)*
- **VHDL** *(Desarrolo de los perifericos de entrada y salida)*
- **Assambler** (GSM) *(Desarrollo de la comunicacion enter los perifericos y el GUMNUT)*

------------

### Contenido
El repositorio cuenta con 3 carpetas 

- **VHDL**
- **Processing**
- **Assambler**
- **Arduino-Processing**

Cada carperta Incluye los codigos necesarios para la creacion de los diferentes elementos que conforman a  Ninja Dash

### Instrucciones

###### ****Si no cuntas con conocimiento previo en este tipo de proyectos favor de hacerle caso a las siguientes instruciones para poder ejecutar el programa de forma correcta****
> Nota: Recuerda que este reto fue solucionado con la placa DE10-Lite proporcionada por  Intel por lo que para pode correr la prueba de esta solucion debes de contar con una igual y ademas compilar todos los archivos dentro de Quartus 18.1 version Lite *(IDE de desarrollo de FPGA´s de Intel)*
Ademas para poder correr el videojuego debes de contar el IDE  de Processing
###### ****No Hacerle Modificaiones A Ningun Archivo****

1.  Descarga y guarda **TODOS** los archivos ubicados en la ruta: *** VHDL/Ninja Dash*** en una misma carpeta.

2. Crear un nuevo Proyecto en Quartus seleccionando el dispositovo MAX 10 M1050DAF484C7G.

3. Agregar al proyecto que acabas de crear **Todos** los archivos que descargaste en el paso 1.

4. Compila el programa y espera a que finalize.

5. Decarga y guarda **TODOS**  los archivos ubicados en la ruta: *** Processing***  en una misma carpeta con el nombre "Final_Game".

6. Abre la carpeta y ejecuta el archivo con nombre: **Final_Game.pde**.

7. Carga el programa compilado en el paso 4 a la tarjeta de desarrollo y comienza a jugar.

------------
### Juego

Ninja Dash es el tipico juego de carrera de obstaculos en la cual el personaje puede realizar diferentes acciones para evitar estos obstaculos y conseguir asi llegar al diamante morado para poder dar fin al juego.
Al igual que otros juegos el persnaje cuenta con 3 vidas las cuales seran restadas al chocar con un  obstaculo.
De igual forma el personaje puede obtener puntos extras por recolectar monedas.

##### Como Jugar
Debes de tener en cuenta que la placa de desarrollo es nuestro control por lo que hacer los suiguientes movimientos involucra una accion realizada por el personaje dentro del videojuego.

- Saltar: *mover la placa hacia arriba en el eje z*
- Agacharse: *mover la placa hacia abajo en el eje z*
- Atacar: *mover placa sobre el eje y*

<p align="center">
<img src="https://user-images.githubusercontent.com/70683976/110894391-6df2f180-82bd-11eb-946a-28e8dad197e7.jpg" width="300">
</p>

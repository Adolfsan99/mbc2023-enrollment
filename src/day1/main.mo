/* IMPORTACIONES, es necesario importar Float para poder usar sus caracteristicas en produccion */
import Float "mo:base/Float";


/* ACTOR, un actor es una especie de CLASE que permite el intercambio de informacion, puede recibir asi como enviar */


//Creando la clase actor de la calculadora
actor class Calculator() {


  /* STABLE, las variables estables son aquellas que se guardan en memoria, evitando asi comportamientos indeseados, como por ejemplo, que se pierda la informacion contenida en estas variables debido a un corto*/
  stable var counter : Float = 0;


  /* ADD = add(PARAMETRO) */
  /* crea un metodo add, este metodo add utiliza el parametro Float, para poder hacer uso de este parametro se inicializa con dos puntos (:) paraser usada mas tarde por la variable stable counter, es una funcion asincronica */
  public shared func add(x : Float) : async Float {
    /*La funcion asincronica (async) Al utilizar "async", la función devuelve una promesa, que es un objeto que representa el resultado futuro de una operación asíncrona, esta funcion es muy utilizada al hacer peticiones mediante internetya que ayuda a que el programa no sufra de interrupciones o sea inestable */
    counter += x; 
    /* La linea de arriba indica que sumaremos la variable X en counter, como este es un metodo, para utilizarlo deberiamos insertar un numero Float donde va la X. Es decir, algo como esto add(5.0) */
    /* de esta forma, teniendo en cuenta que las funciones deben retornar valores, retornaremos el valor de la variable contador */
    return counter; /* conter = 5.0;*/
    /* Al consultar la variable coynter, deberiamos observar que esta variable 
    guarda el el parametro Float del numero X */
  }; 
  /* No olvides cerrar la funcion con punto y coma (;) */


  // SUBSTRACTION = sub(PARAMETRO)
  // Hacemos exactamente lo mismo pero para restar
  public shared func sub(x : Float) : async Float {
    counter -= x;
    return counter; //Tener en cuenta que afectamos la variable counter usando OPERADORES
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // MULTIPLICATION = mul(PARAMETRO)
  // Multiplicar
  public shared func mul(x : Float) : async Float {
    counter := counter * x; //Tener en cuenta que afectamos la variable counter usando OPERADORES
    return counter;
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // DIVISION = div(PARAMETRO)
  // Dividir, etc
  public shared func div(x : Float) : async Float {
    /* CONDICION IF, if x == 0, significa, Si x es estrictamente igual a 0 */
    if (x == 0) {
      return 0.0; //Entonces, retornaremos un 0.0
      //Los numeros Float siempre deben iniciarse con su respectivo decimal */
    };
    counter /= x; //Tener en cuenta que afectamos la variable counter usando OPERADORES */
    return counter;
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // RESET = reset()
  public shared func reset() : async Float {
    //En este caso, asignamos 0.0 a counter, debemos asignar de esta manera en MOTOKO
    // Usando (:=) podremos asignar valores, si counter era 5.0, ahora será 0.0 */
    counter := 0.0; 
    return counter; 
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // POWER = power(PARAMETRO)
  public shared func power(x : Float) : async Float {
    //Utilizamos el metodo .pow de la importacion de Float para poder realizar una operacion de Potencia */
    counter := Float.pow(counter, x); 
    return counter;
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // RESULT = see()
  // QUERY, su propósito es obtener resultados específicos o realizar operaciones relacionadas con la obtención o manipulación de datos en una BASE DE DATOS. */
  public shared query func see() : async Float {
    return counter;
  };
  /* No olvides cerrar la funcion con punto y coma (;) */


  // SQUARE = sqrt()
  public shared func sqrt() : async Float {
    //Utilizamos el metodo .SQRT de la importacion de Float para poder realizar una operacion de Raiz cuadrada */
    return Float.sqrt(counter);
  };
  /* No olvides cerrar la funcion con punto y coma (;) */
  

  // FLOOR = floor()
  // Esta funcion debe devolver un dato Int
  public shared func floor() : async Int { 
  /* Por lo tal, creamos un counter diferente, ya que el counter 
  inicial es de tipo Float*/
  var counterInt : Int = Float.toInt(Float.floor(counter)); 
  /* Convertiremos el Float a Int y despues utilizaremos floor */
    counter := Float.fromInt(counterInt);
    return counterInt;
  };


};
  /* No olvides cerrar el actor con punto y coma (;) */
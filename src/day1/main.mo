import Float "mo:base/Float";

actor Main {
  stable var counter : Float = 0;

  // Suma
  public shared func add(x : Float) : async Float {
    counter += x;
    return counter;
  };

  // Resta
  public shared func sub(x : Float) : async Float {
    counter -= x;
    return counter;
  };

  // Multiplicacion
  public shared func mul(x : Float) : async Float {
    counter := counter * x;
    return counter;
  };

  // Division
  public shared func div(x : Float) : async ?Float {
    if (x == 0) {
      return null;
    };
    counter /= x;
    return ?counter;
  };

  // Resetear
  public shared func reset() : async Float {
    counter := 0.0;
    return counter;
  };

  // Potencia
  public shared func power(x : Float) : async Float {
    counter := Float.pow(counter, x);
    return counter;
  };

  // Resultado
  public shared query func see() : async Float {
    return counter;
  };

  // Raiz
  public shared func sqrt() : async Float {
    counter := Float.sqrt(counter);
    return counter;
  };

  // Redondear
  public shared func floor() : async Int {
  var counterInt : Int = Float.toInt(Float.floor(counter));
    counter := Float.fromInt(counterInt);
    return counterInt;
  };

};
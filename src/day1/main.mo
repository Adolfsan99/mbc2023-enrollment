import Float "mo:base/Float";

actor class Calculator() {
var counter : Float = 0;

//ADD
public shared func add(x : Float) : async Float {
    counter += x; return counter;
};

//SUBSTRACT
public shared func sub(x : Float) : async Float {
    counter -= x; return counter; 
};

//MULTIPLICATION
public shared func mul(x : Float) : async Float {
    counter := counter * x; return counter;
};

//DIVISION
public shared func div(x : Float) : async Float {
    if (x == 0) {return 0.0;};
    counter /= x; return counter;
};

//RESET
public shared func reset() : async Float {
    counter := 0.0; return counter;
};

//SQUARE
public shared func sqrt() : async Float { 
    return Float.sqrt(counter);
};

//POWER
public shared func power(x : Float) : async Float { 
    counter := Float.pow(counter, x); 
    return counter; 
};

//FLOOR
public shared func floor() : async Int {
    var counterInt : Int = Float.toInt(Float.floor(counter));
    counter := Float.fromInt(counterInt);
    return counterInt;
};

//SEE Results
public shared query func see() : async Float { return counter; };

};

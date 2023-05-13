//  IMPORTS
    import Float "mo:base/Float";

//  CALCULATOR
    actor class Calculator() {

//  Create the counter
    var counter : Float = 0;

//  METHODS

//  ADD Operation
    public shared func add(param : Float) : async Float {
        counter += param;
        return counter;
        };

//  SUBSTRACT Operation
    public shared func sub(param : Float) : async Float {
        counter -= param;
        return counter;
        };

//  MULTIPLICATION Operation
    public shared func mul(param : Float) : async Float {
        counter := counter * param;
        return counter;
        };

//  DIVISION Operation
    public shared func div(param : Float) : async Float {
        if (param == 0) { return 0.0 };
        counter /= param;
        return counter;
        };

//  RESET Operation
    public shared func reset() : async Float {
        counter := 0.0;
        return counter;
        };

//  SQUARE Operation
    public shared func sqrt() : async Float {
        return Float.sqrt(counter);
        };

//  POWER Operation
    public shared func power(param : Float) : async Float {
        counter := Float.pow(counter, param);
        return counter;
        };

//  FLOOR Operation
    public shared func floor() : async Int {
        //Here use the Floor method of Float and convert it and return a Int
        var counterInt : Int = Float.toInt(Float.floor(counter));
        counter := Float.fromInt(counterInt);
        return counterInt;
        };

//  SEE Results
    public shared query func see() : async Float { return counter };

};

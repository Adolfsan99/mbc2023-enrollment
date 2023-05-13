import Float "mo:base/Float";

actor class Calculator() {
    var counter : Float = 0;

    //ADD
    public shared func add(param : Float) : async Float {
        counter += param;
        return counter;
    };

    //SUBSTRACT
    public shared func sub(param : Float) : async Float {
        counter -= param;
        return counter;
    };

    //MULTIPLICATION
    public shared func mul(param : Float) : async Float {
        counter := counter * param;
        return counter;
    };

    //DIVISION
    public shared func div(param : Float) : async Float {
        if (param == 0) { return 0.0 };
        counter /= param;
        return counter;
    };

    //RESET
    public shared func reset() : async Float {
        counter := 0.0;
        return counter;
    };

    //SQUARE
    public shared func sqrt() : async Float {
        return Float.sqrt(counter);
    };

    //POWER
    public shared func power(param : Float) : async Float {
        counter := Float.pow(counter, param);
        return counter;
    };

    //FLOOR
    public shared func floor() : async Int {

        //Here use the Floor method of Float and convert it and return a Int
        var counterInt : Int = Float.toInt(Float.floor(counter));
        counter := Float.fromInt(counterInt);
        return counterInt;
    };

    //SEE Results
    public shared query func see() : async Float { return counter };

};

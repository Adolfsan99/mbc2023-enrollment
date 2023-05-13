//  IMPORTS
    import HashMap "mo:base/HashMap";
    import Principal "mo:base/Principal";
    import Hash "mo:base/Hash";
    import Error "mo:base/Error";
    import Result "mo:base/Result";
    import Array "mo:base/Array";
    import Text "mo:base/Text";
    import Nat "mo:base/Nat";
    import Int "mo:base/Int";
    import Timer "mo:base/Timer";
    import Buffer "mo:base/Buffer";
    import Type "Types";
    import Ic "Ic";
    import Iter "mo:base/Iter";

//  VERIFIER
    actor class Verifier() {
    type StudentProfile = Type.StudentProfile;

//  CREATE The stable studentBook
    stable var entries : [(Principal, StudentProfile)] = [];
    let iter = entries.vals();
    let studentBook : HashMap.HashMap<Principal, StudentProfile> = HashMap.fromIter<Principal, StudentProfile>(iter, 10, Principal.equal, Principal.hash);
    system func preupgrade() {
    entries := Iter.toArray(studentBook.entries());
    };
    system func postupgrade() {
    entries := [];
    };

//  METHODS

//  REGISTER A student in the book
    private func registered(p : Principal) : Bool {
        var profileNull : ?StudentProfile = studentBook.get(p);
        switch (profileNull) {
        case null {
        return false;
        };
        case (?profile) {
        return true;
        };
        };
        };

//  ADD My profile in the student book
    public shared ({ caller }) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        if (Principal.isAnonymous(caller)) {
        return #err "You add the account!";
        };
        if (registered(caller)) {
        return #err("You are already registered!");
        };
        studentBook.put(caller, profile);
        return #ok();
        };

//  SEE A profile in the student book
    public shared query ({ caller }) func seeAProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
        var profileNull : ?StudentProfile = studentBook.get(p);
        switch (profileNull) {
        case null {
        return #err("There is no profile is dont registered!");
        };
        case (?profile) {
        return #ok profile;
        };
        };
        };

//  UPDATE My profile in the student book
    public shared ({ caller }) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        if (Principal.isAnonymous(caller)) {
        return #err "You update the profile";
        };
        if (not registered(caller)) {
        return #err("You are not registered");
        };
        ignore studentBook.replace(caller, profile);
        return #ok();
        };

//  DELETE My profile in the student book
    public shared ({ caller }) func deleteMyProfile() : async Result.Result<(), Text> {
        if (Principal.isAnonymous(caller)) {
        return #err "You delete the profile";
        };
        if (not registered(caller)) {
        return #err("You are not registered");
        };
        studentBook.delete(caller);
        return #ok();
        };

//  INITIALIZE The tests
    public type TestResult = Type.TestResult;
    public type TestError = Type.TestError;

//  TEST The calculator function
    public func test(canisterId : Principal) : async TestResult {
        let calculatorInterface = actor (Principal.toText(canisterId)) : actor {
        reset : shared () -> async Int;
        add : shared (x : Nat) -> async Int;
        sub : shared (x : Nat) -> async Int;
        };
        try {
        let x1 : Int = await calculatorInterface.reset();
        if (x1 != 0) {
        return #err(#UnexpectedValue("The counter should be 0!"));
        };
        let x2 : Int = await calculatorInterface.add(2);
        if (x2 != 2) {
        return #err(#UnexpectedValue("The counter should be 2!"));
        };
        let x3 : Int = await calculatorInterface.sub(2);
        if (x3 != 0) {
        return #err(#UnexpectedValue("The counter should be 0!"));
        };
        return #ok();
        } catch (e) { return #err(#UnexpectedError("OPS, error 404?")) };
        };

//  VERIFY That verify the Owner of the calculator
        public func verifyOwnership(canisterId : Principal, p : Principal) : async Bool {
        try {
            
//  IC principal = aaaaa-aa
        let controllers = await Ic.getCanisterControllers(canisterId);
        var owner : ?Principal = Array.find<Principal>(controllers, func prin = prin == p);
        if (owner != null) { return true };
        return false;
        } catch (e) { return false };
        };

//  VERIFING The Work of the studend
    public shared ({ caller }) func verifyWork(canisterId : Principal, p : Principal) : async Result.Result<(), Text> {
        try {
        let approved = await test(canisterId);
        if (approved != #ok) {
        return #err("The work has no passed the tests, you fail :P");
        };
        let owner = await verifyOwnership(canisterId, p);
        if (not owner) {
        return #err("The work owner do not correspond the principal");
        };
        var profileNull : ?StudentProfile = studentBook.get(p);
        switch (profileNull) {
        case null {
        return #err("The principal do not correspond to a registered student");
        };
        case (?profile) {
        var updatedStudent = {
        name = profile.name;
        team = profile.team;
        graduate = true;
        };
        ignore studentBook.replace(p, updatedStudent);
        return #ok();
        };
        };
        } catch (e) {
        return #err("Cannot verify the work");
        };
        };
};

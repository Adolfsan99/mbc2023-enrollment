//  IMPORTS
    import Type "Types";
    import Buffer "mo:base/Buffer";
    import Result "mo:base/Result";
    import Array "mo:base/Array";
    import Iter "mo:base/Iter";
    import HashMap "mo:base/HashMap";
    import Nat "mo:base/Nat";
    import Nat32 "mo:base/Nat32";
    import Text "mo:base/Text";
    import Hash "mo:base/Hash";
    import Principal "mo:base/Principal";

//  STUDENT WALL
    actor class StudentWall() {

//  Use the neccesary types
    type Message = Type.Message;
    type Content = Type.Content;

//  Keep stable the message count
    stable var messageIdCount : Nat = 0;

//  Create the hash (really its very confused this step)
    private func _hashNat(num : Nat) : Hash.Hash = return Text.hash(Nat.toText(num));
    let wall = HashMap.HashMap<Nat, Message>(0, Nat.equal, _hashNat);

//  Add Message in the wall
    public shared ({ caller }) func writeMessage(c : Content) : async Nat {

//  Id for each message logic
    let id : Nat = messageIdCount;
    messageIdCount += 1;

//  Create Variable to new message
    var newMessage : Message = {
    content = c;
    creator = caller;
    vote = 0;
    };

//  Put data into wall
    wall.put(id, newMessage);
    return id;
    };

//  GET Specific message by ID
    public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {
        let messageData : ?Message = wall.get(messageId);
        switch (messageData) {
        case (null) {
        return #err "The requested message does not exist.";
        };
        case (?message) {
        return #ok message;
        };
        };
        };

//  METHODS

//  UPDATE The content for a specific message by ID
    public shared ({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
        var isAuth : Bool = not Principal.isAnonymous(caller);
        if (not isAuth) {
        return #err "You must be authenticated to validate that you are the creator of the message!";
        };
        let messageData : ?Message = wall.get(messageId);
        switch (messageData) {
        case (null) {
        return #err "The requested message does not exist.";
        };
        case (?message) {
        if (message.creator != caller) {
        return #err "You are not the creator of this message!";
        };
        let updatedMessage : Message = {
        creator = message.creator;
        content = c;
        vote = message.vote;
        };
        wall.put(messageId, updatedMessage);
        return #ok();
        };
        };
        };

//  DELETE Specific message by ID
        public shared ({ caller }) func deleteMessage(messageId : Nat) : async Result.Result<(), Text> {
        let messageData : ?Message = wall.get(messageId);
        switch (messageData) {
        case (null) {
        return #err "The requested message does not exist.";
        };
        case (?message) {
        if (message.creator != caller) {
        return #err "You are not the creator of this message!";
        };
        ignore wall.remove(messageId);
        return #ok();
        };
        };
        return #ok();
        };

//  UP VOTE
    public func upVote(messageId : Nat) : async Result.Result<(), Text> {
        let messageData : ?Message = wall.get(messageId);
        switch (messageData) {
        case (null) {
        return #err "The requested message does not exist.";
        };
        case (?message) {
        let updatedMessage : Message = {
        creator = message.creator;
        content = message.content;
        vote = message.vote + 1;
        };
        wall.put(messageId, updatedMessage);
        return #ok();
        };
        };
        return #ok();
        };

//  DOWN VOTE
    public func downVote(messageId : Nat) : async Result.Result<(), Text> {
        let messageData : ?Message = wall.get(messageId);
        switch (messageData) {
        case (null) {
        return #err "The requested message does not exist.";
        };
        case (?message) {
        let updatedMessage : Message = {
        creator = message.creator;
        content = message.content;
        vote = message.vote - 1;
        };
        wall.put(messageId, updatedMessage);
        return #ok();
        };
        };
        return #ok();
        };

//  GET All messages
    public func getAllMessages() : async [Message] {
        let messagesBuff = Buffer.Buffer<Message>(0);
        for (msg in wall.vals()) {
        messagesBuff.add(msg);
        };
        return Buffer.toArray<Message>(messagesBuff);
        };

//  GET All messages ordered by votes (i need help for implement this)
    public func getAllMessagesRanked() : async [Message] {
        let messagesBuff = Buffer.Buffer<Message>(0);
        for (msg in wall.vals()) {
        messagesBuff.add(msg);
        };
        var messages = Buffer.toVarArray<Message>(messagesBuff);

//  Reverse buble sort
        var size = messages.size();

//  Substract 1 To size, because the arrays always be starts in 0
        if (size > 0) {
        size -= 1;
        };

//  Simple Vote rating
        for (a in Iter.range(0, size)) {
        var maxIndex = a;
        for (b in Iter.range(a, size)) {
        if (messages[b].vote > messages[a].vote) {
        maxIndex := b;
        };
        };
        let temporal = messages[maxIndex];
        messages[maxIndex] := messages[a];
        messages[a] := temporal;
        };
        return Array.freeze<Message>(messages);
        };

};

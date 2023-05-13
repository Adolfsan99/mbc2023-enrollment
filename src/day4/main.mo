import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";

// IMPORTS Account and RemoteCanister Actors
import Account "Account";
import RemoteCanisterActor "RemoteCanisterActor";

actor class MotoCoin() {
  public type Account = Account.Account;

  /*  NOTE: In this case use the next variables to have control of the accounts
   *  account, accountUser, accountNull
   *  accountBalanceNull, accountNullBalanceTarget
   *  accountNullTarget, accountNullBalanceTarget
  */

  //CREATE the MotoCoin object and his values
  stable var coinData = {
    name : Text = "MotoCoin";
    symbol : Text = "MOC";
    var supply : Nat = 0;
  };

  var ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

  // RETURN The name of the MotoCoin
  public query func name() : async Text {
    return coinData.name;
  };

  // RETURN The symbol of the MotoCoin
  public query func symbol() : async Text {
    return coinData.symbol;
  };

  // RETURN The the total number of MotoCoins on all accounts
  public func totalSupply() : async Nat {
    return coinData.supply;
  };

  // RETURN The balanceOf of the account
  public query func balanceOf(account : Account) : async (Nat) {
    let accountUser : ?Nat = ledger.get(account);

    switch (accountUser) {
      case(null) { return 0 };
      case(?account) {
        return account;
      };
    };
  };

  // TRANSFER MotoCoin to another account
  public shared ({ caller }) func transfer( from : Account, to : Account, amount : Nat ) : async Result.Result<(), Text> {
    let accountNull : ?Nat = ledger.get(from);

    switch (accountNull) {
      case(null) { 
        return #err ("Your " # coinData.name # " balance is not enough!"); 
      };

      case(?accountBalanceNull) {
        if (accountBalanceNull < amount) {
          return #err ("Your " # coinData.name # " balance is not enough!"); 
        };

        // UPDATE Sender account balance
        ignore ledger.replace(from, accountBalanceNull - amount);

        // UPDATE Receiver account balance
        let accountNullTarget : ?Nat = ledger.get(to);
        switch (accountNullTarget) {
          case(null) {
            ledger.put(to, amount);
            return #ok ()
          };

          case(?accountNullBalanceTarget) {
            ignore ledger.replace(to, accountNullBalanceTarget + amount);
            return #ok ()
          }
        };
      };
    };
  };

  // HELPER Verify function to add coins to a wallet
  private func addBalance(wallet : Account, amount : Nat) : async () {
    let accountNull : ?Nat = ledger.get(wallet);

    switch (accountNull) {
      case(null) { 
        ledger.put(wallet, amount);
        
        return ();
      };

      case(?accountBalanceNull) {
        ignore ledger.replace(wallet, accountBalanceNull + amount);

        return ();
      };
    }
  };

  // AIRDROP 100 MotoCoins to any student that is part of the Bootcamp.
  public func airdrop() : async Result.Result<(), Text> {
    try {
      var students : [Principal] = await RemoteCanisterActor.RemoteActor.getAllStudentsPrincipal();

      for (student in students.vals()) {
        var studentAccount = {owner = student; subaccount = null};
        await addBalance(studentAccount, 100);
        coinData.supply += 100;
      };

      return #ok ();
    } catch (e) {
      return #err "Something went wrong!";
    };
  };
};
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    let owner : Principal = Principal.fromText("qfja5-lmyow-45eqq-ocokv-uuvwt-hlnxe-qbiq7-oidhk-3lb6l-pda7l-xqe");
    let totalSupply : Nat = 1_000_000_000;
    let symbol : Text = "GAX";
    private stable var balanceEntries : [(Principal, Nat)] = [];
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    public query func balanceOf(who : Principal) : async Nat {
        let balance = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };
        return balance;
    };
    public query func getSymbol() : async Text {
        return symbol;
    };
    public shared (msg) func payOut() : async Text {
        Debug.print(debug_show (msg.caller));
        if (balances.get(msg.caller) == null) {
            let amount = 10_000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already claimed!";
        };
    };
    public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance > amount) {
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);
            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);
            return "Success";
        } else {
            return "Insufficient Funds";
        };

    };
    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };
    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        };
    };

};

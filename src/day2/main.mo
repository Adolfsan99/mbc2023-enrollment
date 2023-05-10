import Text "mo:base/Text";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

// HOMEWORK DATA
actor HomeworkDiary {
  public type Homework = {
    title : Text;
    description : Text;
    dueDate : Time.Time;
    completed : Bool;
  };

  // HOMEWORK BUFFER
  let homeworkDiary = Buffer.Buffer<Homework>(0);

  // ADD
  public shared func addHomework(hw : Homework) : async Nat {
    homeworkDiary.add(hw);
    return (homeworkDiary.size() - 1);
  };

  // GET BY ID
  public shared func getHomework(hwId : Nat) : async Result.Result<Homework, Text> {
    if (homeworkDiary.size() <= hwId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    let hw = homeworkDiary.get(hwId);
    return #ok hw;
  };

  // UPDATE/EDIT BY ID
  public shared func updateHomework(hwId : Nat, newHw : Homework) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= hwId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    homeworkDiary.put(hwId, newHw);
    return #ok();
  };

  // MARK AS COMPLETED BY ID
  public shared func markAsCompleted(hwId : Nat) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= hwId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    var hw : Homework = homeworkDiary.get(hwId);
    var completedHw : Homework = {
      title = hw.title;
      description = hw.description;
      dueDate = hw.dueDate;
      completed = true;
    };
    homeworkDiary.put(hwId, completedHw);
    return #ok();
  };

  // DELETE BY ID
  public shared func deleteHomework(hwId : Nat) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= hwId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    let x = homeworkDiary.remove(hwId);
    return #ok();
  };

  // GET ALL
  public shared func getAllHomework() : async [Homework] {
    return Buffer.toArray<Homework>(homeworkDiary);
  };

  // GET ONLY PENDING HOMEWORKS
  public shared func getPendingHomework() : async [Homework] {
    var pending = Buffer.clone(homeworkDiary);
    pending.filterEntries(func(_, hw) = hw.completed == false);
    return Buffer.toArray<Homework>(pending);
  };

  // SEARCH BY TEXT
  public shared func searchHomework(searchTerm : Text) : async [Homework] {
    var search = Buffer.clone(homeworkDiary);
    search.filterEntries(func(_, hw) = Text.contains(hw.title, #text searchTerm) or Text.contains(hw.description, #text searchTerm));
    return Buffer.toArray<Homework>(search);
  };
};

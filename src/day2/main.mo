//import Types "Types";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

actor class HomeworkTasks() {

  // OBJECT for Homework
  public type Time = Time.Time;
  public type Homework = {
    title : Text;
    description : Text;
    dueDate : Time;
    completed : Bool;
  };

  // CREATE the list of homework tasks
  let homeworkDiary = Buffer.Buffer<Homework>(9);

  // ADD a new homework task
  public shared func addHomework(homework : Homework) : async Nat {
    let id = homeworkDiary.size();
    homeworkDiary.add(homework);
    return id;
  };

  // MARK homework task as complete by id
  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    if (id < homeworkDiary.size() and id >= 0) {
      var homeworkSelected = {
        description = homeworkDiary.get(id).description;
        title = homeworkDiary.get(id).title;
        completed = true;
        dueDate = homeworkDiary.get(id).dueDate;
      };
      homeworkDiary.put(id, homeworkSelected);
      return #ok();
    } else {
      return #ok();
    };
  };

  // DELETE homework task by id
  public shared func deleteHomework(id : Nat) : async Bool {
    if (id >= 0 and id < homeworkDiary.size()) {
      let delete = homeworkDiary.remove(id);
      return true;
    } else {
      return false;
    };
  };

  // GET homework task by id
  public shared func getHomework(id : Nat) : async ?Homework {
    if (id >= 0 and id < homeworkDiary.size()) {
      let homework = homeworkDiary.get(id);
      return ?homework;
    } else {
      return null;
    };
  };

  // UPDATE or edit the homework task
  public shared func updateHomework(hwId : Nat, newHw : Homework) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= hwId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    homeworkDiary.put(hwId, newHw);
    return #ok();
  };

  // GET All homeworks tasks
  public shared func getAllHomework() : async [Homework] {
    return Buffer.toArray<Homework>(homeworkDiary);
  };

  // GET Only not completed homeworks
  public shared func getPendingHomework() : async [Homework] {
    var pending = Buffer.clone(homeworkDiary);
    pending.filterEntries(func(_, hw) = hw.completed == false);
    return Buffer.toArray<Homework>(pending);
  };

  // SEARCH For homeworks tasks based on terms
  public shared func searchHomework(searchTerm : Text) : async [Homework] {
    var search = Buffer.clone(homeworkDiary);
    search.filterEntries(func(_, hw) = Text.contains(hw.title, #text searchTerm) or Text.contains(hw.description, #text searchTerm));
    return Buffer.toArray<Homework>(search);
  };

};

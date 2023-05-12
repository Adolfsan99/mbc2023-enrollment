import Text "mo:base/Text";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

actor class Homework() {
  public type Homework = {
    title : Text;
    description : Text;
    dueDate : Time.Time;
    completed : Bool;
  };

  // CREATE The homework buffer
  let homeworkDiary = Buffer.Buffer<Homework>(0);

  // ADD a homework
  public shared func addHomework(homeWork : Homework) : async Nat {
    homeworkDiary.add(homeWork);
    return (homeworkDiary.size() - 1); //array.size need be 0
  };

  // UPDATE/EDIT a homework by ID
  public shared func updateHomework(homeWorkId : Nat, newhomeWork : Homework) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= homeWorkId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    homeworkDiary.put(homeWorkId, newhomeWork);
    return #ok();
  };

  // MARK AS COMPLETED a homework by ID
  public shared func markAsCompleted(homeWorkId : Nat) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= homeWorkId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    var homeWork : Homework = homeworkDiary.get(homeWorkId);
    var completedhomeWork : Homework = {
      title = homeWork.title;
      description = homeWork.description;
      dueDate = homeWork.dueDate;
      completed = true;
    };
    homeworkDiary.put(homeWorkId, completedhomeWork);
    return #ok();
  };

  // DELETE a homework by ID
  public shared func deleteHomework(homeWorkId : Nat) : async Result.Result<(), Text> {
    if (homeworkDiary.size() <= homeWorkId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    let x = homeworkDiary.remove(homeWorkId);
    return #ok();
  };

  // GET a homework by ID
  public shared func getHomework(homeWorkId : Nat) : async Result.Result<Homework, Text> {
    if (homeworkDiary.size() <= homeWorkId) {
      return #err "The requested homeworkID is higher then the homeworkDiary size";
    };
    let homeWork = homeworkDiary.get(homeWorkId);
    return #ok homeWork;
  };
  
  // GET ALL homeworks
  public shared func getAllHomework() : async [Homework] {
    return Buffer.toArray<Homework>(homeworkDiary);
  };

  // GET ONLY PENDING homeworks
  public shared func getPendingHomework() : async [Homework] {
    var pending = Buffer.clone(homeworkDiary);
    pending.filterEntries(func(_, homeWork) = homeWork.completed == false);
    return Buffer.toArray<Homework>(pending);
  };

  // SEARCH Homeworks by TEXT
  public shared func searchHomework(searchTerm : Text) : async [Homework] {
    var search = Buffer.clone(homeworkDiary);
    search.filterEntries(func(_, homeWork) = Text.contains(homeWork.title, #text searchTerm) or Text.contains(homeWork.description, #text searchTerm));
    return Buffer.toArray<Homework>(search);
  };
};

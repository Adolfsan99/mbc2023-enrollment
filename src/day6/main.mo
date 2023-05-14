//  IMPORTS
    import Text "mo:base/Text";
    import Time "mo:base/Time";
    import Buffer "mo:base/Buffer";
    import Debug "mo:base/Debug";
    import Result "mo:base/Result";

//  HOMEWORK
    actor class Homework() {

//  Create the Homework object and his values
	public type Homework = {
		title : Text;
		description : Text;
		dueDate : Time.Time; //In some cases is needed write the import in this formar
		completed : Bool;
		};

    //NOTE: Im using task, taskId, newTask and markedTask for have control of homework

//  Create the homework buffer
    let homeworkDiary = Buffer.Buffer<Homework>(0);

//  METHODS

//  ADD a homework
	public shared func addHomework(task : Homework) : async Nat {
		homeworkDiary.add(task);
        return (homeworkDiary.size() - 1); //array.size need be 0
        };

//  UPDATE/EDIT a homework by ID
		public shared func updateHomework(taskId : Nat, newTask : Homework) : async Result.Result<(), Text> {
        if (homeworkDiary.size() <= taskId) {
        return #err "The requested taskId is higher";
        };
        homeworkDiary.put(taskId, newTask);
        return #ok();
        };

//  MARK AS COMPLETED a homework by ID
		public shared func markAsCompleted(taskId : Nat) : async Result.Result<(), Text> {
        if (homeworkDiary.size() <= taskId) {
        return #err "The requested taskId is higher";
        };
        var task : Homework = homeworkDiary.get(taskId);
        var markedTask : Homework = {
        title = task.title;
        description = task.description;
        dueDate = task.dueDate;
        completed = true;
        };
        homeworkDiary.put(taskId, markedTask);
        return #ok();
        };

//  DELETE a homework by ID
	public shared func deleteHomework(taskId : Nat) : async Result.Result<(), Text> {
        if (homeworkDiary.size() <= taskId) {
        return #err "The requested taskId is higher";
		};
		let x = homeworkDiary.remove(taskId);
		return #ok();
		};

//  GET a homework by ID
	public shared func getHomework(taskId : Nat) : async Result.Result<Homework, Text> {
		if (homeworkDiary.size() <= taskId) {
		return #err "The homework diary is full";
		};
		let task = homeworkDiary.get(taskId);
		return #ok task;
		};

//  GET ALL homeworks
	public shared func getAllHomework() : async [Homework] {
		return Buffer.toArray<Homework>(homeworkDiary);
		};

//  GET ONLY PENDING homeworks
	public shared func getPendingHomework() : async [Homework] {
		var pending = Buffer.clone(homeworkDiary);
		pending.filterEntries(func(_, task) = task.completed == false);
		return Buffer.toArray<Homework>(pending);
		};

//  SEARCH Homeworks by TEXT
	public shared func searchHomework(searchTerm : Text) : async [Homework] {
		var search = Buffer.clone(homeworkDiary);
		search.filterEntries(func(_, task) = Text.contains(task.title, #text searchTerm) or Text.contains(task.description, #text searchTerm));
		return Buffer.toArray<Homework>(search);
		}; 
};
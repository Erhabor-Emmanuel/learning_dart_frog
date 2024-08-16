import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learnfrog_backend/hash_extension.dart';
import 'package:meta/meta.dart';

part 'list_repo.g.dart';

@visibleForTesting
/// Data source - in-memory cache
Map<String, TaskList> listDb = {};

@JsonSerializable()
/// TaskList class
class TaskList extends Equatable{

  /// List's id
  final String id;
  /// List's name
  final String name;

  /// Constructor
  TaskList({required this.id, required this.name});

  /// Deserialization
  /// This is what we use to convert a json object to a TaskList object
  factory TaskList.fromJson(Map<String, dynamic> json) => _$TaskListFromJson(json);

  /// Serialization
  /// When we pass the TakList object to this method it would convert it to a json
  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  /// copyWith method
  TaskList copyWith({
    String? id,
    String? name,
  }) {
    return TaskList(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  // TODO: implement props
  /// The list of properties that will be used to determine whether two instances are equal.
  List<Object?> get props => [id, name];
}

class TaskListRepository {

  /// check in the internal data source for a list with the given id
  Future<TaskList?> listById(String id) async{
    return listDb[id];
  }

  /// Get all the list from the data source
  Map<String, dynamic> getAllList(){
    final formattedLists = <String, dynamic>{};

    if(listDb.isNotEmpty){
      listDb.forEach((String id) {
        final currentList = listDb[id];
        formattedLists[id] = currentList?.toJson();
      } as void Function(String key, TaskList value));
    }
    return formattedLists;
  }

  /// Create a new list with a given [name]
  String createList({required String name}){

    /// dynamically generates the id
    final id = name.hashValue;

    /// create our new TaskList object and pass our two parameters
    final list = TaskList(id: id, name: name);

    /// add a new TaskList object to our data source
    listDb[id] = list;

    return id;
  }

  /// Deletes the TaskList object with the given [id]
  void deleteList(String id){
    listDb.remove(id);
  }

  /// Update operation
  Future<void> updateList({required String id, required String name})async{
    final currentList = listDb[id];

    if(currentList == null){
      return Future.error(Exception('List not found'));
    }

    listDb[id] = TaskList(id: id, name: name);
  }
}
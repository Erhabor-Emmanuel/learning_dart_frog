import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learnfrog_backend/hash_extension.dart';
import 'package:meta/meta.dart';

part 'item_repo.g.dart';

@visibleForTesting
/// Data source - in-memory cache
Map<String, TaskItem> itemDb = {};

@JsonSerializable()
/// TaskList class
class TaskItem extends Equatable{

  /// Constructor
  const TaskItem({
    required this.id,
    required this.listid,
    required this.name,
    required this.description,
    required this.status,
  });

  /// Item's id
  final String id;

  /// List id of where the item belongs
  final String listid;

  /// Item's name
  final String name;

  /// Item's description
  final String description;

  /// Item's status
  final bool status;

  /// Deserialization
  /// This is what we use to convert a json object to a TaskList object
  factory TaskItem.fromJson(Map<String, dynamic> json) => _$TaskItemFromJson(json);

  /// Serialization
  /// When we pass the TakList object to this method it would convert it to a json
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  /// copyWith method
  TaskItem copyWith({
    String? id,
    String? listid,
    String? name,
    String? description,
    bool? status,
  }) {
    return TaskItem(
        id: id ?? this.id,
        listid: listid ?? this.listid,
        name: name ?? this.name,
        description: description ?? this.description,
        status: status ?? this.status
    );
  }

  @override
  // TODO: implement props
  /// The list of properties that will be used to determine whether two instances are equal.
  List<Object?> get props => [id, name];
}

class TaskItemReository {

  /// check in the internal data source for a list with the given id
  Future<TaskItem?> itemById(String id) async{
    return itemDb[id];
  }

  /// Get all the items from the data source
  Map<String, dynamic> getAllItems(){
    final formattedLists = <String, dynamic>{};

    if(itemDb.isNotEmpty){
      itemDb.forEach((String id) {
        final currentList = itemDb[id];
        formattedLists[id] = currentList?.toJson();
      } as void Function(String key, TaskItem value));
    }
    return formattedLists;
  }

  /// Create a new item with a given information
  String createItem({
    required String name,
    required String listid,
    required String description,
    required bool status,
  }){

    /// dynamically generates the id
    final id = name.hashValue;

    /// create our new TaskItem object and pass all the parameters
    final item = TaskItem(
        id: id,
        name: name,
        listid: listid,
        description: description,
        status: status,
    );

    /// add a new TaskItem object to our data source
    itemDb[id] = item;

    return id;
  }

  /// Deletes the TaskItem object with the given [id]
  void deleteItem(String id){
    itemDb.remove(id);
  }

  /// Update operation
  Future<void> updateItem({
    required String id,
    required String listid,
    required String name,
    required String description,
    required bool status,
  })async{
    final currentItem = itemDb[id];

    if(currentItem  == null){
      return Future.error(Exception('Item not found'));
    }

    itemDb[id] = TaskItem(
        id: id,
        listid: listid,
        name: name,
        description: description,
        status: status,
    );
  }
}

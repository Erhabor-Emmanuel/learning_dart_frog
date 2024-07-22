import 'package:dart_frog/dart_frog.dart';
import 'package:learnfrog_backend/items/item_repo.dart';
import 'package:learnfrog_backend/lists/list_repo.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(requestLogger())
  .use(provider<TaskListRepository>((context) => TaskListRepository()))
  .use(provider<TaskItemRepository>((context) => TaskItemRepository()));
}

import '../../../core/utils/result.dart';
import 'domain_models/item_model.dart';
import 'domain_models/item_error.dart';
import 'domain_models/item_type_enum.dart';
import 'domain_models/item_status_enum.dart';
import 'domain_models/item_priority_enum.dart';

/// Service interface for item operations
abstract interface class IItemService {
  /// Get all items for a specific project
  Future<Result<List<ItemModel>, ItemError>> getProjectItems(String projectId);

  /// Get a specific item by ID
  Future<Result<ItemModel, ItemError>> getItemById(String itemId);

  /// Create a new item
  Future<Result<ItemModel, ItemError>> createItem({
    required String projectId,
    required String title,
    String description = '',
    required Map<String, dynamic> content,
    ItemTypeEnum itemType = ItemTypeEnum.tip,
    ItemStatusEnum status = ItemStatusEnum.active,
    ItemPriorityEnum priority = ItemPriorityEnum.low,
    List<String> tags = const [],
  });

  /// Update an existing item
  Future<Result<ItemModel, ItemError>> updateItem({
    required String itemId,
    String? title,
    String? description,
    Map<String, dynamic>? content,
    ItemTypeEnum? itemType,
    ItemStatusEnum? status,
    ItemPriorityEnum? priority,
    List<String>? tags,
  });

  /// Delete an item
  Future<Result<void, ItemError>> deleteItem(String itemId);

  /// Search items within a project
  Future<Result<List<ItemModel>, ItemError>> searchItems({
    required String projectId,
    String? query,
    List<ItemTypeEnum>? types,
    List<ItemStatusEnum>? statuses,
    List<ItemPriorityEnum>? priorities,
    List<String>? tags,
    int limit = 50,
    int offset = 0,
  });

  /// Get items by status
  Future<Result<List<ItemModel>, ItemError>> getItemsByStatus({
    required String projectId,
    required ItemStatusEnum status,
    int limit = 50,
    int offset = 0,
  });

  /// Get items by type
  Future<Result<List<ItemModel>, ItemError>> getItemsByType({
    required String projectId,
    required ItemTypeEnum type,
    int limit = 50,
    int offset = 0,
  });

  /// Get items by priority
  Future<Result<List<ItemModel>, ItemError>> getItemsByPriority({
    required String projectId,
    required ItemPriorityEnum priority,
    int limit = 50,
    int offset = 0,
  });

  /// Get items by tag
  Future<Result<List<ItemModel>, ItemError>> getItemsByTag({
    required String projectId,
    required String tag,
    int limit = 50,
    int offset = 0,
  });

  /// Get recent items (created in the last 7 days)
  Future<Result<List<ItemModel>, ItemError>> getRecentItems({
    required String projectId,
    int limit = 20,
  });

  /// Get popular items (high vote score)
  Future<Result<List<ItemModel>, ItemError>> getPopularItems({
    required String projectId,
    int limit = 20,
  });

  /// Get items created by a specific user
  Future<Result<List<ItemModel>, ItemError>> getItemsByAuthor({
    required String projectId,
    required String authorId,
    int limit = 50,
    int offset = 0,
  });

  /// Update item view count (for analytics)
  Future<Result<void, ItemError>> incrementViewCount(String itemId);

  /// Vote on an item (up/down)
  Future<Result<void, ItemError>> voteOnItem(String itemId, bool isUpvote);

  /// Remove vote from an item
  Future<Result<void, ItemError>> removeVote(String itemId);

  /// Get item statistics for a project
  Future<Result<ItemStatistics, ItemError>> getProjectItemStatistics(String projectId);

  /// Check if current user can perform action on item
  Future<Result<bool, ItemError>> canPerformAction({
    required String itemId,
    required ItemAction action,
  });

  /// Bulk update items (status, priority, tags)
  Future<Result<List<ItemModel>, ItemError>> bulkUpdateItems({
    required List<String> itemIds,
    ItemStatusEnum? status,
    ItemPriorityEnum? priority,
    List<String>? addTags,
    List<String>? removeTags,
  });

  /// Get suggested tags based on item content
  Future<Result<List<String>, ItemError>> getSuggestedTags({
    required String projectId,
    required String content,
    int limit = 10,
  });

  /// Detect potential duplicates
  Future<Result<List<ItemModel>, ItemError>> findPotentialDuplicates({
    required String projectId,
    required String title,
    required String description,
    int limit = 5,
  });
}

/// Item statistics model
class ItemStatistics {
  final int totalItems;
  final int activeItems;
  final int resolvedItems;
  final int archivedItems;
  final Map<ItemTypeEnum, int> itemsByType;
  final Map<ItemPriorityEnum, int> itemsByPriority;
  final int totalViews;
  final double averageVoteScore;

  const ItemStatistics({
    required this.totalItems,
    required this.activeItems,
    required this.resolvedItems,
    required this.archivedItems,
    required this.itemsByType,
    required this.itemsByPriority,
    required this.totalViews,
    required this.averageVoteScore,
  });
}

/// Available actions that can be performed on items
enum ItemAction {
  view,
  create,
  edit,
  delete,
  vote,
  comment,
  changeStatus,
  changePriority,
  manageTags,
}
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/result.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/utils/get_dep.dart';
import '../domain/i_item_service.dart';
import '../domain/domain_models/item_model.dart';
import '../domain/domain_models/item_error.dart';
import '../domain/domain_models/item_type_enum.dart';
import '../domain/domain_models/item_status_enum.dart';
import '../domain/domain_models/item_priority_enum.dart';
import 'dtos/item_dto.dart';

/// Supabase implementation of IItemService
class SupabaseItemService implements IItemService {
  final SupabaseClient _supabase;

  SupabaseItemService({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? getdep<SupabaseClient>();

  static const String _itemsTable = 'items';
  static const String _itemVotesTable = 'knowledge_item_votes';

  @override
  Future<Result<List<ItemModel>, ItemError>> getProjectItems(String projectId) async {
    try {
      AppLogger.info('ITEM_SERVICE: Loading items for project $projectId');

      final response = await _supabase
          .from(_itemsTable)
          .select('*')
          .eq('project_id', projectId)
          .order('created_at', ascending: false);

      final items = (response as List<dynamic>)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toDomain())
          .toList();

      AppLogger.info('ITEM_SERVICE: Successfully loaded ${items.length} items for project $projectId');
      return Result.success(items);
    } on PostgrestException catch (e) {
      AppLogger.error('ITEM_SERVICE: PostgresException loading items for project $projectId', e);
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error loading items for project $projectId', e);
      return const Result.failure( ItemNetworkError('Failed to load items'));
    }
  }

  @override
  Future<Result<ItemModel, ItemError>> getItemById(String itemId) async {
    try {
      AppLogger.info('ITEM_SERVICE: Loading item $itemId');

      final response = await _supabase
          .from(_itemsTable)
          .select('*')
          .eq('id', itemId)
          .single();

      final item = ItemDto.fromJson(response).toDomain();

      AppLogger.info('ITEM_SERVICE: Successfully loaded item $itemId');
      return Result.success(item);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        AppLogger.warning('ITEM_SERVICE: Item $itemId not found');
        return Result.failure(ItemNotFoundError.byId(itemId));
      }
      AppLogger.error('ITEM_SERVICE: PostgresException loading item $itemId', e);
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error loading item $itemId', e);
      return const Result.failure( ItemNetworkError('Failed to load item'));
    }
  }

  @override
  Future<Result<ItemModel, ItemError>> createItem({
    required String projectId,
    required String title,
    String description = '',
    required Map<String, dynamic> content,
    ItemTypeEnum itemType = ItemTypeEnum.tip,
    ItemStatusEnum status = ItemStatusEnum.active,
    ItemPriorityEnum priority = ItemPriorityEnum.low,
    List<String> tags = const [],
  }) async {
    try {
      // Validation
      if (title.trim().isEmpty) {
        return Result.failure(ItemValidationError.emptyTitle());
      }
      if (content.isEmpty) {
        return Result.failure(ItemValidationError.emptyContent());
      }
      if (tags.length > 10) {
        return Result.failure(ItemValidationError.tooManyTags());
      }
      for (final tag in tags) {
        if (tag.length > 50) {
          return Result.failure(ItemValidationError.tagTooLong(tag));
        }
      }

      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return const Result.failure( ItemPermissionError('User not authenticated'));
      }

      AppLogger.info('ITEM_SERVICE: Creating item "$title" in project $projectId');

      final dto = ItemDto(
        projectId: projectId,
        title: title.trim(),
        description: description.trim(),
        content: content,
        itemType: itemType.value,
        status: status.value,
        priority: priority.value,
        tags: tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList(),
        authorId: currentUser.id,
      );

      final response = await _supabase
          .from(_itemsTable)
          .insert(dto.toInsertJson())
          .select()
          .single();

      final createdItem = ItemDto.fromJson(response).toDomain();

      AppLogger.info('ITEM_SERVICE: Successfully created item ${createdItem.id}');
      return Result.success(createdItem);
    } on PostgrestException catch (e) {
      AppLogger.error('ITEM_SERVICE: PostgresException creating item', e);
      
      if (e.code == '23505') { // Unique constraint violation
        return Result.failure(ItemServerError.conflict());
      }
      if (e.code == '23503') { // Foreign key violation
        return Result.failure(ItemValidationError.invalidProjectId());
      }
      
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error creating item', e);
      return const Result.failure( ItemNetworkError('Failed to create item'));
    }
  }

  @override
  Future<Result<ItemModel, ItemError>> updateItem({
    required String itemId,
    String? title,
    String? description,
    Map<String, dynamic>? content,
    ItemTypeEnum? itemType,
    ItemStatusEnum? status,
    ItemPriorityEnum? priority,
    List<String>? tags,
  }) async {
    try {
      // Validation
      if (title != null && title.trim().isEmpty) {
        return Result.failure(ItemValidationError.emptyTitle());
      }
      if (content != null && content.isEmpty) {
        return Result.failure(ItemValidationError.emptyContent());
      }
      if (tags != null && tags.length > 10) {
        return Result.failure(ItemValidationError.tooManyTags());
      }
      if (tags != null) {
        for (final tag in tags) {
          if (tag.length > 50) {
            return Result.failure(ItemValidationError.tagTooLong(tag));
          }
        }
      }

      AppLogger.info('ITEM_SERVICE: Updating item $itemId');

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updateData['title'] = title.trim();
      if (description != null) updateData['description'] = description.trim().isEmpty ? null : description.trim();
      if (content != null) updateData['content'] = content;
      if (itemType != null) updateData['item_type'] = itemType.value;
      if (status != null) {
        updateData['status'] = status.value;
        if (status == ItemStatusEnum.resolved) {
          updateData['resolved_at'] = DateTime.now().toIso8601String();
        }
      }
      if (priority != null) updateData['priority'] = priority.value;
      if (tags != null) {
        final cleanTags = tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
        updateData['tags'] = cleanTags.isEmpty ? null : cleanTags;
      }

      final response = await _supabase
          .from(_itemsTable)
          .update(updateData)
          .eq('id', itemId)
          .select()
          .single();

      final updatedItem = ItemDto.fromJson(response).toDomain();

      AppLogger.info('ITEM_SERVICE: Successfully updated item $itemId');
      return Result.success(updatedItem);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return Result.failure(ItemNotFoundError.byId(itemId));
      }
      AppLogger.error('ITEM_SERVICE: PostgresException updating item $itemId', e);
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error updating item $itemId', e);
      return const Result.failure( ItemNetworkError('Failed to update item'));
    }
  }

  @override
  Future<Result<void, ItemError>> deleteItem(String itemId) async {
    try {
      AppLogger.info('ITEM_SERVICE: Deleting item $itemId');

      await _supabase
          .from(_itemsTable)
          .delete()
          .eq('id', itemId);

      AppLogger.info('ITEM_SERVICE: Successfully deleted item $itemId');
      return const Result.success(null);
    } on PostgrestException catch (e) {
      AppLogger.error('ITEM_SERVICE: PostgresException deleting item $itemId', e);
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error deleting item $itemId', e);
      return const Result.failure( ItemNetworkError('Failed to delete item'));
    }
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> searchItems({
    required String projectId,
    String? query,
    List<ItemTypeEnum>? types,
    List<ItemStatusEnum>? statuses,
    List<ItemPriorityEnum>? priorities,
    List<String>? tags,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      AppLogger.info('ITEM_SERVICE: Searching items in project $projectId');

      var queryBuilder = _supabase
          .from(_itemsTable)
          .select('*')
          .eq('project_id', projectId);

      // Full-text search
      if (query != null && query.trim().isNotEmpty) {
        queryBuilder = queryBuilder.textSearch('search_vector', query.trim());
      }

      // Filter by types
      if (types != null && types.isNotEmpty) {
        final typeValues = types.map((type) => type.value).toList();
        queryBuilder = queryBuilder.inFilter('item_type', typeValues);
      }

      // Filter by statuses
      if (statuses != null && statuses.isNotEmpty) {
        final statusValues = statuses.map((status) => status.value).toList();
        queryBuilder = queryBuilder.inFilter('status', statusValues);
      }

      // Filter by priorities
      if (priorities != null && priorities.isNotEmpty) {
        final priorityValues = priorities.map((priority) => priority.value).toList();
        queryBuilder = queryBuilder.inFilter('priority', priorityValues);
      }

      // Filter by tags
      if (tags != null && tags.isNotEmpty) {
        for (final tag in tags) {
          queryBuilder = queryBuilder.contains('tags', [tag]);
        }
      }

      final response = await queryBuilder
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final items = (response as List<dynamic>)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toDomain())
          .toList();

      AppLogger.info('ITEM_SERVICE: Successfully found ${items.length} items');
      return Result.success(items);
    } on PostgrestException catch (e) {
      AppLogger.error('ITEM_SERVICE: PostgresException searching items', e);
      return Result.failure(ItemServerError('Database error: ${e.message}'));
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Unexpected error searching items', e);
      return const Result.failure( ItemNetworkError('Failed to search items'));
    }
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getItemsByStatus({
    required String projectId,
    required ItemStatusEnum status,
    int limit = 50,
    int offset = 0,
  }) async {
    return searchItems(
      projectId: projectId,
      statuses: [status],
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getItemsByType({
    required String projectId,
    required ItemTypeEnum type,
    int limit = 50,
    int offset = 0,
  }) async {
    return searchItems(
      projectId: projectId,
      types: [type],
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getItemsByPriority({
    required String projectId,
    required ItemPriorityEnum priority,
    int limit = 50,
    int offset = 0,
  }) async {
    return searchItems(
      projectId: projectId,
      priorities: [priority],
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getItemsByTag({
    required String projectId,
    required String tag,
    int limit = 50,
    int offset = 0,
  }) async {
    return searchItems(
      projectId: projectId,
      tags: [tag],
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getRecentItems({
    required String projectId,
    int limit = 20,
  }) async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      
      final response = await _supabase
          .from(_itemsTable)
          .select('*')
          .eq('project_id', projectId)
          .gte('created_at', sevenDaysAgo.toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);

      final items = (response as List<dynamic>)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toDomain())
          .toList();

      return Result.success(items);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error loading recent items', e);
      return const Result.failure( ItemNetworkError('Failed to load recent items'));
    }
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getPopularItems({
    required String projectId,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from(_itemsTable)
          .select('*')
          .eq('project_id', projectId)
          .order('vote_score', ascending: false)
          .order('view_count', ascending: false)
          .limit(limit);

      final items = (response as List<dynamic>)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toDomain())
          .toList();

      return Result.success(items);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error loading popular items', e);
      return const Result.failure( ItemNetworkError('Failed to load popular items'));
    }
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> getItemsByAuthor({
    required String projectId,
    required String authorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from(_itemsTable)
          .select('*')
          .eq('project_id', projectId)
          .eq('author_id', authorId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final items = (response as List<dynamic>)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toDomain())
          .toList();

      return Result.success(items);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error loading items by author', e);
      return const Result.failure( ItemNetworkError('Failed to load items by author'));
    }
  }

  @override
  Future<Result<void, ItemError>> incrementViewCount(String itemId) async {
    try {
      await _supabase.rpc('increment_item_view_count', params: {'item_id': itemId});
      return const Result.success(null);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error incrementing view count', e);
      return const Result.failure( ItemNetworkError('Failed to update view count'));
    }
  }

  @override
  Future<Result<void, ItemError>> voteOnItem(String itemId, bool isUpvote) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return const Result.failure( ItemPermissionError('User not authenticated'));
      }

      // Use RPC function for atomic vote operation
      await _supabase.rpc('vote_on_item', params: {
        'item_id': itemId,
        'user_id': currentUser.id,
        'is_upvote': isUpvote,
      });

      return const Result.success(null);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error voting on item', e);
      return const Result.failure( ItemNetworkError('Failed to vote on item'));
    }
  }

  @override
  Future<Result<void, ItemError>> removeVote(String itemId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return const Result.failure( ItemPermissionError('User not authenticated'));
      }

      await _supabase
          .from(_itemVotesTable)
          .delete()
          .eq('item_id', itemId)
          .eq('user_id', currentUser.id);

      return const Result.success(null);
    } catch (e) {
      AppLogger.error('ITEM_SERVICE: Error removing vote', e);
      return const Result.failure( ItemNetworkError('Failed to remove vote'));
    }
  }

  // Simplified implementations for remaining methods...
  @override
  Future<Result<ItemStatistics, ItemError>> getProjectItemStatistics(String projectId) async {
    // TODO: Implement with proper SQL aggregation queries
    return const Result.failure( ItemNetworkError('Not implemented yet'));
  }

  @override
  Future<Result<bool, ItemError>> canPerformAction({
    required String itemId,
    required ItemAction action,
  }) async {
    // TODO: Implement permission checking based on RLS policies
    return const Result.success(true);
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> bulkUpdateItems({
    required List<String> itemIds,
    ItemStatusEnum? status,
    ItemPriorityEnum? priority,
    List<String>? addTags,
    List<String>? removeTags,
  }) async {
    // TODO: Implement bulk operations
    return const Result.failure( ItemNetworkError('Not implemented yet'));
  }

  @override
  Future<Result<List<String>, ItemError>> getSuggestedTags({
    required String projectId,
    required String content,
    int limit = 10,
  }) async {
    // TODO: Implement tag suggestion algorithm
    return const Result.success([]);
  }

  @override
  Future<Result<List<ItemModel>, ItemError>> findPotentialDuplicates({
    required String projectId,
    required String title,
    required String description,
    int limit = 5,
  }) async {
    // TODO: Implement duplicate detection algorithm
    return const Result.success([]);
  }
}
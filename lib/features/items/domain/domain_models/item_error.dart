/// Base class for item-related errors
sealed class ItemError {
  const ItemError(this.message);
  
  final String message;
  
  @override
  String toString() => 'ItemError: $message';
}

/// Network-related item errors
final class ItemNetworkError extends ItemError {
  const ItemNetworkError([super.message = 'Network error occurred']);
}

/// Validation-related item errors
final class ItemValidationError extends ItemError {
  const ItemValidationError(super.message);
  
  factory ItemValidationError.emptyTitle() => 
      const ItemValidationError('Item title is required');
  
  factory ItemValidationError.emptyContent() => 
      const ItemValidationError('Item content cannot be empty');
  
  factory ItemValidationError.invalidProjectId() => 
      const ItemValidationError('Invalid project ID');
  
  factory ItemValidationError.tagTooLong(String tag) => 
      ItemValidationError('Tag "$tag" is too long (max 50 characters)');
  
  factory ItemValidationError.tooManyTags() => 
      const ItemValidationError('Maximum 10 tags allowed per item');
}

/// Permission-related item errors
final class ItemPermissionError extends ItemError {
  const ItemPermissionError([super.message = 'You do not have permission to perform this action']);
  
  factory ItemPermissionError.cannotCreate() => 
      const ItemPermissionError('You do not have permission to create items in this project');
  
  factory ItemPermissionError.cannotEdit() => 
      const ItemPermissionError('You do not have permission to edit this item');
  
  factory ItemPermissionError.cannotDelete() => 
      const ItemPermissionError('You do not have permission to delete this item');
  
  factory ItemPermissionError.cannotView() => 
      const ItemPermissionError('You do not have permission to view this item');
}

/// Item not found error
final class ItemNotFoundError extends ItemError {
  const ItemNotFoundError([super.message = 'Item not found']);
  
  factory ItemNotFoundError.byId(String itemId) => 
      ItemNotFoundError('Item with ID "$itemId" not found');
}

/// Server-related item errors
final class ItemServerError extends ItemError {
  const ItemServerError([super.message = 'Server error occurred']) : statusCode = null;
  
  final int? statusCode;
  
  const ItemServerError.withStatus(this.statusCode, super.message);
  
  factory ItemServerError.conflict() => 
      const ItemServerError('Item already exists or conflict occurred');
  
  factory ItemServerError.internalError() => 
      const ItemServerError('Internal server error occurred');
}

/// Storage-related item errors (for file attachments)
final class ItemStorageError extends ItemError {
  const ItemStorageError(super.message);
  
  factory ItemStorageError.uploadFailed() => 
      const ItemStorageError('Failed to upload file attachment');
  
  factory ItemStorageError.downloadFailed() => 
      const ItemStorageError('Failed to download file attachment');
  
  factory ItemStorageError.fileTooLarge() => 
      const ItemStorageError('File size exceeds maximum limit (10MB)');
  
  factory ItemStorageError.invalidFileType() => 
      const ItemStorageError('File type not supported');
}

/// Parse/serialization errors
final class ItemParseError extends ItemError {
  const ItemParseError(super.message);
  
  factory ItemParseError.invalidJson() => 
      const ItemParseError('Failed to parse item data');
  
  factory ItemParseError.invalidContentFormat() => 
      const ItemParseError('Invalid item content format');
}
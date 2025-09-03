/// Enumeration of possible project-related errors
enum ProjectError {
  /// Network connectivity issues
  networkError,
  
  /// Server errors (5xx status codes)
  serverError,
  
  /// Authentication/authorization errors
  authenticationError,
  
  /// Project not found
  projectNotFound,
  
  /// Invalid project data
  invalidProjectData,
  
  /// Permission denied
  permissionDenied,
  
  /// Database connection issues
  databaseError,
  
  /// Unknown/unexpected errors
  unknown,
}

/// Extension to provide user-friendly error messages
extension ProjectErrorExtension on ProjectError {
  /// Returns a user-friendly error message
  String get message {
    switch (this) {
      case ProjectError.networkError:
        return 'No internet connection. Please check your network and try again.';
      case ProjectError.serverError:
        return 'Server is temporarily unavailable. Please try again later.';
      case ProjectError.authenticationError:
        return 'Authentication failed. Please sign in again.';
      case ProjectError.projectNotFound:
        return 'Project not found.';
      case ProjectError.invalidProjectData:
        return 'Invalid project data provided.';
      case ProjectError.permissionDenied:
        return 'You do not have permission to access this project.';
      case ProjectError.databaseError:
        return 'Database error occurred. Please try again.';
      case ProjectError.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
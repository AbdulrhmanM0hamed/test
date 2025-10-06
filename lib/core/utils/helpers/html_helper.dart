class HtmlHelper {
  /// Clean HTML content by removing HTML tags and entities
  static String cleanHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) return '';
    
    String cleaned = htmlContent;
    
    // Remove HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // Replace common HTML entities
    cleaned = cleaned.replaceAll('&nbsp;', ' ');
    cleaned = cleaned.replaceAll('&amp;', '&');
    cleaned = cleaned.replaceAll('&lt;', '<');
    cleaned = cleaned.replaceAll('&gt;', '>');
    cleaned = cleaned.replaceAll('&quot;', '"');
    cleaned = cleaned.replaceAll('&#39;', "'");
    cleaned = cleaned.replaceAll('&ndash;', '–');
    cleaned = cleaned.replaceAll('&mdash;', '—');
    cleaned = cleaned.replaceAll('&ldquo;', '"');
    cleaned = cleaned.replaceAll('&rdquo;', '"');
    cleaned = cleaned.replaceAll('&lsquo;', ''');
    cleaned = cleaned.replaceAll('&rsquo;', ''');
    
    // Remove extra whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.trim();
    
    return cleaned;
  }

  /// Extract excerpt from HTML content
  static String extractExcerpt(String htmlContent, {int maxLength = 150}) {
    String cleaned = cleanHtmlContent(htmlContent);
    
    if (cleaned.length <= maxLength) {
      return cleaned;
    }
    
    // Find the last complete word within the limit
    String truncated = cleaned.substring(0, maxLength);
    int lastSpace = truncated.lastIndexOf(' ');
    
    if (lastSpace > 0) {
      truncated = truncated.substring(0, lastSpace);
    }
    
    return '$truncated...';
  }

  /// Fix image URLs in HTML content
  static String fixImageUrls(String htmlContent, {String? baseUrl}) {
    if (htmlContent.isEmpty) return htmlContent;
    
    const String defaultBaseUrl = 'https://sobiehcoffee.com/sobieh/public';
    final String actualBaseUrl = baseUrl ?? defaultBaseUrl;
    
    String fixed = htmlContent;
    
    // Fix relative image paths
    fixed = fixed.replaceAllMapped(
      RegExp(r'<img[^>]+src="([^"]*)"[^>]*>', caseSensitive: false),
      (match) {
        String src = match.group(1) ?? '';
        
        // Convert relative paths to absolute URLs
        if (src.startsWith('/storage/') || src.startsWith('../')) {
          src = '$actualBaseUrl$src';
        } else if (src.startsWith('storage/')) {
          src = '$actualBaseUrl/$src';
        }
        
        return match.group(0)!.replaceFirst(match.group(1)!, src);
      },
    );
    
    return fixed;
  }

  /// Estimate reading time based on content
  static int estimateReadingTime(String htmlContent) {
    String cleaned = cleanHtmlContent(htmlContent);
    
    // Average reading speed is about 200-250 words per minute
    // We'll use 225 words per minute as average
    const int wordsPerMinute = 225;
    
    // Count words
    List<String> words = cleaned.split(RegExp(r'\s+'));
    int wordCount = words.where((word) => word.isNotEmpty).length;
    
    // Calculate reading time in minutes
    int readingTime = (wordCount / wordsPerMinute).ceil();
    
    // Minimum reading time is 1 minute
    return readingTime < 1 ? 1 : readingTime;
  }

  /// Check if content contains HTML tags
  static bool containsHtml(String content) {
    return RegExp(r'<[^>]*>').hasMatch(content);
  }

  /// Remove specific HTML tags while keeping content
  static String removeSpecificTags(String htmlContent, List<String> tags) {
    String cleaned = htmlContent;
    
    for (String tag in tags) {
      // Remove opening and closing tags but keep content
      cleaned = cleaned.replaceAll(
        RegExp('<$tag[^>]*>', caseSensitive: false),
        '',
      );
      cleaned = cleaned.replaceAll(
        RegExp('</$tag>', caseSensitive: false),
        '',
      );
    }
    
    return cleaned;
  }

  /// Keep only specific HTML tags
  static String keepOnlyTags(String htmlContent, List<String> allowedTags) {
    if (allowedTags.isEmpty) {
      return cleanHtmlContent(htmlContent);
    }
    
    String cleaned = htmlContent;
    
    // Create pattern for allowed tags
    
    // Remove all tags except allowed ones
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'<(/?)([^>]+)>', caseSensitive: false),
      (match) {
        String tagName = match.group(2)?.split(' ')[0].toLowerCase() ?? '';
        
        if (allowedTags.contains(tagName)) {
          return match.group(0)!; // Keep the tag
        } else {
          return ''; // Remove the tag
        }
      },
    );
    
    return cleaned;
  }
}

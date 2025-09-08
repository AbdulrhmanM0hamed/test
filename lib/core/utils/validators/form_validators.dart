class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    // تنظيف البريد الإلكتروني من المسافات
    value = value.trim();
    
    // التحقق من صحة تنسيق البريد الإلكتروني بشكل أكثر دقة
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    
    // التحقق من الطول المعقول
    if (value.length > 125) {
      return 'البريد الإلكتروني طويل جداً';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    // تنظيف كلمة المرور من المسافات الزائدة
    value = value.trim();
    
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }

    if (value.length > 50) {
      return 'كلمة المرور طويلة جداً';
    }

    // التحقق من تعقيد كلمة المرور
    bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
    bool hasNumbers = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (hasUpperCase) strength++;
    if (hasLowerCase) strength++;
    if (hasNumbers) strength++;
    if (hasSpecialCharacters) strength++;

    if (strength < 3) {
      return 'كلمة المرور ضعيفة. يجب أن تحتوي على:\n'
          '- حرف كبير\n'
          '- حرف صغير\n'
          '- رقم\n'
          '- رمز خاص (!@#\$%^&*)';
    }

    return null;
  }

  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    // تنظيف رقم الهاتف من المسافات والرموز
    value = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // التحقق من صيغة رقم الهاتف السعودي
    // final saudiPhoneRegex = RegExp(r'^(05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$');
    
    // if (!saudiPhoneRegex.hasMatch(value)) {
    //   return 'يرجى إدخال رقم هاتف سعودي صحيح';
    // }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }

    // تنظيف الاسم من المسافات الزائدة
    value = value.trim();
    
    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }

    if (value.length > 50) {
      return 'الاسم طويل جداً';
    }

    // التحقق من عدم وجود أرقام أو رموز خاصة
    if (value.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الطول مطلوب';
    }

    // تنظيف القيمة من المسافات والرموز
    value = value.replaceAll(RegExp(r'[^\d.]'), '');
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (height < 100 || height > 220) {
      return 'يرجى إدخال طول منطقي (100-220 سم)';
    }

    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوزن مطلوب';
    }

    // تنظيف القيمة من المسافات والرموز
    value = value.replaceAll(RegExp(r'[^\d.]'), '');
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (weight < 30 || weight > 200) {
      return 'يرجى إدخال وزن منطقي (30-200 كجم)';
    }

    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الوصف مطلوب';
    }

    // تنظيف الوصف من المسافات الزائدة
    value = value.trim();
    
    if (value.length < 10) {
      return 'الوصف قصير جداً (10 أحرف على الأقل)';
    }

    if (value.length > 500) {
      return 'الوصف طويل جداً (500 حرف كحد أقصى)';
    }

    // التحقق من عدم وجود روابط أو كود برمجي
    if (value.contains(RegExp(r'http|www|<|>|\{|\}'))) {
      return 'الوصف يحتوي على محتوى غير مسموح به';
    }

    return null;
  }

  static String? validateExecutionTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'وقت التنفيذ مطلوب';
    }

    // تنظيف القيمة من المسافات والرموز
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    
    final days = int.tryParse(value);
    if (days == null) {
      return 'يرجى إدخال عدد أيام صحيح';
    }

    if (days < 1) {
      return 'وقت التنفيذ لا يمكن أن يكون أقل من يوم';
    }

    if (days > 90) {
      return 'وقت التنفيذ لا يمكن أن يتجاوز 90 يوم';
    }

    return null;
  }

  static String? validateShopSearch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال اسم المتجر';
    }

    value = value.trim();

    if (value.length < 2) {
      return 'اسم المتجر قصير جداً';
    }

    if (value.length > 50) {
      return 'اسم المتجر طويل جداً';
    }

    // منع الرموز الخاصة
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'اسم المتجر يحتوي على رموز غير مسموح بها';
    }

    return null;
  }

  static String? validateServiceSearch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال اسم الخدمة';
    }

    value = value.trim();

    if (value.length < 2) {
      return 'اسم الخدمة قصير جداً';
    }

    if (value.length > 50) {
      return 'اسم الخدمة طويل جداً';
    }

    // منع الرموز الخاصة
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'اسم الخدمة يحتوي على رموز غير مسموح بها';
    }

    return null;
  }

  // للبحث المتقدم في المتاجر والخدمات
  static String? validateAdvancedSearch({
    String? shopName,
    String? serviceName,
    String? city,
    String? category,
    String? priceRange,
    String? rating,
  }) {
    // التحقق من اسم المتجر
    if (shopName != null && shopName.isNotEmpty) {
      final shopError = validateShopSearch(shopName);
      if (shopError != null) return shopError;
    }

    // التحقق من اسم الخدمة
    if (serviceName != null && serviceName.isNotEmpty) {
      final serviceError = validateServiceSearch(serviceName);
      if (serviceError != null) return serviceError;
    }

    // التحقق من المدينة
    if (city != null && city.isNotEmpty) {
      if (city.length < 2) {
        return 'اسم المدينة قصير جداً';
      }
      if (city.length > 30) {
        return 'اسم المدينة طويل جداً';
      }
    }

    // التحقق من نطاق السعر
    if (priceRange != null && priceRange.isNotEmpty) {
      final prices = priceRange.split('-');
      if (prices.length == 2) {
        final min = double.tryParse(prices[0]);
        final max = double.tryParse(prices[1]);
        if (min != null && max != null && min > max) {
          return 'نطاق السعر غير صحيح';
        }
      }
    }

    // التحقق من التقييم
    if (rating != null && rating.isNotEmpty) {
      final ratingValue = double.tryParse(rating);
      if (ratingValue != null && (ratingValue < 0 || ratingValue > 5)) {
        return 'التقييم يجب أن يكون بين 0 و 5';
      }
    }

    return null;
  }
}

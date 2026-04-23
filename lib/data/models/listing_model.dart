class ListingModel {
  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String description;
  final String category;
  final double? priceSale;
  final double? originalPrice;
  final String? discount;
  final double? priceRentDaily;
  final double? priceAuctionStarting;
  final bool isAvailableForSale;
  final bool isAvailableForRent;
  final bool isAvailableForAuction;
  final List<String>? imageUrls;
  final double? rating;
  final int? ratingCount;
  final List<String>? badges;
  final String? section;
  final DateTime? createdAt;

  ListingModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    this.priceSale,
    this.originalPrice,
    this.discount,
    this.priceRentDaily,
    this.priceAuctionStarting,
    this.isAvailableForSale = false,
    this.isAvailableForRent = false,
    this.isAvailableForAuction = false,
    this.imageUrls,
    this.rating,
    this.ratingCount,
    this.badges,
    this.section,
    this.createdAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String? ?? 'system',
      title: json['title'] as String,
      author: json['author'] as String? ?? 'Unknown Author',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      priceSale: (json['selling_price'] ?? json['price_sale'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      discount: json['discount'] as String?,
      priceRentDaily: (json['price_rent_daily'] as num?)?.toDouble(),
      priceAuctionStarting: (json['price_auction_starting'] as num?)?.toDouble(),
      isAvailableForSale: json['is_available_for_sale'] as bool? ?? true,
      isAvailableForRent: json['is_available_for_rent'] as bool? ?? false,
      isAvailableForAuction: json['is_available_for_auction'] as bool? ?? false,
      imageUrls: json['image'] != null 
          ? [json['image'] as String] 
          : (json['image_urls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'] as int?,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList(),
      section: json['section'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'price_sale': priceSale,
      'original_price': originalPrice,
      'discount': discount,
      'price_rent_daily': priceRentDaily,
      'price_auction_starting': priceAuctionStarting,
      'is_available_for_sale': isAvailableForSale,
      'is_available_for_rent': isAvailableForRent,
      'is_available_for_auction': isAvailableForAuction,
      'image_urls': imageUrls,
      'rating': rating,
      'rating_count': ratingCount,
      'badges': badges,
      'section': section,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

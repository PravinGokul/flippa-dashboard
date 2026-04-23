import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/data/repositories/listings_repository.dart';
import 'package:flippa/services/storage/image_storage_service.dart';
import 'package:flippa/services/ai/ai_pricing_service.dart';

class EditListingDialog extends StatefulWidget {
  final ListingModel listing;

  const EditListingDialog({super.key, required this.listing});

  @override
  State<EditListingDialog> createState() => _EditListingDialogState();
}

class _EditListingDialogState extends State<EditListingDialog> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late String _condition;
  late String _category;
  
  double? _suggestedSalePrice;
  double? _suggestedRentPrice;
  bool _isAnalyzing = false;
  bool _isUploading = false;
  
  final _picker = ImagePicker();
  XFile? _selectedImage;
  String? _existingImageUrl;

  final _aiService = AiPricingService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.listing.title);
    _authorController = TextEditingController(text: widget.listing.author);
    _condition = 'Good'; // In a real app, map this from listing.description or add condition to model
    _category = widget.listing.category.isNotEmpty ? widget.listing.category : 'Fiction';
    _suggestedSalePrice = widget.listing.priceSale;
    _suggestedRentPrice = widget.listing.priceRentDaily;
    _existingImageUrl = widget.listing.imageUrls?.isNotEmpty == true ? widget.listing.imageUrls!.first : null;
  }

  Future<void> _getAiSuggestions() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and author first')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);
    
    const marketMedian = 25.0; // Mock

    final result = await _aiService.suggestPrice(
      listingId: widget.listing.id,
      marketMedian: marketMedian,
    );

    setState(() {
      _suggestedSalePrice = result['suggestedPrice'];
      _suggestedRentPrice = _suggestedSalePrice! * 0.1;
      _isAnalyzing = false;
    });
  }

  Future<void> _updateListing() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty || _suggestedSalePrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter details and get a price suggestion.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      String? imageUrl = _existingImageUrl;
      if (_selectedImage != null) {
        final uploadService = ImageStorageService();
        imageUrl = await uploadService.uploadListingImage(_selectedImage!);
      }
      
      final updatedListing = ListingModel(
        id: widget.listing.id,
        ownerId: widget.listing.ownerId,
        title: _titleController.text,
        author: _authorController.text,
        description: 'A premium quality book in $_condition condition.',
        category: _category,
        priceSale: _suggestedSalePrice,
        priceRentDaily: _suggestedRentPrice,
        isAvailableForSale: widget.listing.isAvailableForSale,
        isAvailableForRent: widget.listing.isAvailableForRent,
        imageUrls: imageUrl != null ? [imageUrl] : null,
      );

      await ListingsRepository().updateListing(updatedListing);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate change
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing updated successfully!')));
      }
    } catch (e) {
      debugPrint("Error updating: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating listing: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Listing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
              ),
              const SizedBox(height: 24),
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildField('Book Title', _titleController),
              const SizedBox(height: 16),
              _buildField('Author', _authorController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDropdown('Condition', ['New', 'Like New', 'Good', 'Fair'], _condition, (v) => setState(() => _condition = v!))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Category', ['Fiction', 'Non-Fiction', 'Science', 'History'], _category, (v) => setState(() => _category = v!))),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _getAiSuggestions,
                  icon: _isAnalyzing 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                  label: Text(_isAnalyzing ? 'Analyzing Market...' : 'Refresh AI Price Suggestion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E2C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (_suggestedSalePrice != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPriceInfo('Sale Price', '\$${_suggestedSalePrice!.toStringAsFixed(2)}'),
                      _buildPriceInfo('Rent Price', '\$${_suggestedRentPrice?.toStringAsFixed(2) ?? 'N/A'}/day'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isUploading ? null : _updateListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isUploading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Update Listing'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) setState(() => _selectedImage = image);
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
        ),
        child: _displayImage(),
      ),
    );
  }

  Widget _displayImage() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: kIsWeb 
           ? Image.network(_selectedImage!.path, fit: BoxFit.cover) 
           : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
      );
    } else if (_existingImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(_existingImageUrl!, fit: BoxFit.cover),
      );
    } else {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.blueAccent),
          SizedBox(height: 8),
          Text('Tap to add/change cover image', style: TextStyle(color: Colors.blueAccent)),
        ],
      );
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
      ],
    );
  }
}

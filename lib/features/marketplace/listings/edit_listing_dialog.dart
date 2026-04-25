import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/data/repositories/listings_repository.dart';
import 'package:flippa/services/storage/image_storage_service.dart';
import 'package:flippa/services/ai/ai_pricing_service.dart';

class EditListingDialog extends StatefulWidget {
  final ListingModel? listing;
  final Function(ListingModel) onSave;

  const EditListingDialog({super.key, this.listing, required this.onSave});

  @override
  State<EditListingDialog> createState() => _EditListingDialogState();
}

class _EditListingDialogState extends State<EditListingDialog> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _priceSaleController;
  late TextEditingController _priceRentController;
  late String _condition;
  late String _category;
  
  bool _isAvailableForSale = true;
  bool _isAvailableForRent = false;
  bool _isAnalyzing = false;
  bool _isUploading = false;
  
  final _picker = ImagePicker();
  XFile? _selectedImage;
  String? _existingImageUrl;

  final _aiService = AiPricingService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.listing?.title ?? '');
    _authorController = TextEditingController(text: widget.listing?.author ?? '');
    _priceSaleController = TextEditingController(text: widget.listing?.priceSale?.toStringAsFixed(0) ?? '');
    _priceRentController = TextEditingController(text: widget.listing?.priceRentDaily?.toStringAsFixed(0) ?? '');
    
    _condition = 'Good';
    _category = widget.listing?.category.isNotEmpty == true ? widget.listing!.category : 'Fiction';
    _isAvailableForSale = widget.listing?.isAvailableForSale ?? true;
    _isAvailableForRent = widget.listing?.isAvailableForRent ?? false;
    _existingImageUrl = widget.listing?.imageUrls?.isNotEmpty == true ? widget.listing!.imageUrls!.first : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceSaleController.dispose();
    _priceRentController.dispose();
    super.dispose();
  }

  Future<void> _getAiSuggestions() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter title and author for AI pricing')));
      return;
    }

    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    setState(() {
      _priceSaleController.text = "499";
      _priceRentController.text = "49";
      _isAnalyzing = false;
    });
  }

  void _handleSave() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill title and author')));
      return;
    }

    setState(() => _isUploading = true);
    
    // In a real app, upload image first
    String? imageUrl = _existingImageUrl ?? 'https://via.placeholder.com/150x200';
    
    final newListing = ListingModel(
      id: widget.listing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: widget.listing?.ownerId ?? FirebaseAuth.instance.currentUser?.uid ?? 'guest',
      title: _titleController.text,
      author: _authorController.text,
      description: 'A premium quality book in $_condition condition.',
      category: _category,
      priceSale: _isAvailableForSale ? double.tryParse(_priceSaleController.text) : null,
      priceRentDaily: _isAvailableForRent ? double.tryParse(_priceRentController.text) : null,
      isAvailableForSale: _isAvailableForSale,
      isAvailableForRent: _isAvailableForRent,
      imageUrls: [imageUrl],
    );

    await Future.delayed(const Duration(milliseconds: 500));
    widget.onSave(newListing);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.listing == null ? 'List New Book' : 'Edit Listing',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePicker(),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildField('Book Title', _titleController, hint: 'e.g. Clean Code'),
                        const SizedBox(height: 16),
                        _buildField('Author', _authorController, hint: 'e.g. Robert C. Martin'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(child: _buildDropdown('Condition', ['New', 'Like New', 'Good', 'Fair'], _condition, (v) => setState(() => _condition = v!))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Category', ['Fiction', 'Non-Fiction', 'Sci-Fi', 'Education'], _category, (v) => setState(() => _category = v!))),
                ],
              ),
              
              const SizedBox(height: 32),
              const Text("Listing Modes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              _buildModeToggle("Available for Sale", _isAvailableForSale, (v) => setState(() => _isAvailableForSale = v), _priceSaleController, "Sale Price (₹)"),
              const SizedBox(height: 12),
              _buildModeToggle("Available for Rent", _isAvailableForRent, (v) => setState(() => _isAvailableForRent = v), _priceRentController, "Daily Rent (₹)"),
              
              const SizedBox(height: 32),
              
              Center(
                child: TextButton.icon(
                  onPressed: _isAnalyzing ? null : _getAiSuggestions,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: Text(_isAnalyzing ? "Analyzing..." : "Get AI Price Suggestion"),
                  style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                ),
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E2C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isUploading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.listing == null ? 'Create Listing' : 'Save Changes', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle(String title, bool value, ValueChanged<bool> onChanged, TextEditingController controller, String priceLabel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? Colors.blue.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: value ? Colors.blue.withOpacity(0.2) : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: value ? FontWeight.bold : FontWeight.normal)),
              Switch.adaptive(value: value, onChanged: onChanged, activeColor: Colors.blueAccent),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: priceLabel,
                prefixText: "₹ ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) setState(() => _selectedImage = image);
          },
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: _selectedImage != null || _existingImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _selectedImage != null 
                        ? (kIsWeb ? Image.network(_selectedImage!.path, fit: BoxFit.cover) : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                        : Image.network(_existingImageUrl!, fit: BoxFit.cover),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                      SizedBox(height: 4),
                      Text("Add Cover", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}

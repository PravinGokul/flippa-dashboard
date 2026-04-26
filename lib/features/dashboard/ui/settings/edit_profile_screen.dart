import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';
import 'package:flippa/ui/widgets/glass/glass_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: "Peter Grant");
  final _emailController = TextEditingController(text: "peter.grant@example.com");
  final _bioController = TextEditingController(text: "Avid collector of rare first editions and lover of classic literature.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF64748B)),
                Text("Back", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 32),
            _buildInputField("Full Name", _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildInputField("Email Address", _emailController, Icons.email_outlined),
            const SizedBox(height: 16),
            _buildInputField("Bio", _bioController, Icons.info_outline, maxLines: 4),
            const SizedBox(height: 40),
            GlassButton(
              label: "Save Changes",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!")));
                context.pop();
              },
              width: double.infinity,
              color: const Color(0xFF1E293B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF334155), Color(0xFF1E293B)]),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Text("PG", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
        const SizedBox(height: 10),
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              icon: Icon(icon, color: const Color(0xFF64748B), size: 20),
              border: InputBorder.none,
              hintText: "Enter $label",
            ),
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

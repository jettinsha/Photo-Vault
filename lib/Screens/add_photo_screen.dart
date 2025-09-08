import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../models/photo_model.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  bool isLoading = false;
  String loadingMessage = '';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await ImageService.requestPermissions();
  }

  Future<void> _pickSingleFromGallery() async {
    setState(() {
      isLoading = true;
      loadingMessage = 'Adding photo to vault...';
    });

    try {
      final PhotoModel? photo = await ImageService.pickImageFromGallery();
      if (photo != null) {
        await ImageService.savePhotoToVault(photo);
        _showSuccessMessage('Photo added to vault successfully!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showErrorMessage('Failed to add photo from gallery');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickMultipleFromGallery() async {
    setState(() {
      isLoading = true;
      loadingMessage = 'Selecting photos...';
    });

    try {
      final List<PhotoModel>? photos =
          await ImageService.pickMultipleImagesFromGallery();
      if (photos != null && photos.isNotEmpty) {
        setState(() {
          loadingMessage = 'Adding ${photos.length} photos to vault...';
        });

        int successCount = 0;
        for (int i = 0; i < photos.length; i++) {
          try {
            await ImageService.savePhotoToVault(photos[i]);
            successCount++;
            setState(() {
              loadingMessage =
                  'Added $successCount of ${photos.length} photos...';
            });
          } catch (e) {
            // Continue with other photos even if one fails
            print('Failed to save photo ${i + 1}: $e');
          }
        }

        if (successCount == photos.length) {
          _showSuccessMessage(
              'All $successCount photos added to vault successfully!');
        } else if (successCount > 0) {
          _showSuccessMessage(
              '$successCount of ${photos.length} photos added successfully!');
        } else {
          _showErrorMessage('Failed to add any photos to vault');
        }

        if (successCount > 0) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      _showErrorMessage('Failed to select photos from gallery');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    setState(() {
      isLoading = true;
      loadingMessage = 'Taking photo...';
    });

    try {
      final PhotoModel? photo = await ImageService.pickImageFromCamera();
      if (photo != null) {
        setState(() {
          loadingMessage = 'Adding photo to vault...';
        });
        await ImageService.savePhotoToVault(photo);
        _showSuccessMessage('Photo added to vault successfully!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showErrorMessage('Failed to take photo');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Add Photo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      loadingMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isTablet = screenWidth > 600;
        final isLandscape = screenWidth > screenHeight;

        // Responsive padding
        final horizontalPadding = isTablet ? screenWidth * 0.1 : 24.0;
        final verticalPadding = isLandscape ? 16.0 : 24.0;

        // Responsive spacing
        final topSpacing = isLandscape ? 16.0 : 32.0;
        final sectionSpacing = isLandscape ? 24.0 : 48.0;
        final cardSpacing = isLandscape ? 12.0 : 16.0;

        // Responsive icon and text sizes
        final iconSize = isTablet ? 100.0 : (isLandscape ? 60.0 : 80.0);
        final titleSize = isTablet ? 28.0 : (isLandscape ? 20.0 : 24.0);
        final subtitleSize = isTablet ? 18.0 : (isLandscape ? 14.0 : 16.0);

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: isLandscape 
                    ? MainAxisAlignment.start 
                    : MainAxisAlignment.center,
                children: [
                  if (isLandscape) SizedBox(height: topSpacing),
                  
                  // Main icon container
                  Container(
                    padding: EdgeInsets.all(isTablet ? 40 : (isLandscape ? 24 : 32)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: iconSize,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  
                  SizedBox(height: topSpacing),
                  
                  // Title
                  Text(
                    'Choose Photo Source',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    'Select how you want to add photos to your vault',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: subtitleSize,
                    ),
                  ),
                  
                  SizedBox(height: sectionSpacing),
                  
                  // Options - responsive layout
                  if (isTablet && !isLandscape)
                    _buildTabletOptions(cardSpacing)
                  else if (isLandscape && screenWidth > 800)
                    _buildLandscapeOptions(cardSpacing)
                  else
                    _buildMobileOptions(cardSpacing),
                  
                  if (isLandscape) const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile layout - vertical stack
  Widget _buildMobileOptions(double spacing) {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.photo_library_outlined,
          title: 'Single Photo',
          subtitle: 'Choose one photo from gallery',
          onTap: _pickSingleFromGallery,
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
        ),
        SizedBox(height: spacing),
        _buildOptionCard(
          icon: Icons.photo_library,
          title: 'Multiple Photos',
          subtitle: 'Choose multiple photos from gallery',
          onTap: _pickMultipleFromGallery,
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
          ),
        ),
        SizedBox(height: spacing),
        _buildOptionCard(
          icon: Icons.camera_alt_outlined,
          title: 'Camera',
          subtitle: 'Take a new photo',
          onTap: _pickFromCamera,
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
        ),
      ],
    );
  }

  // Tablet layout - 2 column grid
  Widget _buildTabletOptions(double spacing) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                icon: Icons.photo_library_outlined,
                title: 'Single Photo',
                subtitle: 'Choose one photo from gallery',
                onTap: _pickSingleFromGallery,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildOptionCard(
                icon: Icons.photo_library,
                title: 'Multiple Photos',
                subtitle: 'Choose multiple photos from gallery',
                onTap: _pickMultipleFromGallery,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: _pickFromCamera,
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
            ),
            const Expanded(child: SizedBox()), // Empty space for balance
          ],
        ),
      ],
    );
  }

  // Landscape layout - horizontal row
  Widget _buildLandscapeOptions(double spacing) {
    return Row(
      children: [
        Expanded(
          child: _buildOptionCard(
            icon: Icons.photo_library_outlined,
            title: 'Single Photo',
            subtitle: 'Choose one photo from gallery',
            onTap: _pickSingleFromGallery,
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: _buildOptionCard(
            icon: Icons.photo_library,
            title: 'Multiple Photos',
            subtitle: 'Choose multiple photos from gallery',
            onTap: _pickMultipleFromGallery,
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: _buildOptionCard(
            icon: Icons.camera_alt_outlined,
            title: 'Camera',
            subtitle: 'Take a new photo',
            onTap: _pickFromCamera,
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        
        // Responsive sizes
        final iconSize = isTablet ? 36.0 : (isLandscape ? 28.0 : 32.0);
        final titleSize = isTablet ? 22.0 : (isLandscape ? 16.0 : 20.0);
        final subtitleSize = isTablet ? 16.0 : (isLandscape ? 12.0 : 14.0);
        final padding = isTablet ? 24.0 : (isLandscape ? 16.0 : 20.0);
        final borderRadius = isTablet ? 20.0 : 16.0;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isLandscape && screenWidth > 800
                ? _buildLandscapeCardContent(icon, title, subtitle, iconSize, titleSize, subtitleSize)
                : _buildPortraitCardContent(icon, title, subtitle, iconSize, titleSize, subtitleSize),
          ),
        );
      },
    );
  }

  Widget _buildPortraitCardContent(
    IconData icon, 
    String title, 
    String subtitle, 
    double iconSize, 
    double titleSize, 
    double subtitleSize
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: subtitleSize,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildLandscapeCardContent(
    IconData icon, 
    String title, 
    String subtitle, 
    double iconSize, 
    double titleSize, 
    double subtitleSize
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: subtitleSize,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/app/core/init_supabase_user.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';

import 'image_edit_result.dart';
import 'image_editor_dialog.dart';

/// Um avatar circular que permite selecionar uma imagem da galeria,
/// mover a imagem dentro do círculo e editá-la.
/// 
/// Ao ser clicado, abre um seletor de imagem ou o editor, dependendo
/// se já há uma imagem selecionada. Pode carregar uma imagem inicial
/// a partir de uma URL.
class MovableAvatar extends StatefulWidget {
  /// URL da imagem a ser carregada inicialmente.
  String? imageUrl;

  /// Cria um avatar que pode carregar uma imagem de URL e editá-la.
  MovableAvatar({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<MovableAvatar> createState() => _MovableAvatarState();
}

class _MovableAvatarState extends State<MovableAvatar> {
  /// Arquivo da imagem atual exibida no avatar.
  File? _image;

  /// Deslocamento aplicado à imagem dentro do avatar.
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadImageFromUrl();
  }

  /// Carrega a imagem a partir da [widget.imageUrl] e a armazena em [_image].
  Future<void> _loadImageFromUrl() async {
    if (widget.imageUrl != null && _image == null) {
      try {
        final response = await http.get(Uri.parse(widget.imageUrl!));
        if (response.statusCode == 200) {
          final tempDir = Directory.systemTemp;
          final tempFile = File('${tempDir.path}/avatar.jpg');
          await tempFile.writeAsBytes(response.bodyBytes);
          setState(() {
            _image = tempFile;
          });
        }
      } catch (e) {
        debugPrint('Erro ao carregar imagem da URL: $e');
      }
    }
  }

  /// Abre um modal para editar a imagem atual.
  /// Se a edição for confirmada, atualiza [_image] e [_offset].
  Future<void> _openEditorModal() async {
    final result = await showDialog<ImageEditResult>(
      context: context,
      builder: (context) => ImageEditorDialog(image: _image),
    );

    if (result != null) {
      setState(() {
        _image = result.image;
      });

      if (widget.imageUrl != null) {
        final provider = context.watch<ProfileProvider>();
        provider.updateImageProfile(_image!);
      }
    }
  }

  /// Permite ao usuário selecionar uma imagem da galeria e abri-la no editor.
  /// Após a edição, atualiza a imagem e seu deslocamento.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      final File newImage = File(pickedFile.path);
      final result = await showDialog<ImageEditResult>(
        context: context,
        builder: (context) => ImageEditorDialog(image: newImage),
      );

      if (result != null) {
        setState(() {
          _image = result.image;
          _offset = result.offset;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _image != null ? _openEditorModal : _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: _image != null
              ? Transform.translate(
                  offset: _offset,
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                )
              : const Icon(Icons.person, size: 50, color: Colors.white70),
        ),
      ),
    );
  }
}

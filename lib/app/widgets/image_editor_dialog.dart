// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'image_edit_result.dart';

/// Um diálogo que permite ao usuário editar uma imagem selecionada,
/// aplicando um recorte circular que pode ser movido manualmente.
///
/// Após a edição, retorna um [ImageEditResult] com a imagem recortada
/// e o deslocamento aplicado.
class ImageEditorDialog extends StatefulWidget {
  /// A imagem inicial a ser editada.
  final File? image;

  /// Cria um [ImageEditorDialog] com a imagem fornecida.
  const ImageEditorDialog({super.key, required this.image});

  @override
  State<ImageEditorDialog> createState() => _ImageEditorDialogState();
}

class _ImageEditorDialogState extends State<ImageEditorDialog> {
  final double _cropSize = 190;

  /// Deslocamento do círculo de recorte sobre a imagem.
  Offset _cropOffset = Offset.zero;

  /// Imagem atual sendo exibida/editada.
  File? _currentImage;

  /// Imagem decodificada como [ui.Image] para operações de canvas.
  ui.Image? _decodedImage;

  /// Escala de exibição da imagem (ajustada ao tamanho do diálogo).
  double _displayImageScale = 1.0;


  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
    _loadUiImage();
  }

  /// Carrega a imagem como [ui.Image] para operações com canvas.
  Future<void> _loadUiImage() async {
    if (_currentImage == null) return;
    final data = await _currentImage!.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    setState(() {
      _decodedImage = frame.image;

      // Inicializa o recorte no centro da imagem.
      _cropOffset = Offset(
        (frame.image.width - _cropSize) / 2,
        (frame.image.height - _cropSize) / 2,
      );
    });
  }

  /// Atualiza a posição do recorte circular com base no gesto de arrastar.
  void _onPanUpdate(DragUpdateDetails details) {
    if (_decodedImage == null) return;

    final maxX = _decodedImage!.width - _cropSize;
    final maxY = _decodedImage!.height - _cropSize;

    setState(() {
      _cropOffset += details.delta / _displayImageScale;
      _cropOffset = Offset(
        _cropOffset.dx.clamp(0.0, maxX.toDouble()),
        _cropOffset.dy.clamp(0.0, maxY.toDouble()),
      );
    });
  }

  /// Recorta a imagem com base no círculo definido e retorna o resultado.
  Future<void> _cropAndReturn() async {
    if (_decodedImage == null) return;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Define o centro e raio do recorte circular.
    const center = Offset(130.0, 130.0);
    final radius = _cropSize / 2 + 50;

    // Define retângulos de origem (na imagem) e destino (no canvas).
    final srcRect = Rect.fromLTWH(
      _cropOffset.dx,
      _cropOffset.dy,
      _cropSize + 50,
      _cropSize + 50,
    );
    final dstRect = Rect.fromLTWH(0, 0, _cropSize, _cropSize);

    // Aplica a máscara circular.
    final path = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(path);

    // Desenha a imagem recortada.
    final paint = Paint();
    canvas.drawImageRect(_decodedImage!, srcRect, dstRect, paint);

    // Converte para imagem e salva como arquivo.
    final image = await pictureRecorder.endRecording().toImage(
      _cropSize.toInt(),
      _cropSize.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final croppedFile = await File(
        '${_currentImage!.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
      ).writeAsBytes(byteData.buffer.asUint8List());

      Navigator.of(context).pop(ImageEditResult(croppedFile, _cropOffset));
    }
  }

  /// Permite ao usuário selecionar uma nova imagem da galeria.
  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _currentImage = File(pickedFile.path);
        _cropOffset = Offset.zero;
      });
      await _loadUiImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDialogSize = MediaQuery.of(context).size.width * 0.8;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar imagem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _currentImage == null || _decodedImage == null
                ? const Text('Nenhuma imagem selecionada.')
                : Builder(
                    builder: (context) {
                      final imageWidth = _decodedImage!.width.toDouble();
                      final imageHeight = _decodedImage!.height.toDouble();
                      final scale = (maxDialogSize / imageWidth).clamp(0.1, 1.0);
                      _displayImageScale = scale;

                      return GestureDetector(
                        onPanUpdate: _onPanUpdate,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: imageWidth * scale,
                            height: imageHeight * scale,
                            child: Stack(
                              children: [
                                Image.file(
                                  _currentImage!,
                                  scale: 1.0,
                                  fit: BoxFit.contain,
                                ),
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: CropCirclePainter(
                                      cropSize: _cropSize * scale,
                                      offset: _cropOffset * scale,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Botão para trocar a imagem atual.
                TextButton(
                  onPressed: _pickNewImage,
                  child: const Text(
                    'Trocar imagem',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),

                /// Botão para cancelar e fechar o diálogo.
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                /// Botão de salvar a imagem recortada.
                SizedBox(
                  width: 120,
                  height: 60,
                  child: CustomButton(
                    onPressed: _decodedImage != null ? _cropAndReturn : () {},
                    text: "Salvar",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Um [CustomPainter] responsável por desenhar a área circular de recorte
/// sobre a imagem, com efeito de escurecimento fora da área.
class CropCirclePainter extends CustomPainter {
  /// Tamanho do círculo de recorte.
  final double cropSize;

  /// Posição do círculo na imagem.
  final Offset offset;

  /// Cria um [CropCirclePainter] com as propriedades fornecidas.
  CropCirclePainter({required this.cropSize, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withAlpha(50);

    // Cria uma área "furada" onde será mostrado o recorte.
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cropRect = Rect.fromCircle(
      center: offset + Offset(cropSize / 2, cropSize / 2),
      radius: cropSize / 2,
    );
    path.addOval(cropRect);
    path.fillType = PathFillType.evenOdd;

    // Desenha a máscara escura.
    canvas.drawPath(path, paint);

    // Borda branca ao redor do círculo.
    canvas.drawCircle(
      offset + Offset(cropSize / 2, cropSize / 2),
      cropSize / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(CropCirclePainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.cropSize != cropSize;
  }
}

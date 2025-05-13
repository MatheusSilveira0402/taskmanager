import 'dart:io';
import 'package:flutter/material.dart';

/// Representa o resultado da edição de uma imagem, incluindo o arquivo da imagem
/// e o deslocamento aplicado (por exemplo, usado para posicionamento ou recorte).
class ImageEditResult {
  /// Arquivo da imagem resultante da edição.
  final File image;

  /// Deslocamento aplicado à imagem (pode representar um deslocamento de recorte ou arraste).
  final Offset offset;

  /// Construtor que inicializa o resultado com a imagem e o deslocamento.
  ImageEditResult(this.image, this.offset);
}

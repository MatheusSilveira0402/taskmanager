import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Um widget de esqueleto para carregar uma representação de tarefa.
///
/// Este widget exibe um "esqueleto" animado utilizando a biblioteca [Shimmer], 
/// para indicar que os dados da tarefa estão sendo carregados de forma assíncrona. 
/// O efeito de shimmer é utilizado para criar uma animação visual que simula o carregamento dos dados.
/// 
/// O widget é um cartão com um fundo branco e bordas arredondadas que muda sua cor durante o carregamento.
class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(80, 82, 178, 173), // Cor base da animação
      highlightColor: Colors.grey[350]!, // Cor de destaque da animação
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white, // Cor de fundo do cartão
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
      ),
    );
  }
}

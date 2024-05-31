import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/card_provider.dart';
import '../models/company.dart';
import '../models/job.dart';

class CardPage extends StatefulWidget {
  final Company company;
  final Job job;

  final bool isFront;

  const CardPage({
    super.key,
    required this.company,
    required this.job,
    required this.isFront,
  });

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final size = MediaQuery.of(context).size;

        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.setScreenSize(size);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            widget.isFront ? buildFrontCard() : buildCard(),
            const SizedBox(height: 20),
            buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildFrontCard() {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);

          final position = provider.position;

          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);

          final angle = provider.angle * pi / 580;

          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            transform: rotatedMatrix..translate(position.dx, position.dy),
            duration: Duration(milliseconds: milliseconds),
            child: Stack(
              children: [
                buildCard(),
                buildStamps(),
              ],
            ),
          );
        },
      ),
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);

        provider.endPosition();
      },
    );
  }

  Widget buildCard() {
    return SizedBox(
      height: 480,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        // Container Imagem
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(widget.company.imgPath),
              alignment: const Alignment(0, 0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    buildName(widget.company, widget.job),
                    buildJob(widget.job),
                  ],
                ),
              ),

              // Botão Informação
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        tooltip: 'Descrição',
                        icon: const Icon(
                          Icons.info_outline,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: 'APPLY',
          opacity: opacity,
        );
        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: Colors.red,
          text: 'DENY',
          opacity: opacity,
        );
        return Positioned(top: 64, right: 50, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: 4,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        // Botão Dislike
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.red.withOpacity(0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(500),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 0.1,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.clear_rounded,
              size: 80,
              color: Colors.red,
            ),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.dislike();
            },
          ),
        ),
        const SizedBox(),
        // Botão Like
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.greenAccent.withOpacity(0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(500),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 0.1,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.check_rounded,
              size: 80,
              color: Colors.greenAccent,
            ),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.like();
            },
          ),
        ),
        const SizedBox()
      ],
    );
  }

  // Empresa, Cidade, Horário
  Widget buildName(company, job) {
    return Row(
      children: [
        Text(
          company.name,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ', ',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          company.city,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ', ',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          job.hours,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

// Cargo, Descrição
  Widget buildJob(job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.position,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              job.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

import '../models/company.dart';
import '../models/job.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<Company> _companies = [];
  List<Job> _jobs = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<Company> get companies => _companies;
  List<Job> get jobs => _jobs;
  bool get isDragging => _isDragging;
  double get angle => _angle;
  Offset get position => _position;

  CardProvider() {
    resetUsers();
  }

  void resetUsers() {
    _companies = <Company>[
      const Company(
          id: 1,
          name: 'Google',
          address: 'Rua Manoel Teixeira Patricio',
          city: 'Sorocaba',
          state: "SP",
          imgPath:
              'https://duet-cdn.vox-cdn.com/thumbor/0x0:2012x1341/640x427/filters:focal(1006x670:1007x671):format(webp)/cdn.vox-cdn.com/uploads/chorus_asset/file/15483559/google2.0.0.1441125613.jpg'),
      const Company(
          id: 2,
          name: 'Amazon',
          address: 'Avenida Paulista',
          city: 'São Paulo',
          state: 'SP',
          imgPath:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Amazon_icon.svg/2500px-Amazon_icon.svg.png'),
      const Company(
          id: 3,
          name: 'Meta',
          address: 'Avenida Faria Lima',
          city: 'São Paulo',
          state: 'SP',
          imgPath:
              'https://upload.wikimedia.org/wikipedia/commons/e/e4/Meta_Inc._logo.jpg')
    ].reversed.toList();

    _jobs = <Job>[
      const Job(description: 'posição', hours: 'horário', position: 'cargo'),
      const Job(description: 'posição', hours: 'horário', position: 'cargo'),
      const Job(description: 'posição', hours: 'horário', position: 'cargo')
    ].reversed.toList();

    notifyListeners();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      SnackBar(
        content: Text(status.toString()),
      );
    }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }

    resetPosition();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 200;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;

    if (force) {
      const delta = 200;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      const delta = 40;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (_companies.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 100));
    _companies.removeLast();
    resetPosition();
  }
}

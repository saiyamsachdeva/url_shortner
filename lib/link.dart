import 'package:equatable/equatable.dart';

class Link extends Equatable{
  final String bittenLink;
  final String originalLink;

  Link({
    required this.originalLink,
    required this.bittenLink,
  });
  
  @override
  List<Object?> get props => [originalLink];
}

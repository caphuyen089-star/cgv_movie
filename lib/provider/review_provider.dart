import 'package:flutter/material.dart';
import '../model/review.dart';

class ReviewProvider extends ChangeNotifier {
  final List<Review> _reviews = [
    Review(
      id: '1',
      movieId: 1,
      userName: 'Nguyễn Văn A',
      rating: 5.0,
      comment: 'Phim cực kỳ hay, kỹ xảo đỉnh cao!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Review> getReviewsForMovie(int movieId) {
    return _reviews.where((r) => r.movieId == movieId).toList();
  }

  void addReview(Review review) {
    _reviews.insert(0, review);
    notifyListeners();
  }
}
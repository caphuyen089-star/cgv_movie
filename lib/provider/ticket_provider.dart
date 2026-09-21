import 'package:flutter/material.dart';
import '../model/ticket.dart';

class TicketProvider extends ChangeNotifier {

  final List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }

  void removeTicket(int id) {
    _tickets.removeWhere((ticket) => ticket.id == id);
    notifyListeners();
  }

  Ticket? getTicket(int id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearTickets() {
    _tickets.clear();
    notifyListeners();
  }
}
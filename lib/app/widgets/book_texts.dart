import '../../models/book.dart';

/// Autores separados por vírgula, ou "Autor desconhecido".
String authorsLabel(Book book) =>
    book.authors.isEmpty ? 'Autor desconhecido' : book.authors.join(', ');

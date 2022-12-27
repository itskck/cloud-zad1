import 'dart:developer';
import 'dart:io';

void main() {
  print('Juliusz Piskor, IMST 2.3');
  print('fib.exe');
  print('-----------');
  int n;
  print('Wprowadź numer > 0  i  < 20');
  String? inTemp = stdin.readLineSync();

  try {
    n = int.parse(inTemp!);
    if (n > 20) {
      print('Numer jest za duży!');
      return;
    }
  } catch (e) {
    log(e.toString());
    return;
  }
  print(fib(n));
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

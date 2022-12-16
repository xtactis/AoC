#include <bits/stdc++.h>

//using namespace std;

char conv[300];

int main() {
  conv['A'] = 1;
  conv['B'] = 2;
  conv['C'] = 3;
  conv['X'] = 1;
  conv['Y'] = 2;
  conv['Z'] = 3;

  int score = 0;
  int score2 = 0;
  for (std::string line; std::getline(std::cin, line);) {
    std::cout << line << std::endl;
    char a, b;
    sscanf(line.c_str(), "%c %c\n", &a, &b);
    printf("%c %c\n", a, b);

    a = conv[a];
    b = conv[b];

    score += b;

    if (a == b) {
      score += 3;
    } else if (a == 1 && b == 2 || a == 2 && b == 3 || a == 3 && b == 1) {
      score += 6;
    }

    score2 += 3*(b-1);

    if (a == 1 && b == 2 || a == 2 && b == 1 || a == 3 && b == 3) {
      score2 += 1; 
    } else if (a == 1 && b == 3 || a == 2 && b == 2 || a == 3 && b == 1) {
      score2 += 2;
    } else {
      score2 += 3;
    }
  }

  printf("%d\n", score);
  printf("%d\n", score2);

  return 0;
}

#include <bits/stdc++.h>

//using namespace std;

long long elves[123434];

int main() {
  int elf = 0;
  for (std::string line; std::getline(std::cin, line);) {
    std::cout << line << std::endl;
    if (line == "") {
      ++elf;
      continue;
    }
    int cal; sscanf(line.c_str(), "%d", &cal);
    elves[elf] += cal;
  }
  std::sort(elves, elves+elf+1);
  printf("%lld\n", elves[elf]);
  printf("%lld\n", elves[elf]+elves[elf-1]+elves[elf-2]);

  return 0;
}

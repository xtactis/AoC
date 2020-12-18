use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::vec::Vec;
use std::convert::TryInto;

fn eval(line: &String, part: u8) -> i64 {
  let mut output: Vec<char> = Vec::new();
  let mut operators: Vec<char> = Vec::new();
  for c in line.chars() {
    if c == ' ' {
      continue;
    }
    if c.is_ascii_digit() {
      output.push(c);
    } else if c == '(' {
      operators.push(c);
    } else if c == ')' {
      while operators.len() > 0 && operators[operators.len()-1] != '(' {
        output.push(operators.pop().unwrap());
      }
      if operators.len() > 0 && operators[operators.len()-1] == '(' {
        operators.pop();
      }
    } else if c == '*' {
      while operators.len() > 0 && (operators[operators.len()-1] == '*' || operators[operators.len()-1] == '+') {
        output.push(operators.pop().unwrap());
      }
      operators.push(c);
    } else if c == '+' {
      while operators.len() > 0 && (operators[operators.len()-1] == '+' || (part == 1 && operators[operators.len()-1] == '*')) {
        output.push(operators.pop().unwrap());
      }
      operators.push(c);
    }
  }
  while operators.len() > 0 {
    output.push(operators.pop().unwrap())
  }
  let mut calc: Vec<i64> = Vec::new();
  for e in output {
    if e.is_ascii_digit() {
      calc.push(e.to_digit(10).unwrap_or(0u32).try_into().unwrap());
    } else if e == '+' {
      let a = calc.pop().unwrap();
      let b = calc.pop().unwrap();
      calc.push(a+b);
    } else if e == '*' {
      let a = calc.pop().unwrap();
      let b = calc.pop().unwrap();
      calc.push(a*b);
    }
  }
  return calc[0];
}

fn main() {
  let mut part1 = 0i64;
  let mut part2 = 0i64;
  if let Ok(lines) = read_lines("input.txt") {
    for line in lines {
      if let Ok(ip) = line {
        part1 += eval(&ip, 1);
        part2 += eval(&ip, 2);
      }
    }
    println!("part 1: {}", part1);
    println!("part 2: {}", part2);
  }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
  let file = File::open(filename)?;
  Ok(io::BufReader::new(file).lines())
}
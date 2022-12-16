import os

fn intersect(first []string, second []string) []string {
	mut result := []string{}
	mut second_map := map[string]bool // using this as a set
	for word in second {
		second_map[word] = true
	}
	for word in first {
		if word in second_map {
			result << word
		}
	}
	return result
}

fn part1(all_ingredients []string, possible_ingredients map[string][]string) int {
	mut definitely_allergic := []string{}
	for _, value in possible_ingredients {
		definitely_allergic << value
	}
	return all_ingredients.len - intersect(all_ingredients, definitely_allergic).len
}

fn part2(possible_ingredients map[string][]string) string {
	mut p_i_sorted := [][]string{}
	for key, value in possible_ingredients {
		p_i_sorted << [key]
		p_i_sorted.last() << value
	}
	mut p2 := [][]string{}
	p_i_sorted.sort(a.len < b.len)
	for i in 0..p_i_sorted.len {
		for j in i+1..p_i_sorted.len {
			p_i_sorted[j] = p_i_sorted[j].filter(it != p_i_sorted[i][1])
		}
		p2 << p_i_sorted[i]
		p_i_sorted[i+1..p_i_sorted.len].sort(a.len < b.len)
		// I would prefer having a heap that did this for me,
		// but idk if that exists in this language yet - and
		// I'm not gonna implement it myself for just one problem
	}
	// there's an OrderedMap, but idk how to use it, so I'm
	// sorting "tuples"
	p2.sort_with_compare(fn (a []string, b []string) bool {
		return a[0] > b[0]
	})
	return p2.map(it[1]).join(',')
}

fn main() {
	contents := os.read_file("input.txt") or {return} // don't care about failing tbh
	mut possible_ingredients := map[string][]string
	mut all_ingredients := []string{}
	for line in contents.split('\n') {
		bla := line.split('(')
		mut ingredients := bla[0].split(' ')
		ingredients.delete_last()
		allergens := bla[1].split('contains ')[1].split(' ').map(it.limit(it.len-1))
		all_ingredients << ingredients
		for allergen in allergens {
			if allergen in possible_ingredients {
				possible_ingredients[allergen] = intersect(possible_ingredients[allergen], ingredients)
			} else {
				possible_ingredients[allergen] = ingredients
			}
		}
	}
	println('part 1: ' + part1(all_ingredients, possible_ingredients).str())
	println('part 2: ' + part2(possible_ingredients))
}
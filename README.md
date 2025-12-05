# Advent of Code

[Advent of Code](https://adventofcode.com/) solutions implemented in the C programming language with the C23 standard in mind.

The solutions themselves are located in the `challenges/` directory under the respective year. \
They have a suffix of either `a` or `b` relative to the part of the challenge being solved.

## Dependencies

- `cmake` >= 3.21
- `gcc` >= 15 or equivalent for C23
- `sh`

The [uthash](https://troydhanson.github.io/uthash/) header only library is included as well. \
It's fetched and made available during configure time through CMake's `FetchContent` module.

## Quickstart

Build all of the challenges:

```sh
$ cmake -S . -DENABLE_TEST=ON -B build && cmake --build build
```

The `ENABLE_TEST` CMake variable enables the `ctest` test cases for each of the challenges.

To run a specific challenge:

```sh
(build) $  ctest -V -L <YYYY> -R <DAY><PART>
```

Make sure to replace `<YYYY>` and `<DAY><PART>`, respectively, with the desired year and challenge day along with the part suffix (`a` or `b`), e.g. `1a`.

To change the test cases' inputs, modify them in the `inputs/<YYYY>/` directory.

## License

See [LICENSE](./LICENSE).

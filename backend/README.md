## Install

```
make
```

## Usage


    int cannyThreshold = atoi(argv[2]);
    int accumulatorThreshold = atoi(argv[3]);

```
./out PATH_TO_INPUT_IMAGE CANNY_THRESHOLD ACCUMULATOR_THRESHOLD | runghc src/image.hs PATH_TO_INPUT_IMAGE
```

For example:

```
./out sample/sample1.jpg 100 30 | runghc src/image.hs ./out.jpg
```

## Requirements

I don't know.
You may need `ghc`.

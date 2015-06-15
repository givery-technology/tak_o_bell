## Install

```
make
```

Put your output file `out` in some directory in your `$PATH`.

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

curl 121.94.171.205
curl -F "image=@/home/me/local/src/spajam/tak_o_bell/backend/sample/sample0.jpg" 121.94.171.205/test

## Requirements


I don't know.
You may need `ghc`.

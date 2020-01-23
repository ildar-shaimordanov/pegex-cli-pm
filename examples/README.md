# Examples

## Scripts

* `pegex-forth` - Forth interpreter ([Pegex::Forth](https://github.com/ingydotnet/pegex-forth-pm) required)
* `pegex-json` - JSON parser ([Pegex::JSON](https://github.com/pegex-parser/pegex-json-pm) required)
* `pegex-toml` - TOML parser ([Pegex::TOML](https://github.com/pegex-parser/pegex-toml-pm) required)
* `pegex-calc` - simpliest arithmetic caclulator (borrowed from [Pegex](https://github.com/pegex-parser/pegex-pm) and slightly modified)

## Exacution

Run the scripts as follows:

```bash
examples/pegex-NAME FILENAME
```

or

```bash
echo "..." | example/pegex-NAME
```

where

* NAME - stands for second part of the script name
* FILENAME - name of one of the particular files from the same directory or something you'd like to test

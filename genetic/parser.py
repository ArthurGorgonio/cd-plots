import argparse
parser = argparse.ArgumentParser()
parser.add_argument(
    '--csv',
    type=str,
    nargs='+',
    help='Result CSV files to optimize the Friedman Test and his Posthoc',
    required=True
)
args = parser.parse_args()

print(f'All args {args.csv}\nLen of this is {len(args.csv)}')

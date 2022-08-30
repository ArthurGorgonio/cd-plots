from PIL import Image
import glob
import sys
import pathlib

# For DyDaSL CD plot the best values were 80 60 740 400

if len(sys.argv) > 1:
    pattern = '*' + sys.argv[1]
    box = tuple([int(sys.argv[2]), int(sys.argv[3]),
                int(sys.argv[4]), int(sys.argv[5])])
else:
    pattern = '*.png'
    box = (80, 0, 700, 480)

pathlib.Path('./converted').mkdir(parents=True, exist_ok=True)

images_to_filter = glob.glob(pattern)

for image in images_to_filter:
    original = Image.open(image)
    copy = original.crop(box)
    copy.save('./converted/'+image)

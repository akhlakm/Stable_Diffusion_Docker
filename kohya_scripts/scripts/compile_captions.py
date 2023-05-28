#!/usr/bin/env python

import os
import argparse

try:
    import yaml
except:
    print("Failed to import pyyaml. Please install: pip install pyyaml")
    exit(10)

parser = argparse.ArgumentParser()
parser.add_argument("img_dir", help="path to the image directory")
parser.add_argument("cap_list", help="path to the caption list yml file")
parser.add_argument("-c", "--compile", action='store_true', default=False)
parser.add_argument("-d", "--distribute", action='store_true', default=False)
parser.add_argument("-e", "--extension", default=".txt", help="extension of the caption files")
parser.add_argument("--debug", action='store_true', default=False)
args = parser.parse_args()

if args.compile and args.distribute:
    print("Specify either --compile or --distribute")
    exit(1)

if not args.compile and not args.distribute:
    print("Specify either --compile or --distribute")
    exit(1)

workdir = args.img_dir
listfile = args.cap_list
ext = args.extension

cpyml = {}

class NiceYaml(yaml.SafeDumper):
    # insert blank lines between top-level objects
    def write_line_break(self, data=None):
        super().write_line_break(data)

        if len(self.indents) == 1:
            super().write_line_break()

    def increase_indent(self, flow=False, indentless=False):
        return super(NiceYaml, self).increase_indent(flow, False)

if args.compile:
    for file in os.listdir(workdir):
        if file.endswith(".jpg") or file.endswith(".png"):
            basename = ".".join(file.split(".")[:-1])

            # image file
            imgfile = os.path.join(workdir, file)

            # caption file
            captfile = os.path.join(workdir, basename + ext)

            print(f"{basename}:")

            # check if caption exists
            if os.path.isfile(captfile):
                if args.debug:
                    print(f"\t{imgfile}\n\t{captfile}")
   
                with open(captfile) as cp:
                    caption = cp.read().strip()

                print(f"\t{caption}")
                cpyml[basename] = [caption]
            else:
                print(f"\tNot found: {imgfile}")

    with open(listfile, 'w+') as file:
        stream = yaml.dump(cpyml, Dumper=NiceYaml, default_flow_style = False)
        file.write(stream)

    print(f"All available captions compiled to file: {listfile}")

if args.distribute:
    cpyml = yaml.load(open(listfile, 'r'), Loader=yaml.FullLoader)

    for basename in cpyml:
        imgfile = os.path.join(workdir, basename + ".jpg")
        captfile = os.path.join(workdir, basename + ext)
        caption = cpyml[basename][0]
        print(f"{basename}:")
        if os.path.isfile(imgfile):
            if args.debug:
                print(f"\t{imgfile}\n\t{captfile}")
            print(f"\t{caption}")

            with open(captfile, 'w+') as cp:
                cp.write(caption)
            print(f"\t{basename + ext} ok")
        else:
            print(f"\tNot found: {imgfile}")

    print("\nAll caption files written.")


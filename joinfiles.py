import os

forbiddenlist = ["testbench", "masterfile","appendedfile", "vpp", "design_tb", "Data Memory Wires", "mips", 'ttb', "LIC", "py", "txt", ".md", ".vpp", "extra.txt"]
filelist = os.listdir()

destination = "dest.sv"
dest = open("appendedfile.sv", "w")


for fname in filelist:
    valid = True
    if os.path.isdir(fname):
        valid = False

    for fb in forbiddenlist:
        if fb in fname:
            valid = False
    if valid:
        with open(fname, 'r') as f:
            dest.writelines(f.readlines())

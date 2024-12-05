i = 0
while (1):
    x = input()
    if (len(x) < 9):
        continue
        
    if x == "oi":
        break

    comment = x.split(" ")[0]
    x = "".join(x[len(comment):].strip().split()[:-1])
    x = x.replace(" ", "")
    for idx in (0, 8, 16, 24,):
        bin = x[idx:idx+8]
        print(f"memoria[{i}] = 8'b{bin};  //{comment}")
        i += 1
    print()

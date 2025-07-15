from decimal import Decimal, getcontext
getcontext().prec = 50

SCALING_3_28 = Decimal(1 << 28)
MASKING_32BITS = (1 << 32) - 1

coefficients = [-Decimal("1") / Decimal(i + 1) for i in range(8)]

with open("coef_ln.hex", "w") as f:
    for coef in coefficients:
        f.write(f"{int(coef * SCALING_3_28) & MASKING_32BITS:08X}\n")
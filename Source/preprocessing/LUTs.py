# --------------------------------------------------------------------------------
# Ziggurat LUT Component Definitions
# --------------------------------------------------------------------------------
# N: Number of rectangles including the base strip
#    - Represents the total number of horizontal segments in the Ziggurat.
#    - Determines the number of iterations and the index range.
#
# V: Area of each rectangle (uniform across all layers)
#    - Calculated as the total area under the distribution divided by N.
#    - Used to determine consistent strip height or x-boundary.
#
# X[i]: Right boundary of rectangle i
#    - The x-coordinate of the right edge of the i-th rectangle.
#    - Used to generate candidate x-values via x = X[i] * U(-1, 1).
#
# F[i]: Value of the Gaussian PDF at X[i]
#    - F(X[i]) = exp(-X[i] ^ 2 / 2)
#    - Represents the height of the i-th rectangle.
#    - Used in wedge region rejection logic and probability comparisons.
#
# RATIO[i]: Ratio of adjacent x values or derived analytically
#    - Typically RATIO[i] = X[i - 1] / X[i]
#    - For i = 0 (tail), computed specially: X[N - 1] * F[N - 1] / V
#    - Used to accept or reject candidate values with fast comparison.
#
# R: Tail threshold (X[N - 1])
#    - Rightmost x boundary separating the tail region from the rest.
#    - Used in tail-specific sampling when rect_idx == 0.
#
# F[R]: F(X[N - 1])
#    - Value of the Gaussian at the tail boundary.
#    - Used to calculate base strip width and normalization.
# --------------------------------------------------------------------------------

from decimal import Decimal, getcontext
getcontext().prec = 50

# --------------------------------------------------------------------------------
#    n            r                     v             % efficiency
#    8   2.3383716982472524   1.7617364011877759E-1       88.93
#   16   2.6755367657376135   8.3989463747827300E-2       93.26
#   32   2.9613001212640193   4.0758744432219871E-2       96.09
#   64   3.2136576271588955   2.0024457157351700E-2       97.80
#  128   3.4426198558966519   9.9125630353364726E-3       98.78
#  256   3.6541528853610088   4.9286732339746571E-3       99.33
#  512   3.8520461503683916   2.4567663515413529E-3       99.64
# --------------------------------------------------------------------------------

N = 256 # <--- SELECT ZIGGURAT RESOLUTION

# --------------------------------------------------------------------------------

ONE = Decimal("1")

R, V = {
    8:   (Decimal("2.3383716982472524"), Decimal("1.7617364011877759E-1")),
    16:  (Decimal("2.6755367657376135"), Decimal("8.3989463747827300E-2")),
    32:  (Decimal("2.9613001212640193"), Decimal("4.0758744432219871E-2")),
    64:  (Decimal("3.2136576271588955"), Decimal("2.0024457157351700E-2")),
    128: (Decimal("3.4426198558966519"), Decimal("9.9125630353364726E-3")),
    256: (Decimal("3.6541528853610088"), Decimal("4.9286732339746571E-3")),
    512: (Decimal("3.8520461503683916"), Decimal("2.4567663515413529E-3"))
} [N]

INV_R = ONE / R

X = N * [None]
F = N * [None]
RATIO = N * [None]

CONST = [
    4294967294,
    4294967288,
    4294967280
]

SEED = [
    1457141477,
    1459202227,
    1457135268
]

# --------------------------------------------------------------------------------

TWO = Decimal("2")

def gaussian_pdf(x: Decimal) -> Decimal:
    return (-x ** TWO / TWO).exp()

def inv_gaussian_pdf(x: Decimal) -> Decimal:
    return (-TWO * x.ln()).sqrt()

# --------------------------------------------------------------------------------

X[-1], F[-1] = R, gaussian_pdf(R)
for i in range(N - 2, 0, -1):
    X[i] = inv_gaussian_pdf(V / X[i + 1] + F[i + 1])
    F[i] = gaussian_pdf(X[i])

# --------------------------------------------------------------------------------

X[0] = 0
RATIO[0] = X[-1] * F[-1] / V
for i in range(1, N):
    RATIO[i] = X[i - 1] / X[i]

# --------------------------------------------------------------------------------

X[0] = V / F[-1]
F[0] = gaussian_pdf(X[0])

# --------------------------------------------------------------------------------
# Bit precisions
# 18-bit : Q3.14  -> X
# 32-bit : Q3.28  -> F
# 32-bit : UQ4.28 -> RATIO
# --------------------------------------------------------------------------------

SCALING_3_14 = Decimal(1 << 14)
SCALING_3_28 = Decimal(1 << 28)
SCALING_3_32 = Decimal(1 << 32)
MASKING_18BITS = (1 << 18) - 1
MASKING_32BITS = (1 << 32) - 1
MASKING_36BITS = (1 << 36) - 1

def write_hex_file(file_name: str, data: list, bits32 = True) -> None:
    with open(file_name, "w") as f:
        for d in data:
            if bits32:
                f.write(f"{int(d * SCALING_3_28) & MASKING_32BITS:08X}\n")
            else:
                f.write(f"{int(d * SCALING_3_14) & MASKING_18BITS:05X}\n")

write_hex_file("rmost_coord.hex", X, bits32 = False)
write_hex_file("fn.hex", F)
write_hex_file("wedge_bound_ratio.hex", RATIO)
with open("ziggurat_config.vh", "w") as f:
    f.write(f"`define N {N}\n")
    f.write(f"`define LOG2N {(N - 1).bit_length()}\n")

with open("r.hex", "w") as f:
    f.write(f"{int(INV_R * SCALING_3_28) & MASKING_32BITS:08X}\n")
    f.write(f"{int(R * SCALING_3_32) & MASKING_36BITS:09X}\n")

with open("const.hex", "w") as f:
    for value in CONST:
        f.write(f"{value:08X}\n")

with open("seed.hex", "w") as f:
    for value in SEED:
        f.write(f"{value:08X}\n")

# --------------------------------------------------------------------------------
# Visualization
# --------------------------------------------------------------------------------

import matplotlib.pyplot as plt

FOUR = Decimal("4")
THOUSAND = Decimal("1000")

def plot_rectangle(xs, xe, ys, ye):
    plt.plot(
        [xs, xe, xe, xs, xs],
        [ye, ye, ys, ys, ye],
        color = "red", linestyle = "-", linewidth = 1
    )

gx = [FOUR * Decimal(i) / THOUSAND for i in range(1000)]
gy = [float(gaussian_pdf(gx[i])) for i in range(1000)]
gx = list(map(float, gx))
plt.plot(gx, gy, "k-", label = "Gaussian PDF")
 
x = list(map(float, X))
y = list(map(float, F))
plot_rectangle(0, x[1], y[1], 1)
for i in range(2, N):
    plot_rectangle(0, x[i], y[i], y[i - 1])

for i in range(1, 1000):
    plt.fill_between([gx[i - 1], gx[i]], 0, min(gy[i - 1], y[-1]), color = "gray", alpha = 0.25)

plt.xlim([0, 4])
plt.ylim([0, 1])
plt.title(f"Ziggurat Layer Visualization (N={N})")
plt.xlabel("x")
plt.ylabel("y")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig(f"Ziggurat Layer (N={N}).png", dpi = 300)
plt.show()
# --------------------------------------------------------------------------------
# T-URNG(Tausworthe Uniform Random Number Generator) Histogram Analysis
# --------------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt
assert int(np.__version__.split('.')[0]) >= 1, "NumPy >= 1.x required"
assert int(plt.__version__.split('.')[0]) >= 1, "matplotlib >= 1.x required"
# --------------------------------------------------------------------------------

N = 10 ** 4 # <--- SELECT NUMBER OF SAMPLES

# --------------------------------------------------------------------------------

THRESHOLD_8BIT = (1 << 8)
THRESHOLD_32BIT = (1 << 32)
MASKING_8BITS = (1 << 8) - 1
MASKING_32BITS = (1 << 32) - 1

CONST = np.array([
    0xFFFFFFFE,
    0xFFFFFFF8,
    0xFFFFFFF0
], dtype = np.uint32)

SEED = np.array([
    0x56BC7A45,
    0x56ED3DC3,
    0x56BB8D24
], dtype = np.uint32)

# --------------------------------------------------------------------------------

max_value = -float("INF")
min_value = float("INF")

# --------------------------------------------------------------------------------

bins = 100
bins_8bit = 256
frequency = np.zeros(bins, dtype = np.uint32)
frequency_ubits = np.zeros(bins_8bit, dtype = np.uint32)
frequency_lbits = np.zeros(bins_8bit, dtype = np.uint32)
for _ in range(N):
    s0, s1, s2 = SEED
    s0 = ((((s0 << 13) ^ s0) >> 19) ^ ((s0 & CONST[0]) << 12)) & MASKING_32BITS
    s1 = ((((s1 <<  2) ^ s1) >> 25) ^ ((s1 & CONST[1]) <<  4)) & MASKING_32BITS
    s2 = ((((s2 <<  3) ^ s2) >> 11) ^ ((s2 & CONST[2]) << 17)) & MASKING_32BITS
    urand = s0 ^ s1 ^ s2

    max_value = max(max_value, urand)
    min_value = min(min_value, urand)
    frequency[bins * int(urand) // THRESHOLD_32BIT] += 1

    SEED = [s0, s1, s2]

# --------------------------------------------------------------------------------
# Visualization
# --------------------------------------------------------------------------------

value = np.linspace(0, 1, bins)
plt.figure(figsize = (10, 4))
plt.bar(value, frequency / N, width = 1 / bins, color = 'cyan', edgecolor = 'black')
plt.text(0.83, 1.08, f"Min: {(24 - 2 * len(str(min_value)) - (len(str(min_value)) - 1) // 3) * ' '}{min_value:,}", transform = plt.gca().transAxes, fontsize = 10, verticalalignment = "top")
plt.text(0.83, 1.04, f"Max: {max_value:,}", transform = plt.gca().transAxes, fontsize = 10, verticalalignment = "top")
plt.title("T-URNG Histogram")
plt.xlabel("Normalized Value")
plt.ylabel("Normalized Frequency")
plt.grid(True)
plt.tight_layout()
plt.savefig("T-URNG Histogram.png", dpi = 300)
plt.close()
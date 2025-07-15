import numpy as np
import matplotlib.pyplot as plt
from decimal import Decimal, getcontext
getcontext().prec = 40

MINIMUM = Decimal("-4")
MAXIMUM = Decimal("4")
HUNDRED = Decimal("100")

bins = 200
width = (MAXIMUM - MINIMUM) / Decimal(bins)
frequency = bins * [0]

with open("Gaussian random numbers.txt", 'r') as f:
    for line in f:
        if line.strip():
            value = Decimal(line.strip())
            index = int((value - MINIMUM) / width)
            if index == MAXIMUM:
                index -= 1

            frequency[index] += 1

count = []
with open("Count.txt", 'r') as f:
    for line in f:
        if line.strip():
            count.append(Decimal(line))

value = np.linspace(-4, 4, bins)
plt.figure(figsize = (10, 4))
plt.bar(value, frequency, width = (MAXIMUM - MINIMUM) / bins, color = 'cyan', edgecolor = 'black')
plt.text(0.85, 1.05, f"Efficiency : {(count[0] - count[1]) / count[0] * HUNDRED:4.2f}%", transform = plt.gca().transAxes, fontsize = 10, verticalalignment = "top")
plt.title("GRNG Histogram")
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.grid(True)
plt.tight_layout()
plt.savefig("GRNG Histogram.png", dpi = 300)
plt.close()
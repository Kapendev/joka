import sys

n = int(sys.argv[1]) if len(sys.argv) > 1 else 0
if n == 0:
    print("Usage: array_append_remove <count>")
    exit(0)

joka_array = []
for i in range(n):
    joka_array.append(i)
while joka_array:
    joka_array.pop()


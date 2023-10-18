files = []
FILE_COUNT = 4
for i in range(FILE_COUNT):
    files.append(open(f'drag_log_{i+1}.txt', 'r'))

with open('drag_ratio.txt', 'w') as output:

    for line_idx, multi_line in enumerate(zip(*files)):
        ratio_sum = 0
        for line in multi_line:
            tokens = line.strip().split(';')
            angle = int(tokens[0])
            ratio = float(tokens[1])
            if angle != line_idx:
                raise ValueError(f'Different angles {angle} != {line_idx}')
            ratio_sum += ratio
        output.write(str(ratio_sum / FILE_COUNT) + '\n')
    
for file in files:
    file.close()

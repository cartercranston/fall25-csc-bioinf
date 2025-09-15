from python import os

def read_fasta(path: str, name: str):
    data: List[str] = []
    with open(str(os.path.join(path, name)), 'r') as f:
        for line in f.readlines():
            line = line.strip()
            if line[0] != '>':
                data.append(line)
    print(name, len(data), len(data[0]))
    # print('Sample:', data[0])
    return data


def read_data(path: str):
    short1: List[str] = read_fasta(path, "short_1.fasta")
    short2: List[str] = read_fasta(path, "short_2.fasta")
    long1: List[str] = read_fasta(path, "long.fasta")
    return short1, short2, long1

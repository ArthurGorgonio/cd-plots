def decoder(gene):
    individual = decoder_individual(gene)
    real_idx = [i - 1 for i in individual]

    return real_idx


def decoder_individual(gene):
    return [gene[i] + i for i in range(len(gene)) if gene[i]]

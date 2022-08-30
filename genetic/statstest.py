from scikit_posthocs import posthoc_nemenyi_friedman
from scipy.stats import friedmanchisquare


def run_friedman(data):
    return friedmanchisquare(*data.T.to_numpy()).pvalue


def run_posthoc(data):
    return posthoc_nemenyi_friedman(data)

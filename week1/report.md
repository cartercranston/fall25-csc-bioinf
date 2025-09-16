# Week 1 Report

## Automation

I do not have very much experience writing shell scripts. You can see from my ai.txt that I had trouble with the syntax for redirecting stdout and stderr to different variables, but I think I mostly understand it now: <code>$()</code> is a "command substitution" which returns the stdout of its subshell, and the <code>2>&4</code> tells the subshell to use the regular stderr, rather than creating its own.

The CI was the last thing I worked on, and the most difficult. Every challenge that I had faced when setting up my linux environment and my bash script has to be solved again for GitHub. It seems like it would be a really nice tool if I could get it to work.

## Codon

Making the Python code Codon-compatible was surprisingly easy. All it took to get nearly a 2x speed-up was removing the matplotlib import (since it was never used), importing a second version of the sys library under a different name, and then adding type hints to functions and variables. To find out which types to use, I added <code>print("Type of var:", type(var))</code> statements throughout the python code and then ran it.

## Reproducibility

Going into this assignment, there was a possibility that my N50 numbers would reproduce the NGA50s from Chen's report, but the numbers ended up being quite different. When I run my script, it outputs the following table:

Dataset         Language        Runtime         N50
-----------------------------------------------------
data1           python          0:17.16         9990
data1           codon           0:09.94         9990
data2           python          0:35.77         9992
data2           codon           0:18.32         9992
data3           python          0:37.81         9824
data3           codon           0:20.27         9824
data4           python          7:05.20         159255
data4           codon           3:56.49         159255

My numbers at least follow the same order as the originals; that is, data3 has the shortest contig, followed by data1, data2, and finally data4. Somehow, though, my contig for data4 is almost three times as long as Chen's.

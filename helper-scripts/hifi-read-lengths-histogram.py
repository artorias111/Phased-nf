#!/usr/bin/env python
# coding: utf-8

# First things first, we must first import the appropriate APIs

# In[ ]:


import numpy
import matplotlib.pyplot


# Next, we will extract all of the read lengths from the file and store them into an array.

# In[ ]:


read_lengths_file = open("hifi-read-lengths.txt")
handle = read_lengths_file.read()
read_lengths = numpy.array(handle.split("\n"))
read_lengths[read_lengths == ""] = '0'
integers = read_lengths.astype(int)


# With all data ready, we can use the matplotlib API to finally generate our histogram of all read lengths

# In[ ]:


matplotlib.pyplot.hist(integers, bins=500)
matplotlib.pyplot.ylabel("Frequency")
matplotlib.pyplot.xlabel("Read length")
matplotlib.pyplot.title("Histogram of Hifi Read Lengths")
matplotlib.pyplot.show()
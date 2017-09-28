# -*- coding: utf-8 -*-
"""
Created on Sat Jan  7 14:20:34 2017

@author: alessandra
"""
import numpy as np
import cv2

#load images
kitty = cv2.imread('compvision_udacity/ps0_python/input/ps0-1-a-1.png')
wolfy = cv2.imread('compvision_udacity/ps0_python/input/ps0-1-a-2.png')

#swap red and blue pixels image 1
kittyblue = kitty[:,:,0]
kittyred = kitty[:,:,2]
kittyswap = kitty.copy()
kittyswap[:,:,0] = kittyred
kittyswap[:,:,2] = kittyblue
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-2-a-1.png', kittyswap)

#monochrome green and red channel image 1
kittygreen = kitty[:,:,1]
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-2-b-1.png', kittygreen)
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-2-c-1.png', kittyred)

#monochrome green channel image 2
wolfygreen = wolfy[:,:,1]

#take 100x100 pixels from the center of monochrome image 1 and insert over center of image 2
kittycenter = np.array(kittygreen.shape)/2
kittychunk = kittygreen[
    int(kittycenter[0] - 50):int(kittycenter[0] + 50),
    int(kittycenter[1] - 50):int(kittycenter[1] + 50),
] 
wolfycenter = np.array(wolfygreen.shape)/2
wolfykitty = wolfygreen.copy()
wolfykitty[
    int(wolfycenter[0] - 50):int(wolfycenter[0] + 50),
    int(wolfycenter[1] - 50):int(wolfycenter[1] + 50),
] = kittychunk
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-3-a-1.png', wolfykitty)

#Arimethic and geometric operations
minvalue = kittygreen.min()
maxvalue = kittygreen.max()
meanvalue = kittygreen.mean()
stddev = kittygreen.std()
kittyarithmetic = cv2.absdiff(kittygreen, meanvalue)
kittyarithmetic = cv2.divide(kittyarithmetic, stddev)
kittyarithmetic = cv2.multiply(kittyarithmetic, 10)
kittyarithmetic = cv2.add(kittyarithmetic, stddev)
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-4-b-1.png', kittyarithmetic)

#Shift to the left by 2 pixels and subtract
M = np.float32([[1,0,2],[0,1,0]])
rows, cols = kittygreen.shape
kittyshift = cv2.warpAffine(kittygreen,M,(cols, rows)) 
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-4-c-1.png', kittyshift)
kittysubs = cv2.subtract(kittygreen, kittyshift)
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-4-d-1.png', kittysubs)

#adding noise to green and blue channel of image 1
im = np.zeros(kitty.shape, np.uint8)
gaussnoise = cv2.randn(im, (0, 1, 0), (0, 10, 0))
kittynoise_green = cv2.add(kitty, gaussnoise)
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-5-a-1.png', kittynoise_green)
im = np.zeros(kitty.shape, np.uint8)
gaussnoise = cv2.randn(im, (1, 0, 0), (10, 0, 0))
kittynoise_blue = cv2.add(kitty, gaussnoise)
cv2.imwrite('compvision_udacity/ps0_python/output/ps0-5-b-1.png', kittynoise_blue)


 







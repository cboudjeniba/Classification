
# coding: utf-8

# In[1]:


from __future__ import division
import cv2
import matplotlib
from matplotlib import colors
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd


# In[ ]:


#We create a data frame 
def compute_val(images):
    val_std = []
    val_mean = []
    val_min = []
    val_max = []
    for img in images: 
        im = cv2.cvtColor(img, cv2.COLOR_HSV2BGR) #convert in hsv  
        m,n,r = im.shape 
        arr = im.reshape(m*n, -1) 
        df = pd.DataFrame(arr, columns=['b', 'g', 'r'])
        
        val_std.append(df.std())
        val_mean.append(df.mean())
        val_min.append(df.min())
        val_max.append(df.max())
        
        
    return val_std, val_mean, val_min, val_max


# In[ ]:


### Training images


# In[ ]:


images = []
for i in range(500):
    images.append(cv2.imread('other'+str(i+1)+'.jpg'))
for j in range(500):
    images.append(cv2.imread('target'+str(j+1)+'.jpg'))


# In[ ]:


val_HSV_std, val_HSV_mean, val_HSV_min, val_HSV_max = compute_val(images)


# In[ ]:


np.savetxt('train_hsv_std.txt',val_HSV_std)
np.savetxt('train_hsv_mean.txt',val_HSV_mean)
np.savetxt('train_hsv_min.txt',val_HSV_min)
np.savetxt('train_hsv_max.txt',val_HSV_max)


# In[ ]:


## Testing images


# In[ ]:


images = []
for i in range(100):
    images.append(cv2.imread('other'+str(i+35133)+'.jpg'))
for j in range(100):
    images.append(cv2.imread('target'+str(j+32862)+'.jpg'))


# In[ ]:


val_HSV_std_test, val_HSV_mean_test, val_HSV_min_test, val_HSV_max_test = compute_val(images)


# In[ ]:


np.savetxt('test_hsv_std.txt',val_HSV_std_test)
np.savetxt('test_hsv_mean.txt',val_HSV_mean_test)
np.savetxt('test_hsv_min.txt',val_HSV_min_test)
np.savetxt('test_hsv_max.txt',val_HSV_max_test)


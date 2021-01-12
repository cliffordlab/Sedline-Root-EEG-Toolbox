#
#   createWordClouds.py
#
#   OVERVIEW:   
#       Reads txt file with words and generates corresponding wordclouds.
#
#   INPUT:    
#       NONE  
#
#   OUTPUT:
#       NONE
#
#   DEPENDENCIES & LIBRARIES:
#       NONE
#
#   REFERENCE: 
#       NONE
#
#	REPO:       
#       https://github.com/cliffordlab/Sedline-EEG_Analysis
#
#   ORIGINAL SOURCE AND AUTHORS:     
#       Pradyumna Byappanahalli Suresh
#       Last Modified: January 11th, 2021
#
#	COPYRIGHT (C) 2021
#   LICENSE:    
#       This software is offered freely and without warranty under 
#       the GNU (v3 or later) public license. See license file for
#       more information
#
#
# Convert it to dictionary with values and its occurences

from collections import Counter
import numpy as np
import matplotlib.pyplot as plt
from wordcloud import WordCloud

# Define various paths here
comorbidityFile = '/path/to/comorbidities.txt'
patientSurgicalProcedureFile =  '/path/to/primarySurgicalProcedure.txt'
imageSaveFolder = '/path/to/save/image/' 

textFile = open(comorbidityFile, "r")
comorbidities = textFile.readlines()
comorbidities = [x.strip() for x in comorbidities]
wordCloudDict=Counter(comorbidities)
wordcloud = WordCloud(width = 3000, height = 1600, background_color = None, colormap = "plasma", mode="RGBA").generate_from_frequencies(wordCloudDict)

plt.figure(figsize=(15,8), dpi = 300)
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis("off")
#plt.show()
plt.savefig(imageSaveFolder + 'comorbidities.png', bbox_inches='tight')
plt.close()
textFile.close()

textFile = open(patientSurgicalProcedureFile, "r")
patientSurgicalProcedures = textFile.readlines()
patientSurgicalProcedures = [x.strip() for x in patientSurgicalProcedures]
wordCloudDict=Counter(patientSurgicalProcedures)
wordcloud = WordCloud(width = 3000, height = 1600, background_color = None, colormap = "plasma", mode="RGBA", font_step=4).generate_from_frequencies(wordCloudDict)

plt.figure(figsize=(15,8), dpi=300)
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis("off")
#plt.show()
plt.savefig(imageSaveFolder + 'patientSurgicalProcedures.png', bbox_inches='tight')
plt.close()
textFile.close()
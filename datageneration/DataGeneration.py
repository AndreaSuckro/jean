# -*- coding: utf-8 -*-
"""
Creates dump test data for the ab test service with different distributions.
"""
import numpy as np
import matplotlib.pyplot as plt
import urllib2
import json



expName = 'Bachelor11'
bucketControll = 'a'
bucketTest = 'b'

#Jabba API calls
server = "http://localhost:8080/api/"
events_api = "v1/events/applications/"
assignments_api = "v1/assignments/applications/"

ct = {'Content-Type':'application/json'}


#################################
# Helper Functions for API-Calls
#################################

def recordEvent(userId,event):
    body = "{\"events\":[{\"name\":\""+event+"\"}]}"
    req = urllib2.Request(server+events_api+"qbo/experiments/"+expName+"/users/"+str(userId),body,ct)
    urllib2.urlopen(req)

#Impression is just an Event with a fixed value
def recordImpression(userId):
    recordEvent(userId,"IMPRESSION")

def getAssignment(experiment, userId):
    ans = json.loads(urllib2.urlopen(server+assignments_api+"qbo/experiments/"+experiment+"/users/"+str(userId)).read())  
    return ans['assignment']
    
def createExp():
    #TODO implement...
    return 0



##################################
# Gauss Distributions 
##################################
numUsers = 500

def getNormalDist(mu, sigma=0.1, display = 1):
    data = np.random.normal(mu,sigma,numUsers)
    if display:
        count, bins, ignored = plt.hist(data, 30, normed=True)
        plt.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) * np.exp( - (bins - mu)**2 / (2 * sigma**2) ),linewidth=2, color='r')
        plt.show()
    return data



###################################
# MAIN PROGRAMM
###################################

#get 2 Gauss Distributions varing in mu - they represent the user
sNormal = getNormalDist(0)
sDiff = getNormalDist(0.1)


for x in range(0,numUsers):
    userId = x+1
    ans = getAssignment(expName,userId)
    recordImpression(userId)
    if ans == 'a':
        if sNormal[x] > 0:
            recordEvent(userId,'check')
    else:
        if sDiff[x] > 0:
            recordEvent(userId,'check')





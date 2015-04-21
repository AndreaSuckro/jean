# -*- coding: utf-8 -*-
"""
Creates dump test data for the ab test service.
"""
import numpy as np
import matplotlib.pyplot as plt
import urllib2
import json

sigma = 0.1
muNorm = 0
muDiff = 0.4

numUsers = 600

expName = 'Bachelor4'

sNormal = np.random.normal(muNorm,sigma,numUsers)
count, bins, ignored = plt.hist(sNormal, 30, normed=True)
plt.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) * np.exp( - (bins - muNorm)**2 / (2 * sigma**2) ),linewidth=2, color='r')
plt.show()


sDiff = np.random.normal(muDiff,sigma,numUsers)
count, bins, ignored = plt.hist(sDiff, 30, normed=True)
plt.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) * np.exp( - (bins - muDiff)**2 / (2 * sigma**2) ),linewidth=2, color='g')
plt.show()


normalDic = {}
diffDic = {}

#for value in s set out http request
userId = 0
for val in sNormal:
    ans = json.loads(urllib2.urlopen("http://localhost:8080/api/v1/assignments/applications/qbo/experiments/"+expName+"/users/"+str(userId)).read())  
    userId+=1
    #store the information value, assignment, userId
    normalDic[val] = [ans["assignment"],userId]
    #record impression
    body = "{\"events\":[{\"name\":\"IMPRESSION\"}]}"
    req = urllib2.Request("http://localhost:8080/api/v1/events/applications/qbo/experiments/"+expName+"/users/"+str(userId),body,{'Content-Type':'application/json'})
    urllib2.urlopen(req)    
    #post event!
    if val > 0 :
        body = "{\"events\":[{\"name\":\"Bought\"}]}"
        urllib2.urlopen(req)
      
    
        
    
for val in sDiff:
    ans = json.loads(urllib2.urlopen("http://localhost:8080/api/v1/assignments/applications/qbo/experiments/"+expName+"/users/"+str(userId)).read())
    userId+=1
    diffDic[val] = [ans["assignment"],userId]
    body = "{\"events\":[{\"name\":\"IMPRESSION\"}]}"
    req = urllib2.Request("http://localhost:8080/api/v1/events/applications/qbo/experiments/"+expName+"/users/"+str(userId),body,{'Content-Type':'application/json'})
    urllib2.urlopen(req)
    if val > 0 :
        body = "{\"events\":[{\"name\":\"Bought\"}]}"
        req = urllib2.Request("http://localhost:8080/api/v1/events/applications/qbo/experiments/"+expName+"/users/"+str(userId),body,{'Content-Type':'application/json'})
        urllib2.urlopen(req)
      



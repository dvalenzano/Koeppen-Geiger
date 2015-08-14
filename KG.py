#Goal: to allow Koeppen-Geiger classification for the meteo-data based on the reference table from:
#http://www.hydrol-earth-syst-sci.net/11/1633/2007/hess-11-1633-2007.pdf
#all this data is analyzed in ipython notebook


# In[82]:

import math
import numpy as np


# In[257]:

data = open('/Volumes/group_dv/personal/DValenzano/month-by-month/Dec2014/meteo_data.txt', 'rU').read()


# In[258]:

stations = data.split('\n\n')[:-1]


# In[259]:

onestation = data.split('\n\n')[5].split('\n')


# In[260]:

onestation


# In[261]:

class getKG(object):

    def __init__(self, station):
        self.station = station.split('\n')
        self.locality = self.station[0].split()[0][1:-1]
        self.T = map(float, [i.split()[1:] for i in self.station if i[:2] == 'T '][0]) # annual temperatures, month by month
        self.P = map(float, [i.split()[1:] for i in self.station if i[:2] == 'mm'][0]) # annual precipitations, month by month
        self.Ttot = sum(self.T)
        self.Ptot = sum(self.P)
        self.MAT = np.mean(self.T) # mean annual temperature
#        self.MAP = np.mean(self.P) # mean annual precipitation
        self.MAP = self.Ptot
        self.Thot = max(self.T) # temperature of the hottest month
        self.Tcol = min(self.T) # temperature of the coldest mont
        self.Tmon10 = len([ i for i in self.T if i>10]) # n. of months where the temperature is above 10
        self.Pdry = min(self.P) # precipitation of the driest month
        self.T_ONDJFM = self.T[:4]+self.T[10:] # temperature from Oct to Mar
        self.T_AMJJAS = self.T[4:10] # temperature from Apr to Sep
        self.winter = map(int, ['9,10,11,0,1,2' if self.T_ONDJFM < self.T_AMJJAS else '3,4,5,6,7,8'][0].split(',')) # winter - defined by coldest 6 monts
        self.summer = map(int, ['9,10,11,0,1,2' if self.T_ONDJFM > self.T_AMJJAS else '3,4,5,6,7,8'][0].split(',')) # summer - defined by warmest 6 months
        self.Psdry = min([ self.P[i] for i in self.summer ]) # precipitation of the driest month in summer
        self.Pwdry = min([ self.P[i] for i in self.winter ]) # precipitation of the driest month in winter
        self.Pswet = max([ self.P[i] for i in self.summer ]) # precipitation of the wettest month in summer
        self.Pwwet = max([ self.P[i] for i in self.winter ]) # precipitation of the wettest month in winter
        self.WP = sum([ self.P[i] for i in self.winter ]) # total winter precipitations
        self.SP = sum([ self.P[i] for i in self.summer ]) # total summer precipitations
        
        self.lat = [ i.split()[2] for i in self.station if i[0] == 'L'][0]
        self.lon = [ i.split()[6] for i in self.station if i[0] == 'L'][0]
        
        self.Pthr = ''
        if self.WP >= 0.7*self.Ptot:
            self.Pthr = 2.0*self.MAT
        elif self.SP >= 0.7*self.Ptot:
            self.Pthr = 2.0*self.MAT+28.0
        else:
            self.Pthr = 2.0*self.MAT+14

            
################### THE FOLLOWING LOOP DEFINES THE KG CLASS FOR EACH STATION ###################            
            
        self.KG_class = ''
 
        if self.MAP < 10.0*self.Pthr:
            if self.MAP < 5.0*self.Pthr:
                if self.MAT>=18:
                    self.KG_class = 'BWh,Arid-Desert-Hot'
                else:
                    self.KG_class = 'BWk,Arid-Desert-Cold'                
                    
            elif self.MAP >= 5.0*self.Pthr:
                if self.MAT>=18:
                    self.KG_class = 'BSh,Arid-Steppe-Hot'
                else:
                    self.KG_class = 'BSk,Arid-Steppe-Cold'
                
        elif self.Tcol >= 18.0:
            if self.Pdry >= 60.0:
                self.KG_class = 'Af,Tropical Rainforest'

            else:
                if self.Pdry >= (100.0 - self.MAP/25.0):
                    self.KG_class = 'Am,Tropical Monsoon,'
                else:
                    self.KG_class = 'Am,Tropical Savannah'

        elif self.Thot > 10.0:
            
            if 0.0<self.Tcol<18.0: #temperate climate
            
                if self.Psdry <40.0 and self.Psdry < self.Pwwet/3.0:
                    if self.Thot >= 22.0:
                        self.KG_class = 'CSa,Temperate-DrySummer-HotSummer'
                    elif self.Tmon10 >= 4.0: 
                        self.KG_class = 'CSb,Temperate-DrySummer-WarmSummer'
                    elif 1.0<=self.Tmon10<4.0:
                        self.KG_class = 'CSc,Temperate-DrySummer-ColdSummer'
                
                elif self.Pwdry < self.Pswet/10.0:
                    if self.Thot >= 22.0:
                        self.KG_class = 'CWa,Temperate-DryWinter-HotSummer'
                    elif self.Tmon10 >= 4.0:
                        self.KG_class = 'CWb,Temperate-DryWinter-WarmSummer'
                    elif 1.0 <= self.Tmon10<4.0:
                        self.KG_class = 'CWc,Temperate-DryWinter-ColdSummer'
                
                else:
                    if self.Thot >= 22.0:
                        self.KG_class = 'CFa,Temperate-HotSummer'
                    elif self.Tmon10 >= 4:
                        self.KG_class = 'CFb,Temperate-WarmSummer'
                    elif 1.0<=self.Tmon10<4.0:
                        self.KG_class = 'CFc,Temperate-ColdSummer'
                
            elif self.Tcol <= 0.0: #cold climate
                
                if self.Psdry < 40.0 and self.Psdry < self.Pwwet/3.0:
                    if self.Thot >= 22.0:
                        self.KG_class = 'DSa,Cold-DrySummer-HotSummer'
                    elif self.Tmon10 >= 4.0:
                        self.KG_class = 'DSb,Cold-DrySummer-WarmSummer'
                    elif self.Tcold < -38.0:
                        self.KG_class = 'DSd,Cold-DrySummer-VeryColdWinter'
                    else:
                        self.KG_class = 'DSc,Cold-DrySummer-ColdSummer'
                     
                elif self.Pwdry < self.Pswet/10.0:
                    if self.Thot >= 22.0:
                        self.KG_class = 'DWa,Cold-DryWinter-HotSummer'
                    elif self.Tmon10 >= 4.0:
                        self.KG_class = 'DWb,Cold-DryWinter-WarmSummer'
                    elif self.Tcold < -38.0:
                        self.KG_class = 'DWd,Cold-DryWinter-VeryColdWinter'
                    else:
                        self.KG_class = 'DWc,Cold-DryWinter-ColdSummer'
                    
                else:
                    if self.Thot >= 22.0:
                        self.KG_class = 'DFa,Cold-HotSummer'
                    elif self.Tmon10 >= 4.0:
                        self.KG_class = 'DFb,Cold-WarmSummer'
                    elif self.Tcold < -38.0:
                        self.KG_class = 'DFd,Cold-VeryColdWinter'
                    else:
                        self.KG_class = 'DFc,Cold-ColdSummer'
            
        elif self.Thot < 10:
            if self.Thot>0:
                self.KG_class = 'ET,Polar-Tundra'
            else:
                self.KG_class = 'EF,Polar-Frost'
        
        else:
            self.KG_class = 'NA'
        
###################################### END OF LOOP ######################################


# In[262]:

prova = getKG(stations[1])
prova.KG_class


# In[263]:

ls = []
for i in stations:
    st = getKG(i)
    ls.append(st.locality +','+ st.lon +','+ st.lat + ','+st.KG_class)


# In[264]:

from sets import Set
c_classes  = Set([i.split(',')[-2] for i in ls ])
list(classes)


# In[265]:

Classes  = Set([i.split(',')[-1] for i in ls ])
list(Classes)


# In[266]:

c_values = ['8','1','13','11','5','3']
dv = dict(zip(c_classes, c_values))


# In[267]:

dv


# In[268]:

ls2 = [ i+','+dv[i.split(',')[3]]+'\n' for i in ls ]


# In[269]:

lz = 'locality,longitude,latitude,KG-class,KG-descr,KG_numcode\n'+','.join(ls2).replace('\n,','\n')


# In[270]:

z = open('/Volumes/group_dv/personal/DValenzano/month-by-month/Dec2014/KG_Rinput.csv', 'w')
z.write(lz)
z.close()

# I now compare the new file generated today, to that generated last December. 

lz_old = open('/Volumes/group_dv/personal/DValenzano/month-by-month/Dec2014/KG_Rinput.csv', 'rU').read()
lz == lz_old

# In[ ]:

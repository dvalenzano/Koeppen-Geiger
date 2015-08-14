#This code generates a contour map with precipitation and temperature KG values from the KG_Rinput.csv data file. 
#Additionally, it adds a map of Africa that shows where the zoomed in region is exactly.
setwd("/Volumes/group_dv/personal/DValenzano/month-by-month/Aug2015/")

library(ggmap)
climate <- read.csv("/Volumes/group_dv/personal/DValenzano/month-by-month/Aug2015/KG_Rinput_2.csv", header=T)
climate.kg <- data.frame(climate$longitude, climate$latitude, climate$KG_numcode)

names(climate.kg)[1] <- paste("longitude") 
names(climate.kg)[2] <- paste("latitude")
names(climate.kg)[3] <- paste("KG")
names(climate.kg)

tk_lon <- c(31.6, 32.45, 32.5)
tk_lat <- c(-21.7, -23.3, -24.6)
tk_strain <- c("GRZ", "MZM0703", "Soveia")
tk_pools <- data.frame(tk_lon, tk_lat, tk_strain)

grz <- c(lon=31.975708, lat=-21.7595)
grz.map <- get_map(location = grz, zoom=6, col="bw")
#grz.map <- get_map(location = grz, zoom=5, col="bw") #this is the option for the zoomed out plot
w <- ggmap(grz.map, extent = "normal", maprange=FALSE) %+% climate.kg +aes(x=longitude, y=latitude)+
  #  geom_density2d() +
  stat_density2d(aes(fill=..level.., alpha=..level..),
                 size=0.3, bins=13, geom='polygon')+
  scale_fill_gradient(low="dodgerblue", high="red3")+
  scale_alpha(range = c(0.18, 0.18), guide=FALSE)+
  theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
#  +geom_point(data = climate.kg, mapping = aes(longitude, latitude, colour=KG), 
#  +size=6, alpha=0.8, shape=20)
#  +scale_colour_gradient(low = 'dodgerblue', high = 'red3')

w + geom_point(aes(x = tk_lon, y = tk_lat, colour=tk_strain), data = tk_pools, 
               alpha = .8, colour="white", size=4, shape=20)+
  annotate('text', x=31.6,y=-21.3, label="GRZ", size = 4, col="white", alpha=1)
annotate('text', x=32.45,y=-22.9, label="MZM0703", size = 4, col="white", alpha=1)+
  annotate('text', x=32.5,y=-24.2, label="Soveia", size = 4, col="white", alpha=1) 

# uncomment next three lines for the "large" plot  
#  annotate('text', x=33.2,y=-21.65, label="GRZ", size = 4, col="white", alpha=1) +
#  annotate('text', x=35.3,y=-23.2, label="MZM0703", size = 4, col="white", alpha=1)+
#  annotate('text', x=34.6,y=-24.58, label="Soveia", size = 4, col="white", alpha=1) 

#par(plt = c(0.77, 0.97, 0.08, 0.32), new = TRUE)
par(plt = c(0.03, 0.2, 0.72, 0.97), new = TRUE)
# to make the little map, it's kind of more robust to extract the x-y coordinates of the lines and draw them separately
world<-map('world',fill=T,
           plot=F,       # this suppresses plotting
           interior=FALSE)

world.x<-world$x    	
world.y<-world$y

plot(0,0,type="n",
     ylim=c(-35,38),xlim=c(-18.5,52),
     xaxt="n",yaxt="n",xlab="",ylab="",bg="white")

# fill the box with white
polygon(c(-50,60,60,-50),c(-90,-90,60,60), lwd=2, col="white")

# draw the world outlines
lines(world.x,world.y,col="grey30")

# draw a teeny little box showing where the big map is sampled from
polygon(x=c(25,38,38,25),
        y=c(-28.5, -28.5,-14,-14),lwd=2, border="darkgreen")#col="white")  
#polygon(x=c(19,46,46,19),
#        y=c(-34.5, -34.5,-7.9,-7.9),lwd=2, border="darkgreen")#col="white")  
box()

grz.mapp <- get_map(location = grz, zoom=6, col="bw")
ggmap(grz.mapp, extent = "panel", maprange=FALSE) %+% climate.kg +aes(x=longitude, y=latitude)+
  geom_density2d()+
  scale_fill_gradient(low="blue", high="red")+
  scale_alpha(range = c(0.0, 0.5), guide=FALSE)+
  theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))+
  geom_point(data = climate.kg, mapping = aes(longitude, latitude, colour=KG), 
             size=6, alpha=0.8, shape=20) + 
  scale_colour_gradient(low = 'blue', high = 'red')+
  geom_point(aes(x = tk_lon, y = tk_lat, colour=tk_strain), data = tk_pools, 
             alpha = .8, colour="black", size=4, shape=20)+
  annotate('text', x=31.6,y=-21.3, label="GRZ", size = 7, col="black", alpha=1) +
  annotate('text', x=32.45,y=-23, label="MZM-0703", size = 7, col="black", alpha=1)+
  annotate('text', x=32.5,y=-24.33, label="Soveia", size = 7, col="black", alpha=1) 




save.image(file="KG_plots.RData") #available upon request to dvalenzano[at]age.mpg.de

names(climate.kg)[1] <- paste("longitude") 
names(climate.kg)[2] <- paste("latitude")
names(climate.kg)[3] <- paste("KG")
names(climate.kg)

tk_lon <- c(31.6, 32.45, 32.5)
tk_lat <- c(-21.7, -23.3, -24.6)
tk_strain <- c("GRZ", "MZM0703", "Soveia")
tk_pools <- data.frame(tk_lon, tk_lat, tk_strain)

tk2_lon <- c(31.6, 32.6001, 32.72175, 31.9312, 32.45, 32.5, 32.097817, 32.824417, 32.619883, 32.550917, 32.56425, 32.768617)
tk2_lat <- c(-21.7,-23.8852, -22.354833, -21.81555, -23.3, -24.6, -21.91685, -22.146717, -22.482067, -22.508283, -23.459133, -24.104883)
tk2_strain <- c("GRZ", "MZM0403", "MZM0410", "ZMZ1001", "MZM0703", "Soveia", "ZMZ1002", "ZMZ1003", "ZMZ1004", "ZMZ1005", "ZMZ1006", "ZMZ1007")
tk2_pools <- data.frame(tk2_lon, tk2_lat, tk2_strain)



grz <- c(lon=31.975708, lat=-21.7595)
grz.map <- get_map(location = grz, zoom=6, col="bw")
#grz.map <- get_map(location = grz, zoom=5, col="bw") #this is the option for the zoomed out plot
w <- ggmap(grz.map, extent = "normal", maprange=FALSE) %+% climate.kg +aes(x=longitude, y=latitude)+
  #  geom_density2d() +
  stat_density2d(aes(fill=..level.., alpha=..level..),
                 size=0.3, bins=13, geom='polygon')+
  scale_fill_gradient(low="dodgerblue", high="red3")+
  scale_alpha(range = c(0.18, 0.18), guide=FALSE)+
  theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
#  +geom_point(data = climate.kg, mapping = aes(longitude, latitude, colour=KG), 
#  +size=6, alpha=0.8, shape=20)
#  +scale_colour_gradient(low = 'dodgerblue', high = 'red3')

w + geom_point(aes(x = tk2_lon, y = tk2_lat, colour=tk2_strain), data = tk_pools, 
               alpha = .8, colour="white", size=4, shape=20)+
  annotate('text', x=31.6,y=-21.3, label="GRZ", size = 4, col="white", alpha=1)
#annotate('text', x=32.45,y=-22.9, label="MZM0703", size = 4, col="white", alpha=1)+
#  annotate('text', x=32.5,y=-24.2, label="Soveia", size = 4, col="white", alpha=1) 

# uncomment next three lines for the "large" plot  
#  annotate('text', x=33.2,y=-21.65, label="GRZ", size = 4, col="white", alpha=1) +
#  annotate('text', x=35.3,y=-23.2, label="MZM0703", size = 4, col="white", alpha=1)+
#  annotate('text', x=34.6,y=-24.58, label="Soveia", size = 4, col="white", alpha=1) 

#par(plt = c(0.77, 0.97, 0.08, 0.32), new = TRUE)
par(plt = c(0.03, 0.2, 0.72, 0.97), new = TRUE)
# to make the little map, it's kind of more robust to extract the x-y coordinates of the lines and draw them separately
world<-map('world',fill=T,
           plot=F,       # this suppresses plotting
           interior=FALSE)

world.x<-world$x      
world.y<-world$y

plot(0,0,type="n",
     ylim=c(-35,38),xlim=c(-18.5,52),
     xaxt="n",yaxt="n",xlab="",ylab="",bg="white")

# fill the box with white
polygon(c(-50,60,60,-50),c(-90,-90,60,60), lwd=2, col="white")

# draw the world outlines
lines(world.x,world.y,col="grey30")

# draw a teeny little box showing where the big map is sampled from
polygon(x=c(25,38,38,25),
        y=c(-28.5, -28.5,-14,-14),lwd=2, border="darkgreen")#col="white")  
#polygon(x=c(19,46,46,19),
#        y=c(-34.5, -34.5,-7.9,-7.9),lwd=2, border="darkgreen")#col="white")  
box()

save.image(file="KG_plots_TK.RData")


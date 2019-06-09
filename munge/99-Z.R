# VERSION HISTORY
z99.version = "1.0.0"
z99.ModDate = as.Date("2019-01-01")

# save RData image
save.image("readability.RData")

## DIAGNOSTIC PAGE
s.info = sessionInfo()
diagnostic = data.frame("Version","Date")
diagnostic[,1]=as.character(diagnostic[,1])
diagnostic[,2]=as.character(diagnostic[,2])
diagnostic.names = NULL

## MAGIC NUMBER ## Strings have not member names - Depends on sessionInfo()
ver =strsplit(s.info[["R.version"]][["version.string"]][1]," ")[[1]][3]
dat = as.character(substr( strsplit(s.info[["R.version"]][["version.string"]][1]," ")[[1]][4],2,11))
diagnostic = rbind(diagnostic,c(ver,dat))

ver = s.info[["platform"]][1]
dat = ""
diagnostic = rbind(diagnostic,c(ver,dat))
diagnostic.names = c(diagnostic.names,"R Version","platform")


if (length(s.info[["otherPkgs"]])> 0){
  for(i in 1:length(s.info[["otherPkgs"]])){
    ver = s.info[["otherPkgs"]][[i]]$Version
    dat = as.character(s.info[["otherPkgs"]][[i]]$Date)
    if(length(dat)==0){dat = " "}
    diagnostic = rbind(diagnostic,c(ver,dat))
    
    diagnostic.names = c(diagnostic.names,s.info[["otherPkgs"]][[i]]$Package)
  }
}

if (length(s.info[["loadedOnly"]])> 0){
  for(i in 1:length(s.info[["loadedOnly"]])){
    ver = s.info[["loadedOnly"]][[i]]$Version
    dat = as.character(s.info[["loadedOnly"]][[i]]$Date)
    if(length(dat)==0){dat = " "}
    diagnostic = rbind(diagnostic,c(ver,dat))
    
    diagnostic.names = c(diagnostic.names,s.info[["loadedOnly"]][[i]]$Package)
  }
}

#Add code diagnostic information
diagnostic = rbind(diagnostic,c(a00.version,as.character(a00.ModDate)))
diagnostic = rbind(diagnostic,c(a01.version,as.character(a01.ModDate)))
diagnostic = rbind(diagnostic,c(z99.version,as.character(z99.ModDate)))
diagnostic.names = c(diagnostic.names,"00-A","01-A","99-Z")

diagnostic = diagnostic[-1,]
colnames(diagnostic) = c("Version","Date")
rownames(diagnostic) = diagnostic.names

last.diagnostic = 1
diagnostic.rows = 19   #MAGIC NUMBER - TRIAL & ERROR

while (last.diagnostic <= nrow(diagnostic)){
  tmp.diagnostic = diagnostic[last.diagnostic:min(nrow(diagnostic),last.diagnostic+diagnostic.rows),]
  layout(c(1,1))
  # textplot(cbind(tmp.diagnostic),valign="top") 

  
  last.diagnostic = last.diagnostic + diagnostic.rows + 1
}

finish.time = Sys.time()
time = finish.time = start.time

# 2019.01.01 - v.1.0.0                                                          http://tinyurl.com/y54k8gsw
#  1st release                                                                  http://tinyurl.com/yx9w8vje
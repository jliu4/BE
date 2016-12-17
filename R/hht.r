##Copyright (C) 2015 Michael A. Halem for LENR Invest LLC
##Confidential and Trade Secret Information of LENR Invest LLC

CtoK = 273.15
is2000x1000=T
options(digits=8)
loadLibs<-function()
  {
    library("zoo")
    library('R.utils')
  }

loadLibs()

#################################
getzdata<-function(fname)
  {
    if (grepl("\\.csv$", fname))
        zz=read.zoo(fname, header=TRUE, sep=',', format = "%m/%d/%Y %T", tz="")
    if (grepl("\\.tsv$", fname))
        zz=read.zoo(fname, header=TRUE, sep="\t", format = "%m/%d/%Y %T", tz="")
    run = list()
    run$fname = fname
    run$zoo = zz
    printf("getzdata(%s) complete\n", fname)
    return(run)
  }


temps=c('Core.Reactor.Temp', 'Core.Gas.Out', 'Jacket.Gas.Out', 'Jacket.Gas.In',
      'Core.Gas.In', 'Inner.Core.Temp', 'Room.Temp')

powers=c('Core.Htr.Pow', 'Jckt.Htr.Pow', 'Q.kHz', 'Q.Occurred.'
#  'Q.Supply.Volt', 'Q.Cur' #never not zero!
  )

qjacket=c('Q.kHz', 'Q.Supply.Volt', 'Q.Cur', 'Q.Occurred.', 'Jckt.Htr.Pow',  'Jckt.Htr.Volt', 'Jckt.Htr.Cur', 'JACKET.GAS.HEATER.EN')

lowTemps=c('Room.Temp')

colorsblack= c('green', 'yellow', 'red', 'blue', 'cyan', 'violet', 'grey', 'black')
colorswhite= c('black', 'red', 'blue', 'green', 'violet', 'grey', 'brown', 'white')
colorsgrey2= c('black', 'red', 'blue', 'darkgreen', 'darkviolet', 'brown', 'gold4', 'cyan', 'grey')
colorsgrey= c('black', 'red', 'blue', 'darkgreen', 'darkviolet', 'brown', 'gold4',
  'cyan', 'white', 'yellow', 'pink', 'green', 'grey')
######################################################
zplot<-function(zlist, channels='Core.Reactor.Temp',
                x0=1, x1=dim(zlist$zoo)[1], ln='',
                colors=colorsgrey, rollavg=0, sep=F
                )
  {
    if (length(x0) > 1) {x1=x0[length(x0)]; x0=x0[1]}
    nBgColor= length(colors)
    allChannels = colnames(zlist$zoo)
    iChannels = match(channels, allChannels)
    missingChannels=is.na(iChannels)
    if (any(missingChannels))
      {
        printf("Warning, Missing Channel= %s\n", channels[missingChannels])
      }
    iChannels = na.omit(iChannels)
    zlist$zoo = zlist$zoo[,iChannels]
    zlist=zclean(zlist)   #clean
    nGrids = min(10, x1-x0)
    if ((x1-x0) <= 15) {nGrids=x1-x0}  
    xtop = round(c(x0,x0+c(1:(nGrids+1))*((x1-x0)/nGrids)))
    xtop = xtop[xtop<x1]
    xtop = c(xtop, x1)
    #print(xtop)
    tzoo = time(zlist$zoo)
    #iChannels =  match(channels, allChannels)
    par(new=F)
    par(mar=c(2,3*length(channels),2.0,1)+.5, ann=F)
 
    #par(cex=.75, xaxs='i')
    if (is2000x1000)
       {
         printf("executing for is2000x1000=T\n")
         par(cex=0.75, xaxs='i')
       }
     else
       {
         printf("executing for Laptop is2000x1000=F\n")
         par(ps=10, cex=0.5, xaxs='i')
       }
    par(fg=colors[1], bg=colors[nBgColor], col=colors[1], col.lab=colors[1], col.main=colors[1], col.sub=colors[1])
    printf("Plotting %s\n", zlist$fname)
    printf("Times:               %s -> %s   (%d:%d)\n", tzoo[x0], tzoo[x1], x0, x1)
    printf("%-18s %10s %10s  %10s %10s %10s\n","Channel","Min","Max","Median","Mean","StdDev");
    for (i in 1:length(iChannels))
      {
        if (all(is.na(zlist$zoo[x0:x1, i])))
          {
            printf("Warning: No valid data in channel %s\n", allChannels[iChannels[i]])
            next
          }
        szChannel = allChannels[iChannels[i]]
        ztype='l'
        if (grepl("\\.Htr\\.Pow", x=szChannel)
            || grepl("\\.Htr\\.Volt", x=szChannel)
            || grepl("\\.Htr\\.Cur", x=szChannel)
            )
          {
            ztype = 'p'
          }
        zlimits=NULL

        zydata= zlist$zoo[x0:x1, i]
        
        mysum=as.numeric(summary(as.numeric(zydata)))
        printf("%-18s %10.3f %10.3f  %10.3f %10.3f %10.3f\n",
               channels[i],mysum[1],mysum[6],mysum[3],mysum[4],sd(zydata));
        ##printf("channel=%s min=%f max=%f\n", channels[i], min(zydata), max(zydata))
        ##print(c(channel=channels[i], summary(zydata, digits=6), sd=sd(zydata)))
        ##print(c(channel=channels[i], summary(as.numeric(zydata), digits=6)))
        
        if (rollavg >1)
          zydata=rollmean(zydata, rollavg)
        zlimits = range(zydata, na.rm=T)
        #print(zydata)
        if (!sep && grepl('Occurred', szChannel)) {zlimits=c(0,10)}
        if (sep)
          {
            if (zlimits[2] == zlimits[1]) zlimits[2] = zlimits[1] + 1
            oldlimits = zlimits
            nChannels = length(iChannels)
            height = zlimits[2] - zlimits[1]
            
            zlimits[1] = oldlimits[1] - (i - 1) * height * (1 + 0.5/nChannels);
            zlimits[2] = zlimits[1] + height * (nChannels + 1.5/nChannels) 
            ##printf("i=%d n=%d height=%f old=%f %f new=%f %f\n",
            ##       i, nChannels, height, oldlimits[1], oldlimits[2], zlimits[1], zlimits[2])
          }

        plot(zydata, ann=F,
             screens=1, plot.type="single", col=colorRotator(i, colors[-nBgColor]), nc=1,
             xaxt='n', yaxt='n', ylab='', main="", type=ztype, log=ln, sub='', ylim=zlimits)
        par(new=T)
        if (is.null(zlimits))
          axis(2, col=colorRotator(i, colors[-nBgColor]),lwd=2, line=3*(i-1), padj=+0.9, col.axis=colors[1])
            else
          axis(2, col=colorRotator(i, colors[-nBgColor]),lwd=2, line=3*(i-1), padj=+0.9, col.axis=colors[1], ylim=zlimits)
            
        par(new=T)
        mtext(2, col = colors[1], text=colnames(zlist$zoo)[i],line=3*(i-1)+1.25)
        par(new=T)
      }
    axis(1, col=colors[1], at=tzoo[xtop], labels=xtop, col.axis=colors[1])
    axis(3, col=colors[1], at=tzoo[xtop], labels=
         format(tzoo[xtop], "%m-%d %H:%M:%S"),
         col.axis=colors[1],
         #hadj=.00*(tzoo[x1]-tzoo[z0])
         hadj=0.8
         )
    grid(col=colors[1], nx=nGrids, ny=10)
  }

showztime<-function(zlist, channels=colnames(zlist$zoo),  slice=1)
  {
    allChannels = colnames(zlist$zoo)
    iChannels =  match(channels, allChannels)
    #browser()
    t(as.matrix(zlist$zoo[slice, iChannels]))
  }

zfilter = list()
zfilter$Room.Temp=c(3,60)
zfilter$Core.Gas.Out=c(0,900)
zfilter$Core.Gas.In=c(0,900)
zfilter$Jacket.Gas.Out=c(0,900)
zfilter$Jacket.Gas.In=c(0,900)
zfilter$Core.Reactor.Temp=c(0,1200)
zfilter$Inner.Core.Temp=c(0,900)
zfilter$Pow.Out=c(0,1000)
zfilter$Jckt.Htr.Pow=c(0,500)
zfilter$Jckt.Htr.Pow.1=c(0,500)
zfilter$Core.Htr.Pow=c(0,800)
zfilter$Jckt.Htr.Volt=c(0,800)
zfilter$Jckt.Htr.Cur=c(0,5)
zfilter$Core.Htr.Cur=c(0, 100)
zfilter$Core.Htr.Volt=c(0, 800)
zfilter$Core.HX.Water.LPM=c(0,999)
zfilter$Jckt.Gas.Circ.LPM=c(0,999)
zfilter$Jckt.HX.Water.LPM=c(0,1)

zclean<-function(zlist, zzfilter=zfilter)
  {
    
    for(ifilter in names(zzfilter))
    {
      zminmax = zzfilter[[ifilter]]
      colnum = which(colnames(zlist$zoo) == ifilter)
      #if (ifilter == 'Jckt.HX.Water.LPM') browser()
      if (length(colnum)>0)
          {
            zbad = which(zlist$zoo[,colnum] < zminmax[1] | zlist$zoo[,colnum] > zminmax[2])
            #browser()
            if (length(zbad)>0)
              zlist$zoo[zbad, colnum] = NA
          }
    }
    zlist=zcleanJacket(zlist)
    return(zlist)
  }

zcleanJacket<-function(zlist)
{
  iEn=which(colnames(zlist$zoo) == 'JACKET.GAS.HEATER.EN')
  iPower = which(colnames(zlist$zoo) == 'Jckt.Htr.Pow')

  if (length(iEn>0) && length(iPower>0))
    {
      zbad = which(zlist$zoo[, iPower] <=0.5 & as.logical(zlist$zoo[, iEn]))
      zzero = which(!as.logical(zlist$zoo[, iEn]))

      zlist$zoo[zbad, iPower] = NA
      zlist$zoo[zzero, iPower] = 0
    }
  return(zlist)
  
}

vclean<-function(vdata, low, hi, badOmit=T)
{
  zbad = which(vdata<low | vdata>hi)
  vdata[zbad]=NA
  if (badOmit) vdata = na.omit(vdata)
  return(vdata)
}


###################

colorRotator<-function(i, colors)
{
  i = i - 1
  i = i %% length(colors)
  i = i + 1
  return(colors[i])
}
  
########################
##splice multiple zdata objects together

zsplice<-function(listOfLists)
{
  if (length(listOfLists)<2)
    {
      printf("Error, listOfLists < 2; Nothing to Combine\n")
      return(list())
    }
  
  zlist = list()
  zlist$fname = listOfLists[[1]]$fname
  zlist$zoo = listOfLists[[1]]$zoo
  printf("splicing with first fname=%s\n", zlist$fname)
  
  for (i in 2:length(listOfLists))
    {
      zlist2 = listOfLists[[i]]
      printf("splicing i=%d fname=%s\n", i, zlist2$fname)

      if ((length(colnames(zlist$zoo)) != length(colnames(zlist2$zoo))) ||
          !all(colnames(zlist$zoo) == colnames(zlist2$zoo)))
        {
          printf("zsplice() Warning-zoo object in listOfLists postion=%d has different columns, doing union for zoo=all\n", i);          
          columns = union(colnames(zlist$zoo), colnames(zlist2$zoo))
          mall = matrix(NA, nrow=dim(zlist$zoo)[1], ncol=length(columns))
          colnames(mall)=columns
          znew = zoo(x=mall, order.by = index(zlist$zoo))
          znew[, colnames(zlist$zoo)] = zlist$zoo
          zlist$zoo = znew
          
          mall = matrix(NA, nrow=dim(zlist2$zoo)[1], ncol=length(columns))
          colnames(mall)=columns
          znew = zoo(x=mall, order.by = index(zlist2$zoo))
          znew[, colnames(zlist2$zoo)] = zlist2$zoo
          zlist2$zoo = znew
        }
           
      zlist$fname = c(zlist$fname, zlist2$fname)
      zlist$zoo = rbind(zlist$zoo, zlist2$zoo)
    }
  return(zlist)
}

########################

zinterval<-function(zlist, x=NULL)
  {
    if (!is.numeric(x)) x=dim(zlist$zoo)[1]
    printf("%s t[1]=%s t[%d]=%s\n",
           zlist$fname,
           index(zlist$zoo)[1],
           x,
           index(zlist$zoo)[x]
           )
  }

##################################

stephanBoltzmanns=5.67e-8   #stephan-boltzmann constant


tBlackbody<-function(  #find time that the temperature is reached
                     Tt,       #the temperature at the time (input)
                     T0,       #starting temperature of the sphere
                     Tamb,       #ambient temperature of the "universe"
                     a=NULL,
                     A=4*pi*.01^2,  #surface area of the sphere (m^2
                     C=14.8,   #heat capacity of the sphere, joules/K
                     ttarget=NULL, #reference time -- thing to hit for solving for t
                     verbose=F
                     )
  {
    if (is.null(a))
      a = A * stephanBoltzmanns / C

    #printf("Tt=%f T0=%f Tamb=%f a=%g\n", Tt, T0, Tamb, a)
    
    t = -1/(4*Tamb^3*a) * (log(Tt - Tamb) - log(Tt + Tamb) - log(T0 - Tamb) + log(T0+ Tamb) + 2*(atan(T0/Tamb) - atan(Tt/Tamb)))
    if (is.numeric(ttarget))
      t = t - ttarget
    if (verbose) printf("Tt=%f T0=%f Tamb=%f a=%g t=%f\n", Tt, T0, Tamb, a, t)
    return(t)
  }


TBlackbody<-function(  #find time that the temperature is reached
                     t,       #the temperature at the time (input)
                     T0,       #starting temperature of the sphere
                     Tamb,       #ambient temperature of the "universe"
                     a=NULL,
                     A=4*pi*.01^2,  #surface area of the sphere (m^2
                     C=14.8   #heat capacity of the sphere, joules/K
                   )
{

  if (!is.numeric(a))
    a = A * stephanBoltzmanns / C

  values = numeric()
  
  for (tt in t)
    {
      solution = uniroot(f=tBlackbody, interval=c(Tamb+1e-9, T0), T0=T0, Tamb=Tamb, ttarget=tt)
      values = c(values, solution$root)
    }
  
  return(values)
}


##################################

Texp<-function(
               t,   #input variable
               T0,  #starting temperature
               Tamb, #ambient temperature
               tau   #half-life
               )
{
  Tout = (T0 - Tamb) * exp(-t/tau) + Tamb
  return(Tout)

}
  
###################################

##nls2 -- try this as it seems to be more robust
fit<-function(ydata, xdata, algo='port', start=list(a1=100, a2=100, b1=-1e-3, b2=-1e-4, c=373))
  {
    
    results=nls(ydata ~ a1*exp(b1 *xdata) + a2*exp(b2 * xdata) + c,
      algorithm=algo,
      trace=T,
      start=start,
      upper=list(a1=2000, a2=2000, b1=-1e-7, b2=-1e-7, c=2000),
      lower=list(a1=-2000, a2=-2000, b1=-1, b2=-1, c=-2000),
      control=nls.control(maxiter=500, warnOnly=T, tol=1e-6, minFactor=2^(-14), printEval=T)
      )
    results$mymodel='fit'
    return(results)

  }

fitA1<-function(ydata, xdata, algo='port', start=list(a1=100, b1=-1e-3, b2=-1e-4, c=373))
  { #simplified with a SINGLE A1 but two time constants
    results=nls(ydata ~ a1 * exp(b1 *xdata) + a1 * exp(b2 * xdata) + c,
              algorithm=algo,
              trace=T,
              start=start,
              upper=list(a1=8.5, b1=-1e-7, b2=-1e-7, c=2000),
              lower=list(a1=0, b1=-1, b2=-1, c=0)
              )
    results$mymodel='fitA1'
    return(results)

  }

fitFlat<-function(ydata, xdata, algo='default', start=list(a1=0, a2=0, b1=0, b2=0, c=373))
  { #simplified with a SINGLE A1 but two time constants
    results=list()
    ydata = as.numeric(ydata)
    results$summary = c(summary(ydata, digits=6), sd=sd(ydata))
    results$mymodel='fitFlat'
    return(results)

  }


fitExp<-function(ydata, xdata, algo='port', start=list(a1=100, b1=-1e-3, c=373))
  {
    start = start[c('a1', 'b1', 'c')]
    results=nls(ydata ~ a1* exp(b1 *xdata) + c,
      algorithm=algo,
      trace=T,
      start=start,
      upper=list(a1=2000, b1=-1e-8, c=2000),
      lower=list(a1=-2000, b1=-1, c=-2000),
      control=nls.control(maxiter=200, tol=1e-5, warnOnly=T, minFactor=1/4096)
      )
    results$mymodel='fitExp'
    return(results)

  }

##########################################
fitBB<-function(tdata,  #seconds
                Tdata,  #degrees K
                algo='port', a=NULL, verbose=F)
  {
    A=4*pi*.01^2  #surface area of the sphere (m^2
    C=14.8   #heat capacity of the sphere, joules/K
    if (is.null(a))
      a = A*stephanBoltzmanns/C

    minAmb = min(Tdata)
    precision=1+10*.Machine$double.eps
    
    
    results=nls2(tdata ~ tBlackbody(Tdata, T0, Tamb, a, verbose=verbose),
      algorithm=algo,
      trace=T,
      start=list(T0=575+CtoK, Tamb=550+CtoK, a=a),
      lower=list(T0=minAmb*precision, Tamb=0+CtoK, a=1e-20),
      upper=list(T0=600+CtoK, Tamb=minAmb/precision, a=1e-7)
      , control=nls.control(printEval=T, warnOnly=F)
      )
    results$mymodel='fitBB'
    return(results)
  }

fitBlack<-function(ydata, xdata, algo='port')
  {
    A=4*pi*.01^2  #surface area of the sphere (m^2
    C=14.8   #heat capacity of the sphere, joules/K
    a = A*stephanBoltzmanns/C
    
    results=nls(ydata ~ TBlackbody(xdata, T0, Tamb),
      algorithm=algo,
      trace=T,
      start=list(T0=1000, Tamb=300),
      lower=list(T0=0, Tamb=0),
      upper=list(T0=2000, Tamb=2000)
      )
    results$mymodel='fitBlack'
    return(results)
  }

###############################################################

zanalyze<-function(zlist, points=NULL,
                   channels=c(Core.Reactor.Temp=1
                     ,Jacket.Gas.In=-.9, Core.Gas.In=-.1
                     #,Jacket.Gas.Out=-.75, Core.Gas.Out=-.085),
                     ),   #composite weights/differences of channels
                   run=T,
                   algo='port', colors=colorsgrey, mymodel=fit)
  {
    if (is.null(names(channels)))
      {
        printf("Error, no channel names: should be channels=c(Core.Reactor.Temp=1)\n")
        return(NULL)
      }
    z = list()
    z$fname = zlist$fname
    if (is.null(points))
      points = 1:dim(zlist$zoo)[1]
    #browser()
    z$points = points
    z$channels=channels
    z$t = index(zlist$zoo)[points]
    z$trange = range(z$t)
    z$t=as.numeric(z$t - z$t[1])  #convert to seconds
    z$xlim = range(z$t)
    if (length(channels)!=1)
      tmp = as.vector(zlist$zoo[points, names(channels)] %*% channels)
    else
      tmp = as.vector(zlist$zoo[points, names(channels)]) * channels[1]
    z$T=zoo(tmp, z$t)
    if (run==T && (length(names(channels))==1)) z$T=z$T+CtoK #Everything is in K, otherwise is deltas
    z$Trange = range(z$T)
    spread = z$Trange[2] - z$Trange[1]
    z$ylim = z$Trange
    ##graphics.off()
    nBgColor= length(colors)
    par(new=F)
    par(mar=c(4.5,4.5,2,2), ann=T)
    #par(cex=0.9, xaxs='i')
    if (is2000x1000)
      {
        printf("executing for is2000x1000=T\n")
        par(cex=0.9, xaxs='i')
      }
    else
      {
        printf("executing for is2000x1000=F\n")
        par(ps=10, cex=0.75, xaxs='i')
      }
    par(fg=colors[1], bg=colors[nBgColor], col=colors[1], col.lab=colors[1], col.main=colors[1], col.sub=colors[1])
    szylab = paste(paste(channels, names(channels), collapse="  "), "(Degrees K)", collapse='')
    plot(z$t, z$T, xlim=z$xlim, ylim=z$ylim,
         ylab=szylab, xlab="Seconds",
         main=sprintf("%s t0=%s dt=%d pts=%s->%d", z$fname, z$trange[1], max(z$t), min(points), max(points)) 
         )
    grid(col=colors[1], nx=20, ny=10)
    
    printf("fname=%s\n\tpoints=%d:%d n=%d\n\ttimes=%s %s secs=%d\n\tT=%f %f\nChannels:\n",
           z$fname, min(points), max(points),length(points),
           z$trange[1], z$trange[2], max(z$t), min(z$T), max(z$T))
    printf("%s=%f ", names(channels), channels)
    printf("\n");
    
    if (run==T)
      {
        a1 = spread * sign(as.numeric(z$T[1]) - as.numeric(z$T[length(z$T)]))
        start = list(a1 = a1, a2=0.5*a1, b1=-1e-3,  b2=-1e-4, c=mean(z$T))
        print(unlist(start))
        z$fit = mymodel(ydata=z$T, xdata=z$t, algo=algo,
          start=start)

        mysummary = z$fit$summary
        ##browser()
        if (z$fit$mymodel != 'fitFlat') mysummary=summary(z$fit)
        print(mysummary)
        szmysummary = capture.output(mysummary)
        if (z$fit$mymodel == 'fitFlat')
          szmysummary=sprintf("%s = %f", names(mysummary), mysummary) 

        par(new=T, ann=F)
        if (z$fit$mymodel != 'fitFlat')
          plot(z$t, y=fitted(z$fit, z$t), xlim=z$xlim, ylim=z$ylim,
             xaxt='n', yaxt='n', col='red', type='l')
        else
           plot(x=z$xlim, y=c(mysummary[4], mysummary[4]), xlim=z$xlim, ylim=z$ylim,
             xaxt='n', yaxt='n', col='red', type='l')        
        par(new=T)
        szLegend1 = sprintf("points=%d:%d n=%d secs=%d\n",
          min(points), max(points), length(points), max(z$t))
        szLegend2 = szmysummary
        szLegend = sprintf("%s%s", szLegend1, szLegend2)
    
       
        legend(x="right", legend=szLegend2, text.font=2)
      }
    splitname=unlist(strsplit(z$fname, '/'));
    
    z$fplot = sprintf("fit_%s_%s.png", tolower(splitname[1]), format(z$trange[1], "%y%m%d_%H%M"))
    return(z)
  }

############################

zanapow<-function(zlist, points, low=0, hi=120)
  {
    vdata = zlist$zoo[points, 'Core.Htr.Pow']
    vdata = vclean(vdata, low=low, hi=hi)
    plot(zlist$zoo[points, 'Core.Htr.Pow'], ylim=c(low, hi), type='p')
    #mu = mean(vdata)
    #sigma = sd(vdata)
    #printf("mean=%f std=%f\n", mu, sigma)
    vdata=as.numeric(vdata)
    mysummary=c(summary(vdata, digits=5), sd=sd(vdata))
    print(mysummary)
  }

############################

######################################
getzdatalist<-function(batch=1)
  {
    zdata=list()

    if (batch==1)
      files = c(
        "Berkeley/2015-02-24/2015-02-24_day-01.csv",
        "Berkeley/2015-02-24/2015-02-24_day-02.csv",
        "Berkeley/2015-02-24/2015-02-24_day-03.csv",
        "Berkeley/2015-02-24/2015-02-24_day-04.csv",
        "Berkeley/2015-02-24/2015-02-24_day-05.csv",
        "Berkeley/2015-02-24/2015-02-24_day-06.csv",
        "Berkeley/2015-02-24/2015-02-24_day-07.csv",
        "Berkeley/2015-02-24/2015-02-24_day-08.csv",
        "Berkeley/2015-02-24/2015-02-24_day-09.csv",
        "Berkeley/2015-02-24/2015-02-24_day-10.csv",
        "Berkeley/2015-02-24/2015-02-24_day-11.csv"
        )

    if (batch==2)
      files=c(
        "Berkeley/2015-02-16/2015-01-30_day-14.csv",
        "Berkeley/2015-02-16/2015-01-30_day-15.csv",
        "Berkeley/2015-02-16/2015-01-30_day-16.csv",
        "Berkeley/2015-02-16/2015-02-18_day-01.csv",
        "Berkeley/2015-02-16/2015-02-18_day-02.csv"
        )

    if (batch==3)
      files=c(
        "Berkeley/2015-01-30/2015-01-30_day-01.csv",
        "Berkeley/2015-01-30/2015-01-30_day-02.csv",
        "Berkeley/2015-01-30/2015-01-30_day-03.csv",
        "Berkeley/2015-01-30/2015-01-30_day-04.csv",
        "Berkeley/2015-01-30/2015-01-30_day-05.csv",
        "Berkeley/2015-01-30/2015-01-30_day-06.csv",
        "Berkeley/2015-01-30/2015-01-30_day-07.csv",
        "Berkeley/2015-01-30/2015-01-30_day-08.csv",
        "Berkeley/2015-01-30/2015-01-30_day-08a.csv",
        "Berkeley/2015-01-30/2015-01-30_day-09.csv",
        "Berkeley/2015-01-30/2015-01-30_day-10.csv",
        "Berkeley/2015-01-30/2015-01-30_day-11.csv",
        "Berkeley/2015-01-30/2015-01-30_day-12.csv",
        "Berkeley/2015-01-30/2015-01-30_day-13.csv"
        )

    if (batch==5)
      files=c(
        "Berkeley/2015-01-15/2015-01-15_day-01.csv",
        "Berkeley/2015-01-15/2015-01-15_day-02.csv",
        "Berkeley/2015-01-15/2015-01-15_day-03.csv",
        "Berkeley/2015-01-15/2015-01-15_day-04.csv",
        "Berkeley/2015-01-15/2015-01-15_day-05.csv"
        )

    if (batch==6)
      files=c(
        "Berkeley/2014-12-02/2014-12-02_day-01.csv",
        "Berkeley/2014-12-02/2014-12-02_day-02.csv",
        "Berkeley/2014-12-02/2014-12-02_day-03.csv",
        "Berkeley/2014-12-02/2014-12-02_day-04.csv",
        "Berkeley/2014-12-02/2014-12-02_day-05.csv",
        "Berkeley/2014-12-02/2014-12-02_day-06.csv",
        "Berkeley/2014-12-02/2014-12-02_day-07.csv",
        "Berkeley/2014-12-02/2014-12-02_day-08.csv",
        "Berkeley/2014-12-02/2014-12-02_day-09.csv",
        "Berkeley/2014-12-02/2014-12-02_day-10.csv",
        "Berkeley/2014-12-02/2014-12-02_day-11.csv",
        "Berkeley/2014-12-02/2014-12-02_day-12.csv",
        "Berkeley/2014-12-02/2014-12-02_day-13.csv",
        "Berkeley/2014-12-02/2014-12-02_day-14.csv",
        "Berkeley/2014-12-02/2014-12-02_day-15.csv",
        "Berkeley/2014-12-02/2014-12-02_day-16.csv",
        "Berkeley/2014-12-02/2014-12-02_day-17.csv",
        "Berkeley/2014-12-02/2014-12-02_day-18.csv"
        )
    
    if (batch==7)
      files=c(  
        "Berkeley/2014-12-02/2014-12-02_day-19.csv",
        "Berkeley/2014-12-02/2014-12-02_day-20.csv",
        "Berkeley/2014-12-02/2014-12-02_day-21.csv",
        "Berkeley/2014-12-02/2014-12-02_day-22.csv",
        "Berkeley/2014-12-02/2014-12-02_day-23.csv",
        "Berkeley/2014-12-02/2014-12-02_day-24.csv",
        "Berkeley/2014-12-02/2014-12-02_day-25.csv",
        "Berkeley/2014-12-02/2014-12-02_day-26.csv",
        "Berkeley/2014-12-02/2014-12-02_day-27.csv",
        "Berkeley/2014-12-02/2014-12-02_day-28.csv",
        "Berkeley/2014-12-02/2014-12-02_day-29.csv",
        "Berkeley/2014-12-02/2014-12-02_day-30.csv",
        "Berkeley/2014-12-02/2014-12-02_day-31.csv",
        "Berkeley/2014-12-02/2014-12-02_day-32.csv",
        "Berkeley/2014-12-02/2014-12-02_day-33.csv",
        "Berkeley/2014-12-02/2014-12-02_day-34.csv",
        "Berkeley/2014-12-02/2014-12-02_day-35.csv",
        "Berkeley/2014-12-02/2014-12-02_day-36.csv"
        )
        
    if (batch==8)
      files=c(
        "Berkeley/2014-12-02/2014-12-02_day-37.csv",
        "Berkeley/2014-12-02/2014-12-02_day-38.csv",
        "Berkeley/2014-12-02/2014-12-02_day-39.csv",
        "Berkeley/2014-12-02/2014-12-02_day-40.csv",
        "Berkeley/2014-12-02/2014-12-02_day-41.csv",
        "Berkeley/2014-12-02/2014-12-02_day-42.csv",
        "Berkeley/2014-12-02/2014-12-02_day-43.csv",
        "Berkeley/2014-12-02/2014-12-02_day-44.csv",
        "Berkeley/2014-12-02/2014-12-02_day-45.csv",
        "Berkeley/2014-12-02/2014-12-02_day-46.csv",
        "Berkeley/2014-12-02/2014-12-02_day-47.csv",
        "Berkeley/2014-12-02/2014-12-02_day-48.csv",
        "Berkeley/2014-12-02/2014-12-02_day-49.csv",
        "Berkeley/2014-12-02/2014-12-02_day-50.csv",
        "Berkeley/2014-12-02/2014-12-02_day-51.csv",
        "Berkeley/2014-12-02/2014-12-02_day-52.csv",
        "Berkeley/2014-12-02/2014-12-02_day-53.csv"
        )

    if (batch==50)
      files=c(
        "Berkeley/2014-12-02/2014-12-02_day-46.csv",
        "Berkeley/2014-12-02/2014-12-02_day-47.csv",
        "Berkeley/2014-12-02/2014-12-02_day-48.csv",
        "Berkeley/2014-12-02/2014-12-02_day-49.csv",
        "Berkeley/2014-12-02/2014-12-02_day-50.csv",
        "Berkeley/2014-12-02/2014-12-02_day-51.csv",
        "Berkeley/2014-12-02/2014-12-02_day-52.csv"
        )
    
    
    if (batch == 9) #I believe this is the Berkeley "proof"
      files=c(
        "Berkeley/2014-12-02/2014-12-02_day-33.csv",
        "Berkeley/2014-12-02/2014-12-02_day-34.csv",
        "Berkeley/2014-12-02/2014-12-02_day-35.csv",
        "Berkeley/2014-12-02/2014-12-02_day-36.csv",
        "Berkeley/2014-12-02/2014-12-02_day-37.csv",
        "Berkeley/2014-12-02/2014-12-02_day-38.csv",
        "Berkeley/2014-12-02/2014-12-02_day-39.csv",
        "Berkeley/2014-12-02/2014-12-02_day-40.csv",
        "Berkeley/2014-12-02/2014-12-02_day-41.csv",
        "Berkeley/2014-12-02/2014-12-02_day-42.csv",
        "Berkeley/2014-12-02/2014-12-02_day-43.csv",
        "Berkeley/2014-12-02/2014-12-02_day-44.csv",
        "Berkeley/2014-12-02/2014-12-02_day-45.csv",
        "Berkeley/2014-12-02/2014-12-02_day-46.csv",
        "Berkeley/2014-12-02/2014-12-02_day-47.csv"
        )


    if (batch==12)
      files=c(
        "SRI/2015-01-30/2015-1-30_day-13a.csv",
        "SRI/2015-01-30/2015-1-30_day-13b.csv",
        "SRI/2015-01-30/2015-1-30_day-14.csv",
        "SRI/2015-01-30/2015-1-30_day-15.csv",
        "SRI/2015-01-30/2015-1-30_day-16.csv",
        "SRI/2015-01-30/2015-1-30_day-17.csv",
        "SRI/2015-01-30/2015-1-30_day-18.csv",
        "SRI/2015-01-30/2015-1-30_day-19.csv",
        "SRI/2015-01-30/2015-1-30_day-20.csv",
        "SRI/2015-01-30/2015-1-30_day-21.csv",
        "SRI/2015-01-30/2015-1-30_day-22.csv"
        )        

  
    if (batch==10)  # Q-Pulse calibration at SRI
      files=c(
        "SRI/2015-01-30/2015-1-30_day-01.csv",
        "SRI/2015-01-30/2015-1-30_day-02.csv",
        "SRI/2015-01-30/2015-1-30_day-03.csv",
        "SRI/2015-01-30/2015-1-30_day-04.csv",
        "SRI/2015-01-30/2015-1-30_day-05.csv",
        "SRI/2015-01-30/2015-1-30_day-06.csv",
        "SRI/2015-01-30/2015-1-30_day-07.csv",
        "SRI/2015-01-30/2015-1-30_day-08.csv",
        "SRI/2015-01-30/2015-1-30_day-09.csv"
       )

      if (batch==11)  # Q-Pulse calibration at SRI
      files=c(
        "SRI/2015-01-30/2015-1-30_day-08.csv",
        "SRI/2015-01-30/2015-1-30_day-09.csv",
        "SRI/2015-01-30/2015-1-30_day-10.csv",
        "SRI/2015-01-30/2015-1-30_day-11.csv",
        "SRI/2015-01-30/2015-1-30_day-12.csv",
        "SRI/2015-01-30/2015-1-30_day-13a.csv",
        "SRI/2015-01-30/2015-1-30_day-13b.csv",
        "SRI/2015-01-30/2015-1-30_day-14.csv",
        "SRI/2015-01-30/2015-1-30_day-15.csv",
        "SRI/2015-01-30/2015-1-30_day-16.csv",
        "SRI/2015-01-30/2015-1-30_day-17.csv",
        "SRI/2015-01-30/2015-1-30_day-18.csv"
        )

    if (batch==20)
      files=c(
        "SRI/2015-01-30/2015-1-30_day-18.csv",
        "SRI/2015-01-30/2015-1-30_day-19.csv",
        "SRI/2015-01-30/2015-1-30_day-20.csv",
        "SRI/2015-01-30/2015-1-30_day-21.csv",
        "SRI/2015-01-30/2015-1-30_day-22.csv",
        "SRI/2015-01-30/2015-1-30_day-23.csv",
        "SRI/2015-01-30/2015-1-30_day-24.csv",
        "SRI/2015-01-30/2015-1-30_day-25.csv",
        "SRI/2015-01-30/2015-1-30_day-26.csv",
        "SRI/2015-01-30/2015-1-30_day-27.csv",
        "SRI/2015-01-30/2015-1-30_day-28.csv",
        "SRI/2015-01-30/2015-1-30_day-29.csv",
        "SRI/2015-01-30/2015-1-30_day-30.csv",
        "SRI/2015-01-30/2015-1-30_day-31.csv",
        "SRI/2015-01-30/2015-1-30_day-32.csv",
        "SRI/2015-01-30/2015-1-30_day-33.csv"
        )        
    if (batch==220) #qpulse calibration
      files=c(
        "SRI/2015-01-30/2015-1-30_day-14.csv",
        "SRI/2015-01-30/2015-1-30_day-15.csv",
        "SRI/2015-01-30/2015-1-30_day-16.csv",
        "SRI/2015-01-30/2015-1-30_day-17.csv",
        "SRI/2015-01-30/2015-1-30_day-18.csv",
        "SRI/2015-01-30/2015-1-30_day-19.csv",
        "SRI/2015-01-30/2015-1-30_day-20.csv",
        "SRI/2015-01-30/2015-1-30_day-21.csv",
        "SRI/2015-01-30/2015-1-30_day-22.csv",
        "SRI/2015-01-30/2015-1-30_day-23.csv",
        "SRI/2015-01-30/2015-1-30_day-24.csv",
        "SRI/2015-01-30/2015-1-30_day-25.csv",
        "SRI/2015-01-30/2015-1-30_day-26.csv",
        "SRI/2015-01-30/2015-1-30_day-27.csv",
        "SRI/2015-01-30/2015-1-30_day-28.csv",
        "SRI/2015-01-30/2015-1-30_day-29.csv",
        "SRI/2015-01-30/2015-1-30_day-30.csv"
        )        

    if (batch == 99)
      files=c(
        "SRI/2015-01-30/2015-1-30_day-01.csv",
        "SRI/2015-01-30/2015-1-30_day-02.csv",
        "SRI/2015-01-30/2015-1-30_day-03.csv",
        "SRI/2015-01-30/2015-1-30_day-04.csv",
        "SRI/2015-01-30/2015-1-30_day-05.csv",
        "SRI/2015-01-30/2015-1-30_day-06.csv",
        "SRI/2015-01-30/2015-1-30_day-07.csv",
        "SRI/2015-01-30/2015-1-30_day-08.csv",
        "SRI/2015-01-30/2015-1-30_day-09.csv",
        "SRI/2015-01-30/2015-1-30_day-10.csv",
        "SRI/2015-01-30/2015-1-30_day-11.csv",
        "SRI/2015-01-30/2015-1-30_day-12.csv",
        "SRI/2015-01-30/2015-1-30_day-13a.csv",
        "SRI/2015-01-30/2015-1-30_day-13b.csv",
        "SRI/2015-01-30/2015-1-30_day-14.csv",
        "SRI/2015-01-30/2015-1-30_day-15.csv",             
        "SRI/2015-01-30/2015-1-30_day-16.csv",             
        "SRI/2015-01-30/2015-1-30_day-17.csv",             
        "SRI/2015-01-30/2015-1-30_day-18.csv"
        )

    if (batch == 2201) ##mini Qpulse calibration
      files = c(
        "SRI/2015-01-30/2015-1-30_day-15.csv",
        "SRI/2015-01-30/2015-1-30_day-16.csv",
        "SRI/2015-01-30/2015-1-30_day-17.csv",
        "SRI/2015-01-30/2015-1-30_day-18.csv",
        "SRI/2015-01-30/2015-1-30_day-19.csv",
        "SRI/2015-01-30/2015-1-30_day-20.csv",
        "SRI/2015-01-30/2015-1-30_day-21.csv"
        )

    if (batch == 303) ##mini Qpulse calibration
      files = c(
        "SRI/2015-03-03/2015-03-03_day-14.csv",
        "SRI/2015-03-03/2015-03-03_day-15.csv",
        "SRI/2015-03-03/2015-03-03_day-16a.tsv",
        "SRI/2015-03-03/2015-03-03_day-16b.csv",
        "SRI/2015-03-03/2015-03-03_day-16c.csv"
        )

    if (batch == 421)
      files = c(
        "SRI/2015-04-21/2015-03-30_day-15_a.csv",
        "SRI/2015-04-21/2015-03-30_day-15_bb.csv",
        "SRI/2015-04-21/2015-03-30_day-15_c.csv",
        "SRI/2015-04-21/2015-03-30_day-16.csv",
        "SRI/2015-04-21/2015-03-30_day-17.csv",
        "SRI/2015-04-21/2015-03-30_day-18.csv",
        "SRI/2015-04-21/2015-03-30_day-19.csv",
        "SRI/2015-04-21/2015-03-30_day-20.csv",
        "SRI/2015-04-21/2015-03-30_day-21.csv",
        "SRI/2015-04-21/2015-03-30_day-22.csv",
        "SRI/2015-04-21/2015-03-30_day-23.csv",
        "SRI/2015-04-21/2015-03-30_day-24.csv",
        "SRI/2015-04-21/2015-03-30_day-25.csv"
        )
    
    
    for (i in 1:length(files))
      {
        d=sprintf("d%d", i)
        zdata[[d]] = getzdata(files[i])       
      }
    
    zdata$all = zsplice(zdata)
    return(zdata)
  }


##Copyright (C) 2015 Michael A. Halem for LENR Invest LLC
##Confidential and Trade Secret Information of LENR Invest LLC

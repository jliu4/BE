function cop = doGoogleModel(data,matfile,isDC)
 S = load(matfile);
 run_data = S.run_data;
 model=run_data.model;
 model1=run_data.model.model;

 param = S.run_data.model.model.Parameters;
 parameters = [param(:).Value];
 paramName =[param(:).Name];
 %{
   ca0 ca1 ca2 cb0 cb1 cb2 kas0 kas1 kas2 kab0 kab1 kab2 kbs0
   kbs1 kbs2 a10 a11 a12 a20 a21 a22
 %}
 kas0 = parameters(7);
 kas1 = parameters(8);
 kas2 = parameters(9);
 kbs0 = parameters(13);
 kbs1 = parameters(14);
 kbs2 = parameters(15); 
 a20 = parameters(19);
 a21 = parameters(20);
 a22 = parameters(21); 
 kas = kas0 + kas1.*data.CoreTemp + data.CoreTemp.*(kas2.*data.CoreTemp);
 kbs = kbs0 + kbs1.*data.InnerBlockTemp1 + data.InnerBlockTemp1.*(kbs2.*data.InnerBlockTemp1) ;
 pout = kas.*(data.CoreTemp-data.OuterBlockTemp1) +kbs.*(data.InnerBlockTemp1-data.OuterBlockTemp1);
 if isDC 
     p = data.QSupplyPower;
 else
     p = data.CoreQPower;
 end    
 pin = data.HeaterPower + p.*(a20 + a21.*data.CoreTemp + data.CoreTemp.*(a22.*data.CoreTemp));
 cop = pout./pin;
 
end
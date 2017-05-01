function P  = calculateAlignedPower(v2s, v3s,MM,zterm)
   
   deltaV = (MM(1:end-v2s,1)-MM(1+v2s:end,2));
   P1 = deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3);
   n1 = size(P1);
   P =mean(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3))/zterm;
end


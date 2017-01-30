function [PS,PE,PSF,PEF,MaxFluxOut] = ExtractPrimitives(Flux,mu,Rel,V1,Vf1,V2,Vf2,V3,Vf3,pnts1,pnts2,pnts3,lambda)
    cont = 1;
    PS(1) = 1;
    npts = numel(Flux);
    
    % Discover motion primitives using Equation (7)
    while PS(cont)<=npts
        Summ = Vf1(pnts1)/sqrt(V1(1,pnts1).^2+V1(2,pnts1).^2+V1(3,pnts1).^2)+...
               Vf2(pnts2)/sqrt(V2(1,pnts2).^2+V2(2,pnts2).^2+V2(3,pnts2).^2)+...
               Vf3(pnts3)/sqrt(V3(1,pnts3).^2+V3(2,pnts3).^2+V3(3,pnts3).^2);
        
        Curv = Flux(PS(cont):end)-Flux(PS(cont))-mu-lambda*Summ;
        pnt = find(Curv(2:end)<0&(Curv(1:end-1)>0),1,'first');
        if isempty(pnt)
            PE(cont) = npts;
            break;
        else
            PE(cont) = pnt+PS(cont);
        end
   
        if PE(cont)<npts
            PS(cont+1) = PE(cont)+1;
        else
            break
        end
        cont=cont+1;
    end

    cumFlux =  cumsum(Flux);
    MaxFluxOut = zeros(size(PS));
    for kk=1:numel(PS)
        MaxFluxOut(kk) = cumFlux(PE(kk))-cumFlux(PS(kk));
    end
    
    % Find frames corresponding to the primitives
    PSF = zeros(size(PS));
    PEF = zeros(size(PE));
    for jj=1:numel(PE)
        FrIndS = Rel(PS(jj),1);
        if FrIndS>0
            PSF(jj)=FrIndS;
        else
            indSp = find(Rel(1:PS(jj),1),1,'last'); 
            indSn = find(Rel(PS(jj):end,1),1,'first');
            if (indSn-PS(jj))<(PS(jj)-indSp)
                PSF(jj)=Rel(indSn+PS(jj)-1,1);
            else
                PSF(jj)=Rel(indSp,1);
            end
        end
        FrIndE = Rel(PE(jj),1);
        if FrIndE>0
            PEF(jj)=FrIndE;
        else
            indEp = find(Rel(1:PE(jj),1),1,'last');
            indEn = find(Rel(PE(jj):end,1),1,'first');
            if (indEn-PE(jj))<(PE(jj)-indEp)
                PEF(jj)= Rel(indEn+PE(jj)-1,1);
            else
                PEF(jj)= Rel(indEp,1);
            end
        end
    end
end
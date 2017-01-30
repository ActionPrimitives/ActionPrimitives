function  [pointsOn2] = findCurveCorrespondences(pointsOn1,RelCurv1,RelCurv2)

pointsOn2 = zeros(size(pointsOn1));
for kk=1:numel(pointsOn1)
    if pointsOn1(kk)==1
        pointsOn2(kk)=1;
    elseif pointsOn1(kk)==RelCurv1(end,1)
        pointsOn2(kk)=RelCurv2(end,1);
    else
        if RelCurv1(pointsOn1(kk),1)>0
            pointsOn2(kk) = find(RelCurv2(:,1)== RelCurv1(pointsOn1(kk),1),1,'first');
            continue
        end
        [indPrevFrOn1,~,PrevFrOn1] = find(RelCurv1(1:pointsOn1(kk),1),1,'last');
        [indNextFrOn1,~,NextFrOn1] = find(RelCurv1(pointsOn1(kk):end,1),1,'first');
        indNextFrOn1 = indNextFrOn1+pointsOn1(kk)-1;
        indPrevFrOn2 = find(RelCurv2(:,1)==PrevFrOn1,1,'first');
        indNextFrOn2 = find(RelCurv2(:,1)==NextFrOn1,1,'last');
        
        factor = (indNextFrOn2-indPrevFrOn2)/(indNextFrOn1-indPrevFrOn1);
        pointsOn2(kk) = round((pointsOn1(kk)-indPrevFrOn1)*factor)+indPrevFrOn2; 
        if kk==215
            disp('')
        end
    end
end

end
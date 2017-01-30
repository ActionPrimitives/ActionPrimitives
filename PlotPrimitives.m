function PlotPrimitives(Data,Start,Stop,PrimStart,PrimStop,GroupNames,flux,PrimStartFlux,PrimEndFlux)

    im = imread('Checker.gif').*12;
    points3D = Data.AbsolutePoses;
    GroupsN = cell(length(GroupNames)-1,1);
    flag = cell(length(GroupNames)-1,1);
    for kk=1:length(GroupNames)-1
        GroupsN{kk} = str2double(GroupNames{kk}(2));
        flag{kk} = 1;
    end

    Subject = Data.(GroupNames{1}).subject;
    Action = [Data.(GroupNames{1}).action];
    GroupsNumber = length(GroupNames)-1;
    conn = {9:11,[1,8:9],[9,15:17],[9,12:14],[1,5:7],1:4};

    Njoints = size(points3D{1},3);

    Col{1} = {'r','g','b','y','c','m',[.5 0 .5],[1 .5 0]};
    Col{2} = {[1 .5 0],[.5 0 .5],'m','c','y','b','g','r',[.7 .5 0]};
    groupnames = {'Head','Torso','Right Arm','Left Arm','Left Leg','Right Leg'};

    xplane = -0.2:0.2:0.6;
    yplane = -1:0.2:1;
    [XPlane,YPlane] = meshgrid(xplane,yplane);
    ZPlane = zeros(size(XPlane));

    for kk=1:size(PrimStart,2)
        PrimStartGroup = PrimStart{kk};
        PrimStopGroup = PrimStop{kk};
        for ii=1:length(PrimStartGroup)
            FramesGroup{kk}{ii} = PrimStartGroup(ii):PrimStopGroup(ii);
        end
    end

    step = 1;
    for ii=Start:step:Stop
        pose = zeros(3,Njoints);
        for jj=1:Njoints
            Rot(:,:,jj) = points3D{ii}(1:3,1:3,jj); 
            pose(:,jj) = points3D{ii}(1:3,4,jj)';
        end

        subplot(GroupsNumber,2,1:2:GroupsNumber+1)
        for ll=1:length(conn)
            h(ll) =plot3(pose(1,conn{ll}),pose(2,conn{ll}),pose(3,conn{ll}),'Color',[0.4,0.4,0.4],'LineWidth',3);
            hold on
            h(end+1) = scatter3(pose(1,conn{ll}),pose(2,conn{ll}),pose(3,conn{ll}),'MarkerEdgeColor',[0.4,0.4,0.4],'MarkerFaceColor',[0.4,0.4,0.4],'LineWidth',3);
            hold on
        end

        for NGroup = 1:length(FramesGroup)

            for jj=1:length(FramesGroup{NGroup})
                if ismember(ii,FramesGroup{NGroup}{jj})
                    h(end+1) = plot3(pose(1,conn{GroupsN{NGroup}}),pose(2,conn{GroupsN{NGroup}}),pose(3,conn{GroupsN{NGroup}}),'Color',Col{NGroup}{jj},'LineWidth',3);
                    h(end+1) = scatter3(pose(1,conn{GroupsN{NGroup}}),pose(2,conn{GroupsN{NGroup}}),pose(3,conn{GroupsN{NGroup}}),'MarkerEdgeColor',Col{NGroup}{jj},'MarkerFaceColor',Col{NGroup}{jj},'LineWidth',3);
                    if NGroup==1
                        cube(deg2rad(Rot(:,:,10))',pose(:,11)',[0.4 0.4 0.4],0.2,[0.4 0.4 0.4]);
                    end
                end
            end
        end

        title(sprintf('%s %s Frame %d',Subject,Action,ii),'FontName','Times New Roman');
        axis equal
        set(gca,'XLim',[-0.2,0.6],'YLim',[-1,1],'ZLim',[0,1.5],'FontName','Times New Roman')
        surface(XPlane,YPlane,ZPlane,'FaceColor','texturemap','CData',im2double(im));
        colormap([89,68,43;244,188,119]./255);
        shading flat
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        view(65,20)
        drawnow
        hold off

        for kk=1:GroupsNumber    
            subplot(GroupsNumber,2,kk*2)
            hold on
            if flag{kk}<=length(PrimStart{kk})
                if ii==PrimStart{kk}(flag{kk})
                    plot(PrimStartFlux{kk}(flag{kk}):PrimEndFlux{kk}(flag{kk}),flux{kk}(PrimStartFlux{kk}(flag{kk}):PrimEndFlux{kk}(flag{kk})),'Color',Col{kk}{flag{kk}}) 
                    if flag{kk}+1<=length(PrimStart{kk}) && PrimStart{kk}(flag{kk}) == PrimStart{kk}(flag{kk}+1)
                        plot(PrimStartFlux{kk}(flag{kk}+1):PrimEndFlux{kk}(flag{kk}+1),flux{kk}(PrimStartFlux{kk}(flag{kk}+1):PrimEndFlux{kk}(flag{kk}+1)),'Color',Col{kk}{flag{kk}+1}) 
                        flag{kk} = flag{kk}+2;
                    else
                        flag{kk} = flag{kk}+1;
                    end
                end
            end
            title(sprintf('%s - %s Flux',GroupNames{kk},groupnames{GroupsN{kk}}),'FontName','Times New Roman');
        end

    end

end

function cube(rotc,pos,col,alpha,Col)

% pos is the position of the head joint
% rot is the rotation in degree along x axis
% adjust for given rotation matrix
% col is the current color
% alpha is the transparency

%% FACES
fm = [1 2 6 5;
      2 3 7 6;
      3 4 8 7;
      4 1 5 8;
      1 2 3 4;
      5 6 7 8];

%% adjust for given rotation matrix
% phi = rot * pi/180;
% rotc = zeros(3,3);
% rotc(1,1) = 1;
% rotc(2,2) = cos(phi);
% rotc(2,3) = -sin(phi);
% rotc(3,2) = sin(phi);
% rotc(3,3) = cos(phi);

% Vertices
vm = ([0 0 0;
      1 0 0;
      1 1 0;
      0 1 0;
      0 0 1;
      1 0 1;
      1 1 1;
      0 1 1]-repmat(0.5,8,3))*3 *rotc+repmat(pos,8,1);
  
cm = repmat(col,8,1);
  
patch('Vertices',vm,'Faces',fm,'FaceVertexCData',cm,'FaceAlpha',alpha,'FaceColor',Col);
end
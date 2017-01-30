close all
load('Data')

% Parameters inferred from data scaling
mu{1} = 0.5;
mu{2} = 3.5;

% Parameters inferred from cumulative velocity
lambda{1} = 1;
lambda{2} = 3;

% Initialization
GroupsNumber = length(fieldnames(Data))-1;
GroupsNames = fieldnames(Data);

flux = cell(length(GroupsNumber),1);
PrimStartFlux = cell(length(GroupsNumber),1);
PrimEndFlux = cell(length(GroupsNumber),1);
MaxFlux = cell(length(GroupsNumber),1);
PrimitivesStart = cell(length(GroupsNumber),1);
PrimitivesStop = cell(length(GroupsNumber),1);

% For each group
for jj=1:GroupsNumber
    % Load data necessary to compute flux
    GroupData = Data.(GroupsNames{jj});
    iter = GroupData.iteration; 
    interv = GroupData.intervals;
    nmin = (iter-1)*interv*3+1;
    nmax = nmin+interv*3-1;

    nn = nmax-nmin+1;
    Vf1 = GroupData.rawdata.joint(1).VelF;
    Vf2 = GroupData.rawdata.joint(2).VelF;
    Vf3 = GroupData.rawdata.joint(3).VelF;

    Nnv1 = GroupData.rawdata.joint(1).Nnv;
    Nnv2 = GroupData.rawdata.joint(2).Nnv;
    Nnv3 = GroupData.rawdata.joint(3).Nnv;

    dencurve1 = GroupData.rawdata.joint(1).dencurve;
    dencurve2 = GroupData.rawdata.joint(2).dencurve;
    dencurve3 = GroupData.rawdata.joint(3).dencurve;

    dS1 = sqrt(dencurve1);
    dS2 = sqrt(dencurve2);
    dS3 = sqrt(dencurve3);

    Rel1 = GroupData.rawdata.joint(1).SurfInd;
    Rel2 = GroupData.rawdata.joint(2).SurfInd;
    Rel3 = GroupData.rawdata.joint(3).SurfInd;

    V1 = GroupData.rawdata.joint(1).velOnCurve;
    V2 = GroupData.rawdata.joint(2).velOnCurve;
    V3 = GroupData.rawdata.joint(3).velOnCurve;

    % Compute flux line integral
    Flux1 = sum(abs(Vf1.*Nnv1.*dS1),2);
    Flux2 = sum(abs(Vf2.*Nnv2.*dS2),2);
    Flux3 = sum(abs(Vf3.*Nnv3.*dS3),2);

    % Compute total Flux
    pnts1 = 1:length(Flux1);
    pnts2 = findCurveCorrespondences(pnts1,Rel1,Rel2);
    pnts3 = findCurveCorrespondences(pnts1,Rel1,Rel3);
    flux{jj} = Flux1+Flux2(pnts2)+Flux3(pnts3);

    % Discover primitives
    [PrimStartFlux{jj},PrimEndFlux{jj},PrimitivesStartAll,~,MaxFluxOut] = ExtractPrimitives(flux{jj},mu{jj},Rel1,V1,Vf1,V2,Vf2,V3,Vf3,pnts1,pnts2,pnts3,lambda{jj});
    PrimitivesStopAll = [PrimitivesStartAll(2:end)-1,nn/3];
    MaxFlux{jj} = MaxFluxOut;
    PrimitivesStart{jj} = PrimitivesStartAll + (nmin-1)/3;
    PrimitivesStop{jj} = PrimitivesStopAll + (nmin-1)/3;

    fprintf('%s: Found %d primitive(s)\n',GroupsNames{jj},numel(PrimitivesStartAll));
end

% Plot skeleton and flux for each group
figure('units','normalized','outerposition',[0 0 1 1])
for kk=1:GroupsNumber
    subplot(GroupsNumber,2,kk*2)
    plot(flux{kk},'Color',[.4 .4 .4])
    set(gca,'FontName','Times New Roman')
    title(sprintf('%s Flux',GroupsNames{kk}),'FontName','Times New Roman');
end
PlotPrimitives(Data,(iter-1)*interv+1,(iter)*interv,PrimitivesStart,PrimitivesStop,GroupsNames,flux,PrimStartFlux,PrimEndFlux)
     
clear



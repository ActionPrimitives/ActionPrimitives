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

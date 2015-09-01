function des = gcap_displayMni(posmm, voxsize)
%----------------------------------------------------------------------------------
% FORMAT ihb_MniSpace
%----------------------------------------------------------------------------------
%   22.10.01    Sergey Pakhomov
%   22.10.01    last modified
%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
% DB strcture
%----------------------------------------------------------------------------------
%------------------------------- 
% Grid specification parameters:
%------------------------------- 
% minX              - min X (mm)
% maxX              - max X (mm)
% voxX              - voxel size (mm) in X direction
% minY              - min Y (mm)
% maxY              - max Y (mm)
% voxY              - voxel size (mm) in Y direction
% minZ              - min Z (mm)
% maxZ              - max Z (mm)
% voxZ              - voxel size (mm) in Z direction
% nVoxX             - number of voxels in X direction
% nVoxY             - number of voxels in Y direction
% nVoxZ             - number of voxels in Z direction
%------------------------------- 
% Classification parameters:
%------------------------------- 
% numClass          - number of classification types
% cNames            - cNames{i}             - cell array of class names for i-th CT
% numClassSize      - numClassSize(i)       - number of classes for i-th CT
% indUnidentified   - indUnidentified(i)    - index of "indUnidentified" class for i-th CT
% volClass          - volClass{i}(j)        - number of voxels in class j for i-th CT
% 
% data              - N x numClass matrix of referencies; let
%                       x y z coordinates in mm (on the grid) and
%                       nx = (x-minX)/voxX
%                       ny = (y-minY)/voxY
%                       nz = (z-minZ)/voxZ
%                       ind = nz*nVoxX*nVoxY + ny*nVoxX + nx + 1
%                       data(ind, i) - index of the class for i-th CT in cNames{i} to
%                                      which (x y z) belongs, i.e.
%                                      cNames{i}{data(ind, i)} name of class for i-th CT
%----------------------------------------------------------------------------------
%----------------------------------------------------------------------------------
% Read options into (thr, showLabel) and data base into DB
%----------------------------------------------------------------------------------
[thr, showLabel] = gcap_MniSpaceGetOptions;
baseFileName = 'gcap_MniDataBase.cdb';
load(baseFileName, '-mat');
%----------------------------------------------------------------------------------
% Figures tags for windows created by SPM during call spm_getSPM
%----------------------------------------------------------------------------------
ihbdfl_spm_fig_Interactive = 'Interactive';
ihbdfl_spm_fig_SelFileWin = 'SelFileWin';
ihbdfl_spm_fig_ConMan = 'ConMan';
%----------------------------------------------------------------------------------
hFigInteractive = findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_Interactive);
hFigSelFileWin = findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_SelFileWin);
hFigConMan = findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_ConMan);
%----------------------------------------------------------------------------------
% Get SPM information
%----------------------------------------------------------------------------------
%[SPM,VOL,xX,xCon,xSDM] = spm_getSPM;
%----------------------------------------------------------------------------------
% Delete figures used by spm_getSPM if they were created during above call
%----------------------------------------------------------------------------------
if isempty(hFigInteractive) 
    delete(findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_Interactive)); 
end;
if isempty(hFigSelFileWin) 
    delete(findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_SelFileWin)); 
end;
if isempty(hFigConMan) 
    delete(findobj('Type', 'figure', 'Tag', ihbdfl_spm_fig_ConMan)); 
end;
%----------------------------------------------------------------------------------
% Check clusters
%----------------------------------------------------------------------------------
%if size(SPM.XYZ, 2) == 0
%    clusters = [];
%    h = warndlg('No voxels survive height threshold','Warning');
%    delete(h);
%    return;
%end
%----------------------------------------------------------------------------------
% Get file name to save results and open it
%----------------------------------------------------------------------------------
%[fname,pname] = uiputfile('*.txt', 'Selcect file to save report');
%if (~ischar(fname) | ~ischar(pname))
%    warndlg('Report creating canceled','Can not create report');
%    return; 
%end
%fileName = strcat(pname, fname);
%[path,name,ext,ver] = fileparts(fileName);
%fileName = fullfile(path,strcat(name, '.txt'));

%fid = fopen(fileName, 'wt');
%----------------------------------------------------------------------------------
% Initialize some variables
%----------------------------------------------------------------------------------
%A = spm_clusters(SPM.XYZ);
%numClust = max(A);
voxVol = prod(voxsize);
%fprintf(fid, '\nContrast name: %s\n', SPM.title);

% DEBUG KMM %%
global globalDB;
globalDB = DB;
% DEBUG %%

maxLabelLength = 0;
for iCLass = 1:DB.numClass
    for jClass = 1:DB.numClassSize(iCLass)
        maxLabelLength = max(maxLabelLength, size(DB.cNames{iCLass}{jClass}, 2));
    end
end
outputLineLength = maxLabelLength + 15;
voxX = DB.voxX;
voxY = DB.voxY;
voxZ = DB.voxZ;
volMNI = voxX*voxY*voxZ;
nVoxX = DB.nVoxX;
nVoxY = DB.nVoxY;
nVoxZ = DB.nVoxZ;
nVoxXY = nVoxX*nVoxY;
minX = DB.minX;
minY = DB.minY;
minZ = DB.minZ;

%----------------------------------------------------------------------------------
% Main cluster loop
%----------------------------------------------------------------------------------
%hWait = waitbar(0,'Processing. Please wait...');
%nTotalVox = size(A, 2);
%nTotalProcessed = 0;
%----------------------------------------------------------------------------------
%lenA = length(A);
%lenQQ = length(SPM.QQ);
%for q=1:lenQQ
%   if XYZ == SPM.XYZ(:,q)
%      break;
%   end
%end

%for curClust = 1:numClust
%curClust = A(q);
%--------------------------------------------------------------------
% Check current cluster size and skip if too small
%--------------------------------------------------------------------
%a = find(A == curClust);
%if (size(a, 2) < SPM.k)
%   nTotalProcessed = nTotalProcessed + size(a, 2);
%   waitbar(nTotalProcessed/nTotalVox);
%else    % if (size(a, 2) < SPM.k)
%--------------------------------------------------------------------
% Print title for the current cluster
%--------------------------------------------------------------------
%numVox = size(a, 2);
%XYZmm = SPM.XYZmm(:,a);
%XYZmm = SPM.XYZmm(:,q);
%maxInd = find(SPM.Z == max(SPM.Z(a)));
%maxCrd = SPM.XYZmm(:, maxInd(1));
%numVox = 1;
%title = SPM.title;
%fprintf(fid, '\n');
%fprintf(fid, 'Number of Voxels %d\n', numVox);
%fprintf(fid, 'Number of Voxels %d\n', 1);
%fprintf(fid, 'Max. coordinates %d %d %d\n', round(maxCrd));
%fprintf(fid, '%s\n', repmat('-', 1, outputLineLength));
%--------------------------------------------------------------------
% Init intersections volumes array
%--------------------------------------------------------------------
for iCLass = 1:DB.numClass
   for jClass = 1:DB.numClassSize(iCLass)
      vol{iCLass}{jClass} = 0;    
   end
end
%--------------------------------------------------------------------
% Voxel loop for current cluster
%--------------------------------------------------------------------
%for iVox = 1:numVox
%nTotalProcessed = nTotalProcessed + 1;
%waitbar(nTotalProcessed/nTotalVox);
x = voxX*round(posmm(1)/voxX);
y = voxY*round(posmm(2)/voxY);
z = voxZ*round(posmm(3)/voxZ);
nx = (x-minX)/voxX;
ny = (y-minY)/voxY;
nz = (z-minZ)/voxZ;
index = nz*nVoxXY + ny*nVoxX + nx + 1;

des = {};

% Modified by Danny Q. Chen. (10/16/2002)
% To keep ind inside the search list.
%if index > 0   
if index>0 && index<517845

   for iCLass = 1:DB.numClass
      ind = DB.data(index, iCLass);
      vol{iCLass}{ind} = vol{iCLass}{ind} + 1;   
   end
   
   
   %--------------------------------------------------------------------
   % Print report for current cluster
   %--------------------------------------------------------------------
   for iCLass = 1:DB.numClass
      if (showLabel(iCLass))
         for ind = 1:DB.numClassSize(iCLass)
            numVoxIntersection = vol{iCLass}{ind};
            if (numVoxIntersection)
               voi = (100*numVoxIntersection*voxVol)/(DB.volClass{iCLass}(ind)*volMNI);
               voiStr = sprintf('%8.2f', voi);
               space = repmat(' ', 1, maxLabelLength - size(DB.cNames{iCLass}{ind}, 2) + 1);
               name = DB.cNames{iCLass}{ind};
               if strcmp(name, 'Unidentified')
                  str = [];
               else                 
                  str = sprintf('%s%s%s\n', DB.cNames{iCLass}{ind}); 
               end
               des{iCLass} = str;               
            end % if (numVoxIntersection)
         end % for ind = 1:DB.numClassSize(iCLass)
         %fprintf(fid, '%s\n', repmat('-', 1, outputLineLength));
      end % if (showLabel(iCLass))
   end % for iCLass = 1:DB.numClass
else
   for iCLass = 1:DB.numClass
      des{iCLass} = '';               
   end  
end
end


function [x] = readhrtf(elev,azim,select,COEFS)
%
% function [x] = readhrtf(elev,azim,select,[COEFS])
%
% elev is elevation from -40 to 90 degrees
% azim is azimuth from 0 to 180 degrees
% select is:
%	'L' use full data from left pinna
%	'R' use full data from right pinna
%	'H' use compact data
% Returns stereo symmetrical hrtf in first two rows of
% x such that left is first row, right is second row.
%
% COEFS are a vector with the used hrtf coefficients, e.g.:
% COEFS = 23:149 , means that the hrtf data read starts at 23st coef. 
% with a length of 150.
% Bill Gardner
% Copyright 1995 MIT Media Lab. All rights reserved.
%

%
% Root directory for Macintosh or UNIX. Put your own in here.
%
%if (length(getenv('MACHTYPE')) == 0)
%	root = 'Pokey:hrtf';
%	dir_ch = ':';
%else
%if (isempty(getenv('KEMAR_ROOT')))
%     msg_error = sprintf('Set KEMAR_ROOT environment variable on shell\ne.g. : export KEMAR_ROOT=$HOME/kemar');
%     error(msg_error)
%else
%	root = getenv('HOME');

	root = sprintf('%s',getenv('KEMAR_HOME'));
	%dir_ch = '\'; %JFLN: Editado
    dir_ch = filesep;
%end
%
% check arguments
%

azim = round(azim);
%if ((azim < 0) | (azim > 180))
%	error('azimuth must be between 0 and 180 degrees');
%end
if ((elev < -40) | (elev > 90))
	error('elevation must be between -40 and 90 degrees');
end


%   
% format filename
%

if (azim < 0)                  %%
  azim = 360 + azim;           %%  by JULIO 
end                            %% 

if(azim >= 360)             %%
    azim = azim - 360;      %%  by JOSE
end                         %%

flip_azim = 360 - azim;
if (flip_azim == 360)
	flip_azim = 0;
end
ext = '.dat';
if (select == 'L')
	pathname = hrtfpath(root,dir_ch,'full',select,ext,elev,azim);
	x(1,:) = readraw(pathname);
	pathname = hrtfpath(root,dir_ch,'full',select,ext,elev,flip_azim);
	x(2,:) = readraw(pathname);
elseif (select == 'R')
	pathname = hrtfpath(root,dir_ch,'full',select,ext,elev,flip_azim);
	x(1,:) = readraw(pathname);
	pathname = hrtfpath(root,dir_ch,'full',select,ext,elev,azim);
	x(2,:) = readraw(pathname);
elseif (select == 'H')
	pathname = hrtfpath(root,dir_ch,'compact',select,ext,elev,azim);
	tmp = readraw(pathname);
	x(1,:) = tmp(1:2:length(tmp));
	x(2,:) = tmp(2:2:length(tmp));
else
        error(sprintf('%s not a valid selection, use L, R, or H',select));
end
      
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%
%%  NORMALIZATION OF HRTF (NORM OF DATA     %%
%%  WAS > 1 AND WAS CAUSING                 %% BY JULIO
%%  DISTORTION IN WAVE FILES )              %%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%

AUXpath = hrtfpath(root,dir_ch,'full','R',ext,40,45); 

%%
if nargin == 4 
%  msg = sprintf('!!!!readhrtf : Using only %d coeffcients starting on %d',length(COEFS),COEFS(1));
%  disp(msg);
else
  COEFS = 1:length(x);
end


AUXx = readraw(AUXpath);
NORM = norm(AUXx(:,COEFS));
%msg = sprintf('!!!!readhrtf WARNING!!!! Using normalized hrtf data --> divided by direction (40,45) (largest norm = %1.3f)',NORM);
%disp(msg);
x = x/NORM;
x = x(:,COEFS);


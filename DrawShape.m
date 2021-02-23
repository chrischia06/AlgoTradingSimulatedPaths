function DrawShape(v, color)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DrawShape(shape,colorcode);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function DrawShape(shape, color)
% 
% arguments:
% shape = shape list, size=(np,2), where np is the number of 
%         points in the shape
% color = (0,1,2,3) -> plotting using (black,red,green,blue)
%
% Note: the shape will automatically be closed by connecting
% the first and the last point marked.
%
%
%This file is part of the SpaSM Matlab toolbox.
%
%    SpaSM is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SpaSM is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

if nargin == 0
    error('Not enough input arguments.');
end
if nargin>2
    error('Too many input arguments.');
end
if nargin == 1
    color='r';
end

%line( v(:,2), v(:,1), 'Marker', '+','Color',color, 'LineWidth', 2 );
line( v(:,2), v(:,1),'Color',color, 'LineWidth', 1 );
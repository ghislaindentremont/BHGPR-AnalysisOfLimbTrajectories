function basisobj = create_FEM_basis(p, e, t, order, nquad)
%  CREATE_FEM_BASIS sets up a finite element basis for the analysis
%  of spatial data.  It requires a triangular mesh as input, such as is
%  set up by functions initmesh and refinemesh in the pde toolbox. 
%  The triangular mesh is defined by a Delaunay triangulation of the domain 
%  of the basis functions, along with, optionally, a decomposition of the 
%  domain into subdomains.  
%
%  The finite elements used for functional data analysis are second
%  order Lagrangian elements.  These are triangles covering a region,
%  and the basis system is piecewise quadratic.  There is a basis
%  function associated with each node in the system.
%  Nodes are points that are either:
%    vertices of triangles or
%    midpoints of edges of triangles.
%  There are 6 nodes for each triangle, and there are six degrees of 
%  freedom in a quadratic function in X and Y.  Consequently, the 6 values
%  of the nodal basis functions uniquely define a quadratic function over
%  a triangle.
%
%  Arguments:
%
%  P  ...  The NBASIS by 2 matrix of vertices of triangles containing
%          the X- and Y-coordinates of the vertices.
%          P may also be provided as a 2 by NBASIS matrix, such as would
%          be generated by exporting the mesh generated by function 
%          pdetool in the pde toolbox.
%  E  ...  The number of edges by 7 matrix defining the segments of the 
%          boundary of the region which are also edges of the triangles
%          adjacent to the boundary.  This would usually be generated by
%          exporting the mesh in function pdetool in the pde toolbox.
%          The values in matrix E as follows:
%          Columns 1 and 2:  the indices of the vertices in matrix P of
%          the starting and ending points of the edges
%          Columns 3 and 4:  the starting and ending parameter values.  
%          These are initialized to 0 and 1.
%          Column  5:        the edge segment number 
%          Columns 6 and 7:  the left and right-hand side subdomain numbers
%          E may also be provided as a 7 by number of edges matrix, which
%          is the format resulting from exporting the mesh in function
%          pdetool of the pde toolbox.
%          E is often not needed, and may be input as an empty object [].
%  T  ...  The no. of triangles by 4 matrix specifying triangles and 
%          their properties:
%          Columns 1 to 3:   the indices in P of the vertices of each 
%          triangle in counter-clockwise order.
%          Column  4:        the subdomain number of the triangle
%          T may also be provided with 3 columns, in which case the
%          final column is set to ones.  It may also be provided as
%          either a 3 or 4 by number of triangles matrix.  The latter 
%          format would result from exporting the mesh in the function
%          pdetool in the pde toolbox.
%  ORDER . Order of elements, which may be either 1 or 2 (default)
%  NQUAD . Number of quadrature points per side.  This is entered into
%          function triquad, which returns for each triangle NQUAD^2 
%          quadrature points and their associated weights for integrating a 
%          function over a mesh.  Default 0 or [];  This option uses Matlab
%          function triquad to set up quadrature points and weights 
%          which are stored in a two-dimensional cell array object,
%          the first dimension being the number of elements or triangles,
%          and the second dimension is of length 4, 2 columns for point
%          coordinates, and two for quadrature weights.
%  
%  Returns:
%
%  An object of the basis class with parameters stored in member params,
%  which in this case is a struct object with members p, e and t.

%  Last modified 22 June 2015 by Jim Ramsay.  In this modification,
%  any reference to the pde toolbox function pdetools has been 
%  eliminated.  Future work will not use this toolbox, which has been
%  essentially abandoned in an incomplete state by MathWorks.

%  check for number of arguments

if nargin < 3
    error('Less than three input arguments.');
end

%  default parameter values

if nargin < 5,  nquad = 0;  end
if nargin < 4,  order = 1;  end

%  check t for having 3 rows or columns, and add 1's to
%  make the dimension 4

[ntri, ncol] = size(t);
if ncol == 3
    %  add a column of 1's
    t = [t, ones(ntri,1)];
end

%  check dimensions of P, E and T 

if isempty(e)
    if size(p,2) ~= 2 || size(t,2) ~= 4
        error('Dimensions of at least one of P, E and T are not correct.');
    end    
else
    if size(p,2) ~= 2 || size(t,2) ~= 4
        error('Dimensions of at least one of P and T are not correct.');
    end
end

type     = 'FEM';
%  Argument rangeval is not needed for an FEM basis since domain
%  boundary is defined by the triangular mesh.
rangeval = [];  
%  The number of basis functions corresponds to the number of vertices
%  for order = 1, and to vertices plus edge midpoints for order = 2

%  set up the nodal points and corresponding mesh:  
%    this is p' and t(1:3,:)' in the order 1 case, but
%    includes mid-points in the order 2 case

nodeStruct = makenodes(p, t(:,1:3), order);

%  set up quadrature points and weights for integration over triangles
%  if nquad is provided, else default to {}

if ~isempty(nquad) && nquad > 0
    quadCell = cell(ntri,4);
    for itri=1:ntri
       [X,Y,Wx,Wy]=triquad(nquad,t(itri,1:3)); 
       quadCell{itri,1} = X;
       quadCell{itri,2} = Y;
       quadCell{itri,3} = Wx;
       quadCell{itri,4} = Wy;
    end
else
    quadCell = {};
end

%  The params argument is a struct object 

petstr.p         = p;
petstr.e         = e;
petstr.t         = t;
petstr.order     = order;
petstr.nodes     = nodeStruct.nodes;
petstr.nodeindex = nodeStruct.nodeindex;
petstr.J         = nodeStruct.J;
petstr.metric    = nodeStruct.metric;
petstr.quadmat   = quadCell;

params = petstr;

nbasis = size(nodeStruct.nodes,1);

basisobj = basis(type, rangeval, nbasis, params);
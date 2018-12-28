// TRIANGLE MESH
class MESH {
  // VERTICES
  int nv=0, maxnv = 1000;  
  pt[] G = new pt [maxnv];                        
  // TRIANGLES 
  int nt = 0, maxnt = maxnv*2;                           
  boolean[] isInterior = new boolean[maxnv];                                      
  // CORNERS 
  int c=0;    // current corner                                                              
  int nc = 0; 
  int[] V = new int [3*maxnt];   
  int[] O = new int [3*maxnt];  
  // current corner that can be edited with keys
  MESH() {
    for (int i=0; i<maxnv; i++) G[i]=new pt();
  };
  void reset() {
    nv=0; 
    nt=0; 
    nc=0;
  }                                                  // removes all vertices and triangles
  void loadVertices(pt[] P, int n) {
    nv=0; 
    for (int i=0; i<n; i++) addVertex(P[i]);
  }
  void writeVerticesTo(pts P) {
    for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);
  }
  void addVertex(pt P) { 
    G[nv++].setTo(P);
  }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {
    V[nc++]=i; 
    V[nc++]=j; 
    V[nc++]=k; 
    nt=nc/3;
  }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int t (int c) {
    int r=int(c/3); 
    return(r);
  }                   // triangle of corner c
  int n (int c) {
    int r=3*int(c/3)+(c+1)%3; 
    return(r);
  }         // next corner
  int p (int c) {
    int r=3*int(c/3)+(c+2)%3; 
    return(r);
  }         // previous corner
  pt g (int c) {
    return G[V[c]];
  }                             // shortcut to get the point where the vertex v(c) of corner c is located

  boolean nb(int c) {
    return(O[c]!=c);
  };  // not a border corner
  boolean bord(int c) {
    return(O[c]==c);
  };  // not a border corner

  pt cg(int c) {
    return P(0.6, g(c), 0.2, g(p(c)), 0.2, g(n(c)));
  }   // computes offset location of point at corner c

  // CORNER ACTIONS CURRENT CORNER c
  void next() {
    c=n(c);
  }
  void previous() {
    c=p(c);
  }
  void opposite() {
    c=o(c);
  }
  void left() {
    c=l(c);
  }
  void right() {
    c=r(c);
  }
  void swing() {
    c=s(c);
  } 
  void unswing() {
    c=u(c);
  } 
  void printCorner() {
    println("c = "+c);
  }



  // DISPLAY
  void showCurrentCorner(float r) { 
    if (bord(c)) fill(red); 
    else fill(dgreen); 
    show(cg(c), r);
  };   // renders corner c as small ball
  void showEdge(int c) {
    beam( g(p(c)), g(n(c)), rt );
  };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green inside, red outside
  {
    for (int v=0; v<nv; v++) 
    {
      if (isInterior[v]) fill(green); 
      else fill(red);
      show(G[v], r);
    }
  }                          
  void showInteriorVertices(float r) {
    for (int v=0; v<nv; v++) if (isInterior[v]) show(G[v], r);
  }                          // shows all vertices as dots
  void showTriangles() { 
    for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2));
  }         // draws all triangles (edges, or filled)
  void showEdges() {
    for (int i=0; i<nc; i++) showEdge(i);
  };         // draws all edges of mesh twice

  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
  {
    R.makeDelaunayEdges(BP);
  }  


  //1. How to find vertex neighbors for smoothing
  //2. How many subdivision levels for B-spline around a Voronoi face (??) --> 2+
  //    What is a Voronoi face? --> point in the middle of each triangle that connects with each vertex in equal lines = circumcenter of (V1, V2, V3)
  //3. What does cw mesh mean? --> List permutation of vertices so that loops goes clockwise for some given V (ex above floor)
  //4. Voronoi?
  //    5 points (neighbors) - we don't know that it has neighbors. 1. Find c (corner of V1) such that V[c] = V1
  //    int corneratVertex(int V1){
  //    for all c, if (V[c] == V1) --> return c
  //    }
  //    Write a loop that swings between the neighboring corners of V1 (goes around V1 in a circle)
  int count = 0;
  void computeO() // **02 implement it 
  {  
    for (int i=0; i<nc; i++) {
      O[i]=i;
    }
    count = nc;
    for (int i=0; i<nc; i++) {
      //O[i]=i;
      //count = nc;
      for (int d = i+1; d<nc; d++) {
        if (V[n(i)] == V[p(d)] && V[p(i)] == V[n(d)]) {
          O[i]=d; 
          O[d]=i; 
          count -= 2;
        }
      }
    }
    // **02 implement it
  } 

  void showBorderEdges()  // draws all border edges of mesh
  {
    for (int i=0; i<nc; i++) {
      if (O[i]==i) {
        showEdge(i);
      }
    } 
    // **02 implement;
  }         

  void showNonBorderEdges() // draws all non-border edges of mesh
  {
    for (int i=0; i<nc; i++) {
      if (O[i]!=i) {
        showEdge(i);
      }
    } 
    // **02 implement
  }        

  void classifyVertices() 
  { 
    for (int i=0; i<nv; i++) {
      isInterior[i] = true;
    }
    for (int i=0; i<nc; i++) {
      if (O[i] == i) {
        isInterior[V[p(i)]] = false;
        isInterior[V[n(i)]] = false;
      }
    }
    // **03 implement it
  }  

  int countBorders() {
    return count;
  }

  void smoothenInterior() { // even interior vertiex locations
    pt[] Gn = new pt[nv];
    // **04 implement it 
    for (int i=0; i<nv; i++) {
      int count = 0;
      int cr = 0;
      pt total = new pt();
      for (int c=0; c<nc; c++) {
        if (V[c]==i) {
          cr=V[n(c)];
          total.add(G[cr]);
          count++;
        }
        //System.out.println("i"+i);
        //System.out.println("cr"+cr);
      }
      total.div(count);
      Gn[i] = total;
    }
    for (int v=0; v<nv; v++) if (isInterior[v]) G[v].translateTowards(.1, Gn[v]);
  }


  // **05 implement corner operators in Mesh
  int v (int c) {
    return V[c];
  }                                // vertex of c
  int o (int c) {
    return O[c];
  }                                // opposite corner
  int l (int c) {
    //next opposite
    return O[n(c)];
  }                             // left
  int s (int c) {
    //next,opposite,next
    int j=c;
    if (O[n(c)]==n(c)) {
      while (O[p(j)] != p(j)) {
        j = p(O[p(j)]);
      }
    } else {
      j = n(O[n(c)]);
    }
    return j;
  }                             // left
  int u (int c) {
    int j=c;
    if (O[p(c)]==p(c)) {
      while (O[n(j)] != n(j)) {
        j = n(O[n(j)]);
      }
    } else {
      j = p(O[p(c)]);
    }
    return j;
  }                             // left
  int r (int c) {
    return O[p(c)];
  }                             // right


  void showOpposites()
  {
    for (int i=0; i<nc; i++) {
      drawParabolaInHat(G[V[i]], P(G[V[n(i)]], G[V[p(i)]]), G[V[O[i]]], 10);
    }
  }


  void showVoronoiEdges() // draws Voronoi edges on the boundary of Voroni cells of interior vertices
  { 
    // **06 implement it
    //pt left;
    //pt right;
    //pt cur;
    //pt mid1;
    //pt mid2;
    for (int i=0; i<nc; i++) {
      if (isInterior[V[i]]) {
        //cur = triCircumcenter(i);
        //left = triCircumcenter(l(i));
        //right = triCircumcenter(r(i)); 
        //mid1 = P(cur,left);
        //mid2 = P(cur,right);
        //show(mid1,mid2);
        int n=0;
        int f=s(i);
        int s=i;
        pt[] cen = new pt[nv-1];
        while (s!=f) {
          cen[n] = triCircumcenter(f);
          f=s(f);
          n++;
        }
        for (int k=0; k<=n-2; k++) {
          show(cen[k], cen[k+1]);
        }
      }
    }
  }   

  void drawVoronoiFaceOfInteriorVertices()
  {
    float dc = 1./(nv-1);
    for (int v=0; v<nv; v++) if (isInterior[v]) {
      fill(dc*255*v, dc*255*(nv-v), 200); 
      drawVoronoiFaceOfInteriorVertex(v);
    }
  }

  void drawVoronoiFaceOfInteriorVertex(int v)
  {
    int c = -1;
    int count = 0;
    while (c==-1) {
      if (V[count] == v) {
        c = count;
      }
      count++;
    }
    int f=s(c);
    int s=c;
    pt cen;
    beginShape();
    vertex(triCircumcenter(s));
    while (s!=f) {
      cen = triCircumcenter(f);
      f=s(f);
      vertex(cen);
    }
    endShape();
  }

  void showArcs() // draws arcs of quadratic B-spline of Voronoi boundary loops of interior vertices
  { 
    // **06 implement it
    pt mid1;
    pt mid2;
    for (int i=0; i<nc; i++) {
      if (isInterior[V[i]]) {
        int n=1;
        int f=s(i);
        int s=i;
        pt[] cen = new pt[nv-1];
        cen[0] = triCircumcenter(s);
        while (s!=f) {
          cen[n] = triCircumcenter(f);
          f=s(f);
          n++;
        }
        for (int k=0; k<n-1; k++) {
          if (k-1!=-1) {
            mid1 = P(cen[(k-1)%n], cen[k]);
            mid2 = P(cen[(k)], cen[(k+1)%n]);
            //System.out.println(n);
            drawParabolaInHat(mid1, cen[k], mid2, 10);
          } else {
            mid1 = P(cen[n-1], cen[k]);
            mid2 = P(cen[(k)], cen[(k+1)%n]);
            drawParabolaInHat(mid1, cen[k], mid2, 10);
          }
        }
      }
    }
  }               // draws arcs in triangles

  pt Y(int c) {
    return (triCircumcenter(c));
  }

  float dist = 0;
  int a = 14;
  int[] visited = new int [3*maxnv];
  int[] visitedPillars = new int [3*maxnv];
  void roombaMove(pt T) {
    vec path = U(V(Y(O[a]), Y(a)));
    float step = 2;
    if (T != g(a)) {
      if (d(Y(O[a]), Y(a)) - step > (d(Y(O[a]), Y(O[a]).add(dist, path)))) {
        dist += step;
        roomba = Y(O[a]).add(dist, path);
        distance1 += step;
      } else {
          pillarDirty[V[a]]=1;
          pillarDirty[V[n(a)]]=1;
          pillarDirty[V[p(a)]]=1;
          triangleDirty[a]=1;
          if (d(Y(a), T) < d(Y(l(a)), T) && d(Y(a), T) < d(Y(r(a)), T)){
          roomba = Y(a);
          dist = d(Y(a),Y(O[a]));
          visited[a]=1;
          visitedPillars[V[a]]=1;
          visitedPillars[V[n(a)]]=1;
          visitedPillars[V[p(a)]]=1;
        } else if (d(Y(O[a]), T) < d(Y(l(a)), T) && d(Y(O[a]), T) < d(Y(r(a)), T)){
          roomba = Y(a);
          visited[a]=1;
          visitedPillars[V[a]]=1;
          visitedPillars[V[n(a)]]=1;
          visitedPillars[V[p(a)]]=1;
          a = O[a];
          dist = 0;
        } else if (d(Y(l(a)), T) < d(Y(r(a)), T)){
          roomba = Y(a); //reset distance so i'm at the circumcenter
          visited[a]=1;
          visitedPillars[V[a]]=1;
          visitedPillars[V[n(a)]]=1;
          visitedPillars[V[p(a)]]=1;
          a=l(a);
          dist = 0;
        } else if (d(Y(l(a)), T) > d(Y(r(a)), T)){
          //System.out.println("left" + d(Y(l(a)), T));
          System.out.println("right" + d(Y(r(a)), T));
          roomba = Y(a); //reset distance so i'm at the circumcenter
          visited[a]=1;
          visitedPillars[V[a]]=1;
          visitedPillars[V[n(a)]]=1;
          visitedPillars[V[p(a)]]=1;
          a=r(a);
          dist = 0;
        }
      }
      //pt endPt;
      //if(d(Y(a),T) <= d(Y(l(c)), T) && d(Y(a),T) <= d(Y(r(c)), T) && d(Y(a),T) <= d(Y(o(c)),T)){
      //  float min = d(Y(a),T);
      //  endPt = Y(a);
      //}
    }
    //pt T = Of;
    //pick a random target and try to move the roomba towards that while on the voronoi edges
    //keep picking targets along the way (l, r)
    //find distance from l or r to the target Y(l(c));
    //array of visited corners
  }

  void roombaShow() {
    //fill(red);
    //show(cg(a), 10);
    //float d = 80;
    //float h = 20;
    float h;
    float d;
    d = (d(roomba, g(n(a))) - rb); 
    float vol = 200*3.14159265359*30*300;
    //float volNeeded = 3.14159265359*(d*d)*h;
    h = vol/(3.14159265359*(d*d));
    fill(orange); 
    pillar(roomba, h, d);
    pt potato = P(Of);
    potato.z = h;
    pt lettuce = P(roomba);
    lettuce.z = h;
    fill(red);
    cylinderSection(lettuce, potato, 10);
    fill(red); 
    cylinderSection(Of, P(Of, V(0, 0, h)), 10);
  }
  
  void trianglacolor() {
    for (int c=0; c<nc; c+=1){
      if (visited[c] == 1){
        fill(red);
        show(g(c), g(n(c)), g(p(c)));
      }
    }
  }
  
 void pillarmacolor() {
    for (int c=0; c<nv; c+=1){
      if (visitedPillars[c] == 1){
        fill(red);
        pillar(G[c],columnHeight+1,rb+1);
      }
    }
  }


  
  //if dirty swing and then go right
  int [] pillarDirty = new int [3*maxnv];
  int [] triangleDirty = new int [3*maxnv];
  void nonLiveMode() {
      pt T = g(a);
      if (pillarDirty[V[s(a)]] == 0){
        System.out.println("2 " + a);
        T = Y(s(a));       
      } else if(pillarDirty[V[r(a)]] == 0){
        System.out.println("3 " + a);
        T = Y(r(a));
      } else if(pillarDirty[V[l(a)]] == 0){
        System.out.println("4 " + a);
        T = Y(l(a));
      } else { 
        System.out.println("5 " + a);
        T = Y(O[a]);
      }
      roombaMove(T);
      distance2 += 2;
  }
  //if n(a) visited then go to the r(a)
  
  
  void trianglacolorAuto() {
    for (int c=0; c<nc; c+=1){
      if (triangleDirty[c] == 1){
        fill(cyan);
        show(g(c), g(n(c)), g(p(c)));
      }
    }
  }
  
  void cleanUp1() {
    for (int c=0; c<nc; c+=1){
      triangleDirty[c] = 0;
      pillarDirty[c] = 0;
    }
    distance2 += 0;
  }
  
  void cleanUp2() {
    for (int c=0; c<nc; c+=1){
      visited[c] = 0;
      visitedPillars[c] = 0;
    }
    distance1 += 0;
  }
  
 void pillarmacolorAuto() {
    for (int c=0; c<nv; c+=1){
      if (pillarDirty[c] == 1){
        fill(cyan);
        pillar(G[c],columnHeight+1,rb+1);
      }
    }
  }
  
  void roombaStep8Show() {
    float h;
    float d;
    //float h = 20;
    //float d = 80;
    d = (d(roomba, g(n(a))) - rb); 
    float vol = 200*3.14159265359*30*300;
    //float volNeeded = 3.14159265359*(d*d)*h;
    h = vol/(3.14159265359*(d*d));
    fill(orange); 
    pillar(roomba, h, d);
  }

  vec V1;
  float [] hitByRay = new float [3*maxnv];
  float d;
  float min;
  void rays(){
    nonLiveMode();
    for (float i = 0; i < 2*PI; i = i +(2*PI)/100){
      V1 = V(cos(i),sin(i),0);
      boolean exists = false;
      int id = -2;      
      for (int c=0; c<nv; c+=1){
        float x1 = -2;
        float x2 = -2;
        float a = dot(V1,V1);
        float b = -2*dot(V1,V(roomba,G[c]));
        float k = dot(V(roomba,G[c]),V(roomba,G[c])) - pow(rb,2);
        //d = (2*dot(V1,V(roomba,G[c]))+sqrt(pow(-2*dot(V1,V(roomba,G[c])),2)-4*dot(V1,V1)*dot(V(roomba,G[c]),V(roomba,G[c]))-rb))/(2*dot(V1,V1));
        if ((pow(b,2) - 4*a*k >= 0) && (a!=0)){
          x1 = (-b-sqrt(pow(b,2) - 4*a*c))/(2*a);
          x2 = (-b+sqrt(pow(b,2) - 4*a*c))/(2*a);
          fill(grey);
          beam(roomba, P(roomba,x1,U(V1)),5);
          beam(roomba, P(roomba,x2,U(V1)),5);
          exists = true;
          id = c;
        }
      }
      if (exists){
        hitByRay[id] = 1;
        fill(white);
        pillar(G[id], columnHeight-40, rb+8);
      }  
    }
  }
  
  void showHit(){
    fill(red);
    for (int i = 0; i<nv; i++){
      if (hitByRay[i] == 1){
        pillar(G[i], columnHeight-20, rb+4);
      }
    }
  }
  
  void showClean(){
    fill(cyan);
    for (int i = 0; i<nv; i++){
      if (visitedPillars[i] == 1){
        pillar(G[i], columnHeight+2, rb+2);
      }
    }
  }
  
  void lantern() {
     nonLiveMode();
     pt t = P(roomba);
     pt t2 = P(roomba);
     t.z = 30;
     t2.z = 10;
     float h;
     float d;
     d = (d(roomba, g(n(a))) - rb); 
     float vol = 200*3.14159265359*30*300;
     h = vol/(3.14159265359*(d*d));
     fill(yellow);
     pillar(t, h+10, 20);
     fill(black);
     pillar(t2, h+1, 21);

  }

  pt triCenter(int c) {
    return P(g(c), g(n(c)), g(p(c)));
  }  // returns center of mass of triangle of corner c
  pt triCircumcenter(int c) {
    return CircumCenter(g(c), g(n(c)), g(p(c)));
  }  // returns circumcenter of triangle of corner c
} // end of MESH

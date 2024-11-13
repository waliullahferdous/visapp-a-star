import java.lang.Math.*;

int screenSize = 700;
int gridSize = 20;
PImage img;
int imgX;
int imgY;
int rectSize = screenSize / gridSize;

Node[][] grid = new Node[gridSize][gridSize];

Node start;
Node end;
Node a;
Node b;
Node c;
Node d;
Node s;
ArrayList<Node> openSet;
ArrayList<Node> closedSet;
ArrayList<Node> path;

void setup() {
  size(700, 700);
  img = loadImage("car.png");
  imgX = 0;
  imgY = 0;

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j] = new Node(i, j);
    }
  }

  start = grid[imgX][imgY];
  start.gCost = start.cost = 0;
  start.wall = false;

  a = grid [10][4];
  a.wall = false;

  b = grid [10][10];
  b.wall = false;

  c = grid [4][16];
  c.wall = false;

  d = grid [19][19];
  d.wall = false;

  s = grid [0][0];
  s.wall = false;

  openSet = new ArrayList<Node>();
  closedSet = new ArrayList<Node>();
  path = new ArrayList<Node>();
  openSet.add(start);
}

double heuristic_cost_estimate(Node start, Node goal) {
  return Math.sqrt(Math.abs(goal.x - start.x)^2 + Math.abs(goal.y - start.y)^2);
}

Node getLowest(ArrayList<Node> list) {
  Node lowest = list.get(0);
  for (int i = 0; i < list.size(); i ++) {
    if (list.get(i).fCost < lowest.fCost) {
      lowest = list.get(i);
    }
  }
  return lowest;
}

ArrayList<Node> reconstructPath(Node current, ArrayList<Node> path) {
  if (current.parent == current) {
    return path;
  }
  path.add(current);
  return reconstructPath(current.parent, path);
}

void AStarSearch(Node goal) {
  Node current;
  while (openSet.size() > 0) {
    current = getLowest(openSet);

    if (current == goal) {
      return;
    }
    current.getNeighbors(grid);
    openSet.remove(current);
    closedSet.add(current);

    for (int i = 0; i < current.neighbors.size(); i++) {
      if (closedSet.contains(current.neighbors.get(i)) || current.neighbors.get(i).wall) {
        continue;
      }
      if (!openSet.contains(current.neighbors.get(i))) {
        openSet.add(current.neighbors.get(i));
      }

      double tentative_gCost = current.gCost + current.neighbors.get(i).cost;
      if (tentative_gCost >= current.neighbors.get(i).gCost) {
        continue;
      }

      current.neighbors.get(i).parent = current;
      current.neighbors.get(i).gCost = tentative_gCost;
      current.neighbors.get(i).fCost = current.neighbors.get(i).gCost + heuristic_cost_estimate(current.neighbors.get(i), goal);
    }
  }
}

void reset() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j].reset();
    }
  }
  start.gCost = start.cost = 0;
  openSet.clear();
  openSet.add(start);
  closedSet.clear();
}

void move() {
  int d = 1;
  Node currentDest;
  if (path.size() == 0) {
    currentDest = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
  } else {
    currentDest = path.get(path.size() - 1);
  }
  if (currentDest.x * rectSize == imgX && currentDest.y * rectSize == imgY) {
    path.remove(currentDest);
  }
  if (currentDest.x * rectSize > imgX) {
    imgX += d;
  }
  if (currentDest.x * rectSize < imgX) {
    imgX -= d;
  }
  if (currentDest.y * rectSize > imgY) {
    imgY += d;
  }
  if (currentDest.y * rectSize < imgY) {
    imgY -= d;
  }
}

void keyPressed() {
  if (key == 'a') {
    start = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
    reset();
    end = a;
    AStarSearch(end);
    path.clear();
    path = reconstructPath(end, path);
  }
  if (key == 'b') {
    start = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
    reset();
    end = b;
    AStarSearch(end);
    path.clear();
    path = reconstructPath(end, path);
  }
  if (key == 'c') {
    start = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
    reset();
    end = c;
    AStarSearch(end);
    path.clear();
    path = reconstructPath(end, path);
  }
  if (key == 'd') {
    start = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
    reset();
    end = d;
    AStarSearch(end);
    path.clear();
    path = reconstructPath(end, path);
  }
  if (key == 's') {
    start = grid[(int)Math.floor(imgX / rectSize)][(int)Math.floor(imgY / rectSize)];
    reset();
    end = s;
    AStarSearch(end);
    path.clear();
    path = reconstructPath(end, path);
  }
}


void draw() {
  background(255, 255, 255); 
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      fill(255, 255, 255);
      if (grid[i][j].wall) {
        fill(0, 0, 0);
      }
      if (grid [i] [j] == a || grid [i] [j] == b || grid [i] [j] == c || grid [i] [j] == d || grid [i] [j] == s) {
        fill (255, 0, 0);
      }
      rect(i*rectSize, j*rectSize, rectSize, rectSize);
    }
  }
  move();
  for (int i = 0; i < path.size(); i++) {
    fill(0, 255, 0);
    rect(path.get(i).x*rectSize, path.get(i).y*rectSize, rectSize, rectSize);
  }
  image(img, imgX, imgY, rectSize, rectSize);
}

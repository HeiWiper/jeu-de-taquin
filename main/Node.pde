class Node implements Comparable<Node>{
    int costG;      //g(n)
    float costH;        //h(n)
    Float costTotal;    //f(n) = g(n)+h(n)
    int[][] matrix;
    Node previous;      //parent node
    boolean found;

    Node (int costG, int[][] goalMatrix, int[][] matrix, Node previous, int heuristic) {
        this.costG = costG;
        this.matrix = matrix;
        if(heuristic==1)        //first heuristic
        setCostH1(goalMatrix);
        else if(heuristic==2)       //second heuristic
        setCostH2(goalMatrix);
        this.costTotal = this.costG + this.costH;
        this.previous = previous;
        if(costH == 0)      //check if the solution was found according to h(n)
            this.found = true;
        else
            this.found = false;
    }

    void setCostH1 (int[][] goalMatrix) {       //setting the h(n) for the first heuristic (non-similar boxes)
        float costH = 0;
        for (int i=0 ; i<3 ; i++) {
            for (int j=0 ; j<3 ; j++) {
                if(this.matrix[i][j] != goalMatrix[i][j])
                    costH+=2;       //this coefficient could be changed, but this has an effect on the result as it could find a non optimal solution
                    //2 seemed to be the best coefficient when comparing the results with other coefficients
            }
        }
        this.costH = costH;
    }

    void setCostH2 (int[][] goalMatrix) {       //setting the h(n) for the second heuristic (Euclidean distance)
        float costH = 0;
        Coordinates temp;
        for (int i=0 ; i<3 ; i++) {
            for (int j=0 ; j<3 ; j++) {
                if(this.matrix[i][j] != goalMatrix[i][j]) {
                    temp = getCoordinatesOf(matrix[i][j], goalMatrix);
                    costH+=sqrt(pow(float(temp.x - i),2)+pow(float(temp.y - j),2));
                }
            }
        }
        this.costH = costH;
    }

    @Override
    public int compareTo(Node node) {       //this function is necessary to compare between the total costs in the Priority Queue
        return this.costTotal.compareTo(node.costTotal);
    }
}

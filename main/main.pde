import g4p_controls.*;     //GUI library
import java.util.PriorityQueue;
import java.util.Stack;

//-----------------------------------------------------------------------------

ArrayList<PImage> imgList = new ArrayList<PImage>(8);       //numbers images
ArrayList<PImage> imgListSelected = new ArrayList<PImage>(8);       //numbers images (blue)
PImage smug, thinking, thinking1, thinking2, okhand, shocked, angry;        //custom images names
int selected, heuristic, score, existingNodeIndex, visitedNodes, startTime, endTime;
boolean found = false;
String mode = "NONE";
int[][] mainMatrix={{4,6,8},{2,7,5},{0,3,1}};
int[][] goalMatrix={{1,2,3},{8,0,4},{7,6,5}};
PriorityQueue<Node> queue = new PriorityQueue<Node>();      //equivalent of OPEN queue
ArrayList<String> visited = new ArrayList<String>();        //equivalent of CLOSED queue
ArrayList<Integer> costG = new ArrayList<Integer>();        //equivalent of CLOSED queue
Stack<Node> path = new Stack<Node>();          //used for building the path
Stack<Node> reversePath = new Stack<Node>();           //used for building the path
String stringMatrix = new String();         //used to convert the matrix to String for easier comparaison
Node temp = null, existingNode;
class Coordinates {         //just putting the coordinates in one place
    int x,y;
    Coordinates (int x, int y) {
        this.x = x;
        this.y = y;
    }
}

//-----------------------------------------------------------------------------

public void setup(){
    size(700, 330, JAVA2D);
    surface.setTitle("Jeu de Taquin");
    createGUI();
    customGUI();

    //setup code here
    for (int x = 0; x<8; x++) {     //loading the images of numbers
        imgList.add(loadImage(Integer.toString(x+1)+".png"));
    }
    for (int x = 0; x<8; x++) {     //loading the images of numbers (blue)
        imgListSelected.add(loadImage(Integer.toString(x+1)+"_selected.png"));
    }

    //loading the custom images
    thinking = loadImage("thinking.png");
    thinking1 = loadImage("thinking1.png");
    thinking2 = loadImage("thinking2.png");
    okhand = loadImage("okhand.png");
    smug = loadImage("smug.png");
    shocked = loadImage("shocked.png");
    angry = loadImage("angry.png");
}

//-----------------------------------------------------------------------------

public void draw(){
    refresh();      //refreshes the numbers positions

    if(found) {     //writing the score
        textSize(14);
        text("Score : "+score, 317, 56);
    }


    if(mode.equals("AUTO_1") || mode.equals("AUTO_2")) {        //the first and second method of problem-solving
        if(!queue.isEmpty() && !found){         //setting the custom image for when the algo is running
            image(thinking,275,157);
        }
        else {      //solution not found
            endTime = millis();
            println("Visited Nodes : "+visitedNodes);
            println("Elapsed Time : "+(endTime-startTime)+"ms\n\n");
            mode = "NOT_FOUND";
        }
        while(!queue.isEmpty() && !found) {         //the condition for when the search should continue
            temp = queue.poll();        //takes one node from the queue into temp
            visitedNodes++;

            if(temp.found == true) {        //solution found
                found = true;
                mode = "BACK_TRACKING";
                path.push(temp);
                score = temp.costG;
                endTime = millis();
                println("Visited Nodes : "+visitedNodes);
                println("Elapsed Time : "+(endTime-startTime)+"ms\n\n");
            }
            else {
                if(canZeroMoveUP(temp.matrix)) {        //checking if we can move the empty zero up to generate a child node
                    stringMatrix = matrixToString(moveZeroUP(temp.matrix));     //convert the genereted matrix to string to add it to the Arraylist of VisitedNodes
                    if(!visited.contains(stringMatrix)){        //checking if the generated matrix already exists
                        queue.add(new Node(temp.costG+1, goalMatrix, moveZeroUP(temp.matrix), temp, heuristic));
                        visited.add(stringMatrix);
                        costG.add(temp.costG+1);
                    }
                    else {      //if it doesn't exist
                        existingNodeIndex = visited.indexOf(stringMatrix);
                        if(costG.get(existingNodeIndex) > temp.costG+1) {
                            queue.add(new Node(temp.costG+1, goalMatrix, moveZeroUP(temp.matrix), temp, heuristic));
                            costG.set(existingNodeIndex, temp.costG+1);
                        }
                    }
                }

                if(canZeroMoveDOWN(temp.matrix)) {      //checking if we can move the empty zero down to generate a child node
                    stringMatrix = matrixToString(moveZeroDOWN(temp.matrix));       //convert the genereted matrix to string to add it to the Arraylist of VisitedNodes
                    if(!visited.contains(stringMatrix)){        //checking if the generated matrix already exists
                        queue.add(new Node(temp.costG+1, goalMatrix, moveZeroDOWN(temp.matrix), temp, heuristic));
                        visited.add(stringMatrix);
                        costG.add(temp.costG+1);
                    }
                    else {      //if it doesn't exist
                        existingNodeIndex = visited.indexOf(stringMatrix);
                        if(costG.get(existingNodeIndex) > temp.costG+1) {
                            queue.add(new Node(temp.costG+1, goalMatrix, moveZeroDOWN(temp.matrix), temp, heuristic));
                            costG.set(existingNodeIndex, temp.costG+1);
                        }
                    }
                }

                if(canZeroMoveRIGHT(temp.matrix)) {     //checking if we can move the empty zero right to generate a child node
                    stringMatrix = matrixToString(moveZeroRIGHT(temp.matrix));      //convert the genereted matrix to string to add it to the Arraylist of VisitedNodes
                    if(!visited.contains(stringMatrix)){        //checking if the generated matrix already exists
                        queue.add(new Node(temp.costG+1, goalMatrix, moveZeroRIGHT(temp.matrix), temp, heuristic));
                        visited.add(stringMatrix);
                        costG.add(temp.costG+1);
                    }
                    else {      //if it doesn't exist
                        existingNodeIndex = visited.indexOf(stringMatrix);
                        if(costG.get(existingNodeIndex) > temp.costG+1) {
                            queue.add(new Node(temp.costG+1, goalMatrix, moveZeroRIGHT(temp.matrix), temp, heuristic));
                            costG.set(existingNodeIndex, temp.costG+1);
                        }
                    }
                }

                if(canZeroMoveLEFT(temp.matrix)) {      //checking if we can move the empty zero left to generate a child node
                    stringMatrix = matrixToString(moveZeroLEFT(temp.matrix));       //convert the genereted matrix to string to add it to the Arraylist of VisitedNodes
                    if(!visited.contains(stringMatrix)){        //checking if the generated matrix already exists
                        queue.add(new Node(temp.costG+1, goalMatrix, moveZeroLEFT(temp.matrix), temp, heuristic));
                        visited.add(stringMatrix);
                        costG.add(temp.costG+1);
                    }
                    else {      //if it doesn't exist
                        existingNodeIndex = visited.indexOf(stringMatrix);
                        if(costG.get(existingNodeIndex) > temp.costG+1) {
                            queue.add(new Node(temp.costG+1, goalMatrix, moveZeroLEFT(temp.matrix), temp, heuristic));
                            costG.set(existingNodeIndex, temp.costG+1);
                        }
                    }
                }
            }
        }
    }

    else if(mode.equals("BACK_TRACKING")) {     //the mode in which the path is being built
        image(thinking,275,157);
        if(temp.costG != 0) {
            temp = temp.previous;
            path.push(temp);
        }
        else {
            mode = "SOLUTION";
        }
    }

    else if(mode.equals("SOLUTION")) {      //the mode when the path is built
        image(okhand,255,150);
    }

    else if(mode.equals("PLAY")) {      //the mode when the user is playing
        if(!found)
        image(smug,270,150);
        else
        image(shocked,255,150);
    }

    else if(mode.equals("EDIT_1")) {        //the mode when editing the start matrix
        image(thinking1,255,150);
    }
    else if(mode.equals("EDIT_2")) {        //the mode when editing the goal matrix
        image(thinking2,255,150);
    }
    else if(mode.equals("NOT_FOUND")) {     //the mode when the solution was impossible to find
        image(angry,250,144);
    }
}

//-----------------------------------------------------------------------------

void refresh(){     //refreshing the numbers images according to their positions in the matrices
    background(0);
    for (int i=0 ; i<3 ; i++) {
        for (int j=0 ; j<3 ; j++) {
            if(mainMatrix[i][j] != 0) {
                if(mode.equals("EDIT_1") && mainMatrix[i][j]==selected) {
                    image(imgListSelected.get(mainMatrix[i][j]-1), j*100, i*100);
                }
                else {
                    image(imgList.get(mainMatrix[i][j]-1), j*100, i*100);
                }
            }
            if(goalMatrix[i][j] != 0) {
                if(mode.equals("EDIT_2") && goalMatrix[i][j]==selected) {
                    image(imgListSelected.get(goalMatrix[i][j]-1), j*100+400, i*100);
                }
                else {
                    image(imgList.get(goalMatrix[i][j]-1), j*100+400, i*100);
                }
            }
        }
    }
}

//-----------------------------------------------------------------------------

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}

//-----------------------------------------------------------------------------

void mouseClicked() {       //managing the mouse clicks for both EDIT_1 and EDIT_2 modes to set the blue colour when a number is selected
    if(mode.equals("EDIT_1")) {
        if(mouseX>0 && mouseX<100 && mouseY>0 && mouseY<100){
            println(mainMatrix[0][0]);
            if(selected>=0){
                switchBetween(selected, mainMatrix[0][0], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[0][0];
        }
        else if(mouseX>100 && mouseX<200 && mouseY>0 && mouseY<100){
            if(selected>=0){
                switchBetween(selected, mainMatrix[0][1], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[0][1];
        }
        else if(mouseX>200 && mouseX<300 && mouseY>0 && mouseY<100){
            if(selected>=0){
                switchBetween(selected, mainMatrix[0][2], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[0][2];
        }
        else if(mouseX>0 && mouseX<100 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, mainMatrix[1][0], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[1][0];
        }
        else if(mouseX>100 && mouseX<200 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, mainMatrix[1][1], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[1][1];
        }
        else if(mouseX>200 && mouseX<300 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, mainMatrix[1][2], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[1][2];
        }
        else if(mouseX>0 && mouseX<100 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, mainMatrix[2][0], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[2][0];
        }
        else if(mouseX>100 && mouseX<200 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, mainMatrix[2][1], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[2][1];
        }
        else if(mouseX>200 && mouseX<300 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, mainMatrix[2][2], mainMatrix);
                selected=-1;
            }
            else
            selected = mainMatrix[2][2];
        }
    }
    else if(mode.equals("EDIT_2")) {
        if(mouseX>400 && mouseX<500 && mouseY>0 && mouseY<100){
            println(goalMatrix[0][0]);
            if(selected>=0){
                switchBetween(selected, goalMatrix[0][0], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[0][0];
        }
        else if(mouseX>500 && mouseX<600 && mouseY>0 && mouseY<100){
            if(selected>=0){
                switchBetween(selected, goalMatrix[0][1], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[0][1];
        }
        else if(mouseX>600 && mouseX<700 && mouseY>0 && mouseY<100){
            if(selected>=0){
                switchBetween(selected, goalMatrix[0][2], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[0][2];
        }
        else if(mouseX>400 && mouseX<500 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, goalMatrix[1][0], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[1][0];
        }
        else if(mouseX>500 && mouseX<600 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, goalMatrix[1][1], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[1][1];
        }
        else if(mouseX>600 && mouseX<700 && mouseY>100 && mouseY<200){
            if(selected>=0){
                switchBetween(selected, goalMatrix[1][2], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[1][2];
        }
        else if(mouseX>400 && mouseX<500 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, goalMatrix[2][0], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[2][0];
        }
        else if(mouseX>500 && mouseX<600 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, goalMatrix[2][1], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[2][1];
        }
        else if(mouseX>600 && mouseX<700 && mouseY>200 && mouseY<300){
            if(selected>=0){
                switchBetween(selected, goalMatrix[2][2], goalMatrix);
                selected=-1;
            }
            else
            selected = goalMatrix[2][2];
        }
    }
}

//-----------------------------------------------------------------------------

void keyPressed() {     //managing the directional keys clicks for both PLAY and SOLUTION modes
    if(mode.equals("PLAY")) {       //moving the 0 in the matrix (the empty box)
        if (key == CODED && ( keyCode == UP || keyCode == DOWN || keyCode == RIGHT || keyCode == LEFT)) {
            switch (keyCode) {
                case UP:
                moveUP();
                break;
                case DOWN:
                moveDOWN();
                keyCode = -1;       //bug related (only for RIGHT and DOWN)
                break;
                case RIGHT:
                moveRIGHT();
                keyCode = -1;       //bug related (only for RIGHT and DOWN)
                break;
                case LEFT:
                moveLEFT();
                break;
            }
            //check if the solution was found
            if(matrixToString(mainMatrix).equals(matrixToString(goalMatrix)))
            found = true;
            else
            found = false;
        }
    }
    else if(mode.equals("SOLUTION")) {      //using left and right keys to move  along the path nodes
        if (key == CODED && ( keyCode == UP || keyCode == DOWN || keyCode == RIGHT || keyCode == LEFT)) {
            switch (keyCode) {
                case RIGHT:
                next();
                keyCode = -1;       //bug related (only for RIGHT and DOWN)
                break;
                case LEFT:
                previous();
                break;
            }
        }
    }
}

//-----------------------------------------------------------------------------

//these four functions are used to move the 0 in the matrix for the PLAY mode
void moveUP() {
    Coordinates zero = getCoordinatesOf(0, mainMatrix);
    if (zero.x < 2 ) {
        switchBetween(mainMatrix[zero.x][zero.y], mainMatrix[zero.x+1][zero.y], mainMatrix);
        score++;
    }
}
void moveDOWN() {
    Coordinates zero = getCoordinatesOf(0, mainMatrix);
    if (zero.x > 0) {
        switchBetween(mainMatrix[zero.x][zero.y], mainMatrix[zero.x-1][zero.y], mainMatrix);
    }
}
void moveRIGHT() {
    Coordinates zero = getCoordinatesOf(0, mainMatrix);
    if (zero.y > 0) {
        switchBetween(mainMatrix[zero.x][zero.y], mainMatrix[zero.x][zero.y-1], mainMatrix);
        score++;
    }
}
void moveLEFT() {
    Coordinates zero = getCoordinatesOf(0, mainMatrix);
    if (zero.y < 2) {
        switchBetween(mainMatrix[zero.x][zero.y], mainMatrix[zero.x][zero.y+1], mainMatrix);
        score++;
    }
}

//-----------------------------------------------------------------------------

//gets the coordinates of a given number from the given matrix
Coordinates getCoordinatesOf(int target, int[][] matrix) {
    Coordinates temp = new Coordinates(-1, -1);
    int i, j;
    for (i=0 ; i<3 ; i++) {
        for (j=0 ; j<3 ; j++) {
            if(matrix[i][j] == target) {
                temp.x=i;
                temp.y=j;
                break;
            }
        }
        if(j==3) {
            j--;
        }
        if(matrix[i][j] == target){
            break;
        }
    }
    return temp;
}

//-----------------------------------------------------------------------------

//these four functions move the 0 zero in a specific direction for a given matrix
int[][] moveZeroUP(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    int[][] tempMatrix = copyOfMatrix(matrix);
    if (temp.x < 2 ) {
        tempMatrix[temp.x][temp.y] = tempMatrix[temp.x+1][temp.y];
        tempMatrix[temp.x+1][temp.y] = 0;
    }
    return tempMatrix;
}
int[][] moveZeroDOWN(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    int[][] tempMatrix = copyOfMatrix(matrix);
    if (temp.x > 0) {
        tempMatrix[temp.x][temp.y] = tempMatrix[temp.x-1][temp.y];
        tempMatrix[temp.x-1][temp.y] = 0;
    }
    return tempMatrix;
}
int[][] moveZeroRIGHT(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    int[][] tempMatrix = copyOfMatrix(matrix);
    if (temp.y > 0) {
        tempMatrix[temp.x][temp.y] = tempMatrix[temp.x][temp.y-1];
        tempMatrix[temp.x][temp.y-1] = 0;
    }
    return tempMatrix;
}
int[][] moveZeroLEFT(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    int[][] tempMatrix = copyOfMatrix(matrix);
    if (temp.y < 2) {
        tempMatrix[temp.x][temp.y] = tempMatrix[temp.x][temp.y+1];
        tempMatrix[temp.x][temp.y+1] = 0;
    }
    return tempMatrix;
}

//-----------------------------------------------------------------------------

//these four functions check if it is possible to move the zero to a specific direction for a given matrix
boolean canZeroMoveUP(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    if (temp.x < 2 ) {
        return true;
    }
    return false;
}
boolean canZeroMoveDOWN(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    if (temp.x > 0) {
        return true;
    }
    return false;
}
boolean canZeroMoveRIGHT(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    if (temp.y > 0) {
        return true;
    }
    return false;
}
boolean canZeroMoveLEFT(int[][] matrix) {
    Coordinates temp = getCoordinatesOf(0, matrix);
    if (temp.y < 2) {
        return true;
    }
    return false;
}

//-----------------------------------------------------------------------------

//these two functions are used in the SOLUTION mode to browse the path
void next() {
    Node temp;
    if(!path.empty()) {
        temp = path.pop();
        reversePath.push(temp);
        mainMatrix = temp.matrix;
    }
}
void previous() {
    Node temp;
    if(!reversePath.empty()) {
        temp = reversePath.pop();
        path.push(temp);
        mainMatrix = temp.matrix;
    }
}

//-----------------------------------------------------------------------------

//returns a copy of a given matrix
int[][] copyOfMatrix(int[][] matrix) {
    int[][] temp = new int[3][3];
    for (int i=0 ; i<3 ; i++) {
        for (int j=0 ; j<3 ; j++) {
            temp[i][j] = matrix[i][j];
        }
    }
    return temp;
}

//-----------------------------------------------------------------------------

//converts a matrix into a string (e.g {{1,2,3},{4,5,6},{7,8,0}} => "123456780")
String matrixToString(int[][] matrix) {
    StringBuilder sb = new StringBuilder();
    for (int i=0 ; i<3 ; i++) {
        for (int j=0 ; j<3 ; j++) {
            sb.append(matrix[i][j]);
        }
    }
    return sb.toString();
}

//-----------------------------------------------------------------------------

//switches between two numbers which are selected in the EDIT_1 or EDIT_2 modes
void switchBetween(int a, int b, int[][] matrix) {
    Coordinates temp = getCoordinatesOf(a, matrix);
    Coordinates temp2 = getCoordinatesOf(b, matrix);
    int swap;
    swap = matrix[temp.x][temp.y];
    matrix[temp.x][temp.y] = matrix[temp2.x][temp2.y];
    matrix[temp2.x][temp2.y] = swap;
}

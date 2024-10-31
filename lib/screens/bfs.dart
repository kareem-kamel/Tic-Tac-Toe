import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:collection';

class Bfs extends StatefulWidget {
  const Bfs({super.key});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Bfs> {
  List<String> board = List.filled(9, ""); // Initial empty board
  String currentPlayer = "X";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("BFS Tic-Tac-Toe",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => playerMove(index),
                  child: Container(
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: const Text("Restart Game"),
            ),
          ],
        ),
      ),
    );
  }

  void playerMove(int index) {
    if (board[index] == "" && currentPlayer == "X") {
      setState(() {
        board[index] = "X";
        if (checkWinner("X")) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Game Over"),
                content: const Text("You win!"),
                actions: [
                  TextButton(onPressed: resetGame, child: const Text("Play Again"))
                ],
              ));
        } else {
          currentPlayer = "O";
          computerMove();
        }
      });
    }
  }

  void computerMove() {
    int? index = getComputerMove();
    if (index != null) {
      setState(() {
        board[index] = "O";
        if (checkWinner("O")) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Game Over"),
                content: const Text("Computer wins!"),
                actions: [
                  TextButton(onPressed: resetGame, child: const Text("Play Again"))
                ],
              ));
        } else {
          currentPlayer = "X";
        }
      });
    }
  }

  int? getComputerMove() {
    Queue<List<String>> queue = Queue();
    Set<List<String>> visited = {};
    List<int> availableMoves = [
      for (int i = 0; i < 9; i++) if (board[i] == "") i
    ];

    // Check if the computer can win on this move
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = "O";
      if (checkWinnerForBoard("O", newBoard)) return move;
    }

    // Check if the player can win on the next move and block it
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = "X";
      if (checkWinnerForBoard("X", newBoard)) return move;
    }

    // Perform BFS for strategic move if no immediate win/block
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = "O";
      queue.add(newBoard);
    }

    while (queue.isNotEmpty) {
      List<String> currentState = queue.removeFirst();
      for (int nextMove = 0; nextMove < 9; nextMove++) {
        if (currentState[nextMove] == "") {
          List<String> newBoard = List.from(currentState);
          newBoard[nextMove] = "X";
          if (!visited.contains(newBoard)) {
            visited.add(newBoard);
            queue.add(newBoard);
          }
        }
      }
    }

    // If no strategic move, return random move
    return availableMoves.isNotEmpty ? availableMoves[(0)] : null;
  }

  bool checkWinnerForBoard(String player, List<String> board) {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];
    return winningCombinations.any(
          (combo) => combo.every((index) => board[index] == player),
    );
  }

  bool checkWinner(String player) {
    return checkWinnerForBoard(player, board);
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
    });
  }
}

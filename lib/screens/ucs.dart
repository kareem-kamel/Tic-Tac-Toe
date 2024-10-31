import 'dart:collection';
import 'dart:math';


import 'package:flutter/material.dart';

class Ucs extends StatefulWidget {
  const Ucs({super.key});

  @override
  _UCSTicTacToeState createState() => _UCSTicTacToeState();
}

class _UCSTicTacToeState extends State<Ucs> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe - UCS',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set leading/back icon color to white
        ),

      ),
      body: Column(
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
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.red[100],
                  ),
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
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }

  void playerMove(int index) {
    if (board[index] == '' && currentPlayer == 'X') {
      setState(() {
        board[index] = 'X';
        if (checkWinner('X')) {
          showMessage("You win!");
          resetGame();
        } else {
          currentPlayer = 'O';
          computerMove();
        }
      });
    }
  }

  void computerMove() {
    int? index = getComputerMove();
    if (index != null) {
      setState(() {
        board[index] = 'O';
        if (checkWinner('O')) {
          showMessage("Computer wins!");
          resetGame();
        } else {
          currentPlayer = 'X';
        }
      });
    }
  }

  int? getComputerMove() {
    Queue<Map<String, dynamic>> queue = Queue();
    Set<String> visited = {};
    List<int> availableMoves = [];

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') availableMoves.add(i);
    }

    // Check immediate winning or blocking moves
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = 'O';
      if (checkWinnerForBoard('O', newBoard)) return move;
    }

    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = 'X';
      if (checkWinnerForBoard('X', newBoard)) return move;
    }

    // UCS algorithm
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = 'O';
      queue.add({'board': newBoard, 'initial_move': move, 'cost': 0});
    }

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      List<String> currentState = current['board'];
      int initialMove = current['initial_move'];
      int cost = current['cost'];
      String stateKey = currentState.join();

      if (visited.contains(stateKey)) continue;
      visited.add(stateKey);

      if (checkWinnerForBoard('O', currentState)) {
        return initialMove;
      }

      List<int> nextMoves = [];
      for (int i = 0; i < 9; i++) {
        if (currentState[i] == '') nextMoves.add(i);
      }

      for (int nextMove in nextMoves) {
        List<String> newState = List.from(currentState);
        newState[nextMove] = 'X';
        int newCost = cost + 1;

        if (checkWinnerForBoard('X', newState)) {
          newCost += 10;
        } else if (checkWinnerForBoard('O', newState)) {
          newCost -= 10;
        }

        queue.add({'board': newState, 'initial_move': initialMove, 'cost': newCost});
      }

      // Sort the queue based on cost (UCS)
      queue = Queue.from(queue.toList()..sort((a, b) => a['cost'].compareTo(b['cost'])));
    }

    return availableMoves.isNotEmpty ? availableMoves[Random().nextInt(availableMoves.length)] : null;
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

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
    });
  }
}
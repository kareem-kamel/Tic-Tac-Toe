import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ids extends StatefulWidget {
  const Ids({super.key});

  @override
  _IDSTicTacToeState createState() => _IDSTicTacToeState();
}

class _IDSTicTacToeState extends State<Ids> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe - IDS',style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.orange,
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
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.orange[100],
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
    int index = getComputerMove();
    if (index != -1) {
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

  int getComputerMove() {
    List<int> availableMoves = [];

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') availableMoves.add(i);
    }

    // Check if the computer can win
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = 'O';
      if (checkWinnerForBoard('O', newBoard)) return move;
    }

    // Block the player's winning move
    for (int move in availableMoves) {
      List<String> newBoard = List.from(board);
      newBoard[move] = 'X';
      if (checkWinnerForBoard('X', newBoard)) return move;
    }

    // Perform IDS
    int maxDepth = availableMoves.length;

    for (int depth = 1; depth <= maxDepth; depth++) {
      for (int move in availableMoves) {
        List<String> newBoard = List.from(board);
        newBoard[move] = 'O';
        int result = ids(newBoard, depth - 1);
        if (result != -1) {
          return move;
        }
      }
    }

    // If no strategic move found, return a random available move
    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  int ids(List<String> board, int depth) {
    if (depth == 0) {
      return -1;
    }

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        List<String> newBoard = List.from(board);
        newBoard[i] = 'O';
        if (checkWinnerForBoard('O', newBoard)) {
          return i;
        }
        int result = ids(newBoard, depth - 1);
        if (result != -1) {
          return i;
        }
      }
    }
    return -1;
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
              child: Text('OK'),
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